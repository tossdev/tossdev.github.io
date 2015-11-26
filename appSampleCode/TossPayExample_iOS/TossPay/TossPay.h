//
//  TossPay.h
//  TossPay
//
//  Created by mr.park on 2015. 8. 7..
//
//

#import <UIKit/UIKit.h>

typedef void (^tossSuccessBlock) (void);

@interface TossPay : NSObject

/**
 사용자 디바이스의 Toss 설치여부를 확인합니다. 
 
 
 iOS9의 경우,
 @code
 [[UIApplication sharedApplication] canOpenURL:]
 @endcode
 
 이 정상적으로 동작하려면 Toss의 URL Scheme이 가맹점 앱의 whiteList에 등록되어 있어야 합니다.
 아래 코드를 info.plist에 추가하면 등록됩니다.
 
 @code
 <key>LSApplicationQueriesSchemes</key>
 <array>
    <string>supertoss</string>
 </array>
 @endcode
 
 관련 내용은 링크를 참조하세요.
 @see http://awkwardhare.com/post/121196006730/quick-take-on-ios-9-url-scheme-changes
 
 @return Toss가 설치되어 있으면 YES, 그렇지 않으면 NO 
 */
+(BOOL)isTossInstalled;



/**
 Toss의 URL Scheme을 이용하여 Toss앱을 실행합니다. 
 
 Toss에서 결제가 완료되면, x-callback-url 을 통해 가맹점앱으로 돌아올 수 있습니다.
 @see http://x-callback-url.com/
 
 @param payToken Toss의 결제 생성 API를 통해 리턴받은 결제 토큰.
 @param sourceName Toss 앱에 표시될 가맹점 앱 이름. (nil 허용)
 @param successURL Toss 앱에서 결제 완료 후 호출될 URL (nil 허용)
 @param successBlock Toss 앱에서 결제 완료 후 x-callback-url 을 통해 가맹점 앱으로 돌아왔을 떄 실행되는 block (nil 허용)
 @return Toss앱을 정상적으로 실행시켰으면 YES, 그렇지 않으면 NO
 
 */
+(BOOL)launchTossAppWithPayToken:(NSString *)payToken sourceName:(NSString *)sourceName successURL:(NSURL *)successURL successBlock:(tossSuccessBlock)successBlock;



#pragma mark - Util

/**
 URL Query 파라미터를 key, value 형태로 분류합니다. 
 
 @param query 파싱하려는 URL Query
 @return 파싱 결과가 담긴 NSDictionary 객체
 
 */
+(NSDictionary*)parseURLParams:(NSString*)query;


/**
 x-callback-url에 등록한 successURL로 앱이 실행될 경우, successBlock을 실행합니다.
[UIApplication application:openURL:sourceApplication:annotation:] 추가 되어야 합니다.
 
 @param url URL 
 @return YES
 
 */
+(BOOL)hadleTossCallback:(NSURL*)url;


@end
