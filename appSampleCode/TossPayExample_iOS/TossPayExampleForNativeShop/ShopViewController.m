//
//  ViewController.m
//  TossPayExampleForNativeShop
//
//  Created by mr.park on 2015. 8. 5..
//
//

#import "ShopViewController.h"
#import "TossPay.h"
#import "NoTossAppUserViewController.h"

@interface ShopViewController ()<NoTossAppUserViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *productNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *amountTextField;

@end

@implementation ShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Demo View

- (IBAction)didTossPayButtonClicked:(UIButton *)sender {
    
    NSString* productName = self.productNameTextField.text;
    int amount = [self.amountTextField.text intValue];
    
    if(productName.length == 0 || amount == 0){
        
        [self showAlertWithMsg:@"결제 정보를 입력하세요"];
        return;
    }
    
    [self hideKeyboard];
    
    // 결제 생성 요청
    // Example에서는 클라이언트에서 직접 Toss API 를 사용하지만, 적용시에는 가맹점 서버로의 요청을 권장합니다.
    [self createPayWithProductName:productName amount:amount];
}


-(void)hideKeyboard{
    
    [self.productNameTextField resignFirstResponder];
    [self.amountTextField resignFirstResponder];
    
}


-(void)showAlertWithMsg:(NSString*)msg{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:msg message:nil delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
    [alert show];
}


#pragma mark - Demo Server Request 

/*
 Toss API를 이용하여 결제를 생성 

 Example을 위해 클라이언트에서 직접 Toss API를 사용하지만, 적용시에는 클라이언트에서 가맹점 서버로 결제정보를 전달하고 가맹점 서버에서 Toss API를 이용하여 결제를 생성하는 것을 권장합니다. Toss API 사용에 필요한 API Key는 가맹점 서버에서만 사용하는게 안전합니다.
 예제를 위해 synchronous 요청으로 간단히 구현하였습니다.
 
 */
-(void)createPayWithProductName:(NSString*)productName amount:(int)amount{

#warning TODO - TossAPIKey에 Toss 가맹점 페이지에서 발급한 Test API Key를 입력하세요.
    static NSString * const TossAPIKey = @"YOUR_TEST_API_KEY";

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:@"https://pay.toss.im/tosspay/api/v1/payments"]];

    NSDictionary *params = @{@"orderNo" : [NSString stringWithFormat:@"%f", [[NSDate date] timeIntervalSince1970]], // orderNo는 매 결제건마다 고유한 값이어야 함. Example에서는 시간을 이용
                             @"amount" : [NSNumber numberWithInt:amount],
                             @"productDesc" : productName,
                             @"apiKey" :  TossAPIKey};
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:[NSJSONSerialization dataWithJSONObject:params options:0 error:nil]];
    
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *returnJson = [NSJSONSerialization JSONObjectWithData:returnData options:0 error:nil];
    
    
    // 결제 요청으로 생성한 payToken
    NSString *payToken = [returnJson objectForKey:@"payToken"];

    if(payToken){
        
        [self didPayCreatedForPayToken:payToken];
        
    }else{
        
        [self showAlertWithMsg:[returnJson objectForKey:@"msg"]];
    }
}


#pragma mark - TossPay 클라이언트 적용부분

/*
 
 payToken을 성공적으로 받아왔을 때 실행되는 메소드. Toss앱이 설치되었을 경우 Toss앱을 바로 실행시키고, Toss앱이 설치되어 있지 않은 경우 사용자가 전화번호를 입력할 수 있는 화면을 보여줌.
 
 */
-(void)didPayCreatedForPayToken:(NSString*)payToken{
    
    if([TossPay isTossInstalled]){
        
        /* 
         x-callback-url parameter를 사용하지 않는 경우,
         
         [TossPay launchTossAppWithPayToken:payToken sourceName:nil successURL:nil successBlock:nil];
        */
        
        
        // x-callback-url paramger를 사용하는 경우.
        [TossPay launchTossAppWithPayToken:payToken sourceName:@"TossDemo" successURL:[NSURL URLWithString:@"tossPayExample://tossPayCompleted"] successBlock:^{
            
            [self showAlertWithMsg:@"Toss 결제 완료"];
            
        }];
        
    }else{
        
        // Toss앱이 설치되지 않은 사용자에게는 전화번호를 입력할 수 있는 화면을 보여줌.
        [self presentNoTossAppViewControllerWithPayToken:payToken];
    }
    
}


-(void)presentNoTossAppViewControllerWithPayToken:(NSString*)payToken{
    
    /*
     
     redirectURL은 사용자가 전화번호 입력 완료한 화면에서, 사용자가 '쇼핑몰 돌아가기' 버튼을 누를 경우 요청되는 URL
     예제에서는 임의의 값을 입력하고, NoTossAppUserViewController에서 해당 URL을 캐치하여 NoTossAppUserViewDelegate로 완료를 전달함.

     redirectURL 이 없으면, 사용자가 전화번호를 입력한 후의 페이지에 '쇼핑몰로 돌아가기' 버튼이 보이지 않음.
     
     */
    NoTossAppUserViewController *noTossAppUserViewController = [NoTossAppUserViewController noTossAppUserViewControllerWithPayToken:payToken redirectURL:[NSURL URLWithString:@"https://testshop/tossComplete"]];

    noTossAppUserViewController.delegate = self;
    
    [self presentViewController:noTossAppUserViewController animated:YES completion:nil];
}


-(void)didNoTossAppUserPayRegisterCompletedWithURL:(NSURL *)redirectURL{
    
    [self dismissViewControllerAnimated:YES completion:^{
       
        [self showAlertWithMsg:@"사용자 전화번호 입력 완료."];
    }];
}

@end
