//
//  ViewController.m
//  TossPayExampleForWebShop
//
//  Created by mr.park on 2015. 8. 5..
//
//

#import "WebShopViewController.h"
#import "TossPay.h"

@interface WebShopViewController ()<UIWebViewDelegate>

@property (weak, nonatomic) UIWebView *webView;

@end

static NSString * const DemoWebShopURLString = @"https://toss.im/tosspay/developer/testPay";
static NSString * const TossEnterPhoneNumberURLPath = @"/tosspay/order/orderWait";


@implementation WebShopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self loadDemoWebView];
}

#pragma mark - 테스트 결제 뷰

-(void)loadDemoWebView{
    
    [self configureWebView];
    [self requestTossDemoShopPage];
}

-(void)configureWebView{
    
    UIWebView *webView = [[UIWebView alloc]init];
    webView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self.view addSubview:webView];
    self.webView = webView;
    self.webView.delegate = self; 
    
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[webView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(webView)]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:webView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self.topLayoutGuide attribute:NSLayoutAttributeTop multiplier:1.0 constant:0.0]];
    
}

-(void)requestTossDemoShopPage{
    
    NSAssert(self.webView, @"WebView should be configured before request");
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:DemoWebShopURLString]];
    [self.webView loadRequest:request];
}


#pragma mark - UIWebViewDelegate


/*
 
 사용자 개인 정보 입력 화면 요청 Reqeuset 를 캐치하여 Toss 앱이 설치되어 있는 경우 Toss 앱을 직접 실행.
 
 */
-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if([request.URL.path isEqualToString:TossEnterPhoneNumberURLPath] && [TossPay isTossInstalled]){
     
        NSDictionary *params = [TossPay parseURLParams:request.URL.query];
        NSString *payToken = [params objectForKey:@"payToken"];
    
        if(payToken){
            
            /*
             //  x-callback-url parameter를 사용하지 않는 경우,
             [TossPay launchTossAppWithPayToken:payToken sourceName:nil successURL:nil successBlock:nil];
             
             */
            
            // x-callback-url paramger를 사용하는 경우.
            [TossPay launchTossAppWithPayToken:payToken sourceName:@"TossDemo" successURL:[NSURL URLWithString:@"tossPayExampleWebShop://tossPayCompleted"] successBlock:^{
                               
                UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Toss 결제 완료" message:nil delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil, nil];
                [alert show];
                
                [self requestTossDemoShopPage]; // 테스트 페이지를 Refresh 하여 추가 테스트가 가능하도록 함.
                
            }];
        }
        
        return  NO;
    }
    
    return YES;
}

@end
