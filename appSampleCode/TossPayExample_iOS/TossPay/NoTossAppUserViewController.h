//
//  NoTossAppUserViewController.h
//  TossPayDemo
//
//  Created by mr.park on 2015. 7. 17..
//  Copyright (c) 2015년 viva. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NoTossAppUserViewDelegate <NSObject>


/**
 
사용자가 개인정보를 입력 완료한 후에 '돌아가기' 버튼 누르는 시점을 알리기 위한 메소드
 
@param redirectURL redirectURL
 
 */
-(void)didNoTossAppUserPayRegisterCompletedWithURL:(NSURL*)redirectURL;

@end

/// 토스 앱이 설치되어 있지 않은 사용자에게 보여지는 UIViewController.
@interface NoTossAppUserViewController : UIViewController


/**
 
 Toss 가 설치되어 있지 않은 사용자에게 보여지는 ViewController. UIWebView로 구성되었으며 사용자가 개인정보를 입력하여 결제를 계속할 수 있도록 한다. 
 
 @param payToken Toss의 결제 생성 API를 통해 리턴받은 결제 토큰.
 @param redirectURL 개인정보 입력 완료 화면에서, '돌아가기' 버튼을 눌렀을 때 이동할 URL
 @return NoTossAppUserViewController 
 
 */
+(instancetype)noTossAppUserViewControllerWithPayToken:(NSString*)payToken redirectURL:(NSURL*)redirectURL;

@property (weak, nonatomic) id<NoTossAppUserViewDelegate> delegate;

@end
