//
//  NoTossAppUserViewController.m
//  TossPayDemo
//
//  Created by mr.park on 2015. 7. 17..
//  Copyright (c) 2015년 viva. All rights reserved.
//

#import "NoTossAppUserViewController.h"
#import "TossPay.h"

@interface NoTossAppUserViewController ()<UIWebViewDelegate>

@property (strong, nonatomic) NSString *payToken;
@property (strong, nonatomic) NSURL *redirectURL;

@property (weak, nonatomic) UIWebView *webView;

@end

@implementation NoTossAppUserViewController

+(instancetype)noTossAppUserViewControllerWithPayToken:(NSString *)payToken redirectURL:(NSURL *)redirectURL{
    
    NoTossAppUserViewController *tossViewController = [[NoTossAppUserViewController alloc]init];
    
    tossViewController.payToken = payToken;
    tossViewController.redirectURL = redirectURL;

    return tossViewController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self configureWebView];
    [self loadWebViewWithPayToken:self.payToken redirectURL:self.redirectURL];
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
    
    if(self.navigationController){
        
        UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemStop target:self action:@selector(didCloseButtonClicked:)];
        [self.navigationItem setRightBarButtonItem:closeButton];
    }
}

-(void)didCloseButtonClicked:(id)sender{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)loadWebViewWithPayToken:(NSString*)payToken redirectURL:(NSURL*)redirectURL{
    
    NSAssert(self.webView, @"webView should be exsited");
    NSAssert(payToken, @"payToken should not be nil");
    
    NSString *urlString = [NSString stringWithFormat:@"https://toss.im/tosspay/order/orderWait?payToken=%@", payToken];
   
    if(redirectURL){
        
        urlString = [urlString stringByAppendingString:[NSString stringWithFormat:@"&retUrl=%@", redirectURL.absoluteString]];
    }
    
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlString]]];
}

-(void)informTossPayCompleteToDelegateWithUrl:(NSURL*)url{
    
    if([self.delegate respondsToSelector:@selector(didNoTossAppUserPayRegisterCompletedWithURL:)]){
        
        [self.delegate didNoTossAppUserPayRegisterCompletedWithURL:url];
    }
    
}

#pragma mark - UIWebViewDelegate

-(BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    
    if(self.redirectURL && [self.redirectURL.absoluteString isEqualToString:request.URL.absoluteString]){
    
        [self informTossPayCompleteToDelegateWithUrl:self.redirectURL];
        
    }
    
    return YES;
}

@end
