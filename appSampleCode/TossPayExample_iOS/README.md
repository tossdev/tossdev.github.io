# Toss Payment : iOS Sample Code

가맹점 앱에서 Toss 결제가 선택되었을 때, Toss 앱이 설치되어 있는 경우 Toss 앱을 실행시켜 결제를 진행할 수 있습니다. 
TossPayExample 프로젝트는 그 방법을 설명합니다. 


## 1. 프로젝트 구성

TossPayExample은 다음과 같이 3개의 Target으로 구성됩니다.

  - TossPayExampleForWebShop : 결제가 웹뷰에서 수행되는 가맹점을 위한 예제 
  - TossPayExampleForNativeShop : 결제가 웹뷰가 아닌 Native View에서 수행되는 가맹점을 위한 예제
  - TossPay : 위 두 타겟에서 Toss를 실행할 때 사용하는 메소드 모음. 

## 2. 앱에서의 Toss 결제 과정

Toss 결제를 사용하기 위해서는 먼저 아래 링크를 통해 가맹점 등록을 해야 합니다. 

  - https://toss.im/tosspay/account/signup
 
가맹점에 등록이 완료되면 Toss 결제를 요청할 수 있는 API Key 가 발급됩니다. 
가맹점 서버는 API Key를 이용하여 Toss 서버에 결제 생성을 요청할 수 있습니다.
서버 개발을 위한 자세한 내용은 아래 링크를 참고하세요. 

  - http://tossdev.github.io/
 
사용자가 가맹점 앱에서 Toss 결제를 선택하면, 가맹점 서버는 Toss API를 이용하여 Toss 결제 토큰 (PayToken)을 생성합니다. 앱에서는 생성된 PayToken을 이용하여 결제를 진행합니다. 

#### Toss 앱이 설치된 경우

Toss 앱이 설치되어 있는 경우, 가맹점 앱은 Toss의 URL Scheme을 이용하여 PayToken을 Toss 앱에 전달합니다. Toss 앱은 Toss 앱의 사용자 정보를 이용하여 가맹점 앱에서 발행한 PayToken과 사용자를 매칭하고 결제 화면을 사용자에게 보여줍니다. 사용자는 Toss 앱에 설정한 비밀번호를 입력하여 결제를 완료할 수 있습니다. 

Toss 앱이 설치되어 있지만 아직 로그인이 되어 있지 않은 경우, 사용자는 로그인을 진행하여 결제를 계속할 수 있습니다. 사용자가 로그인을 완료하는 시점에 Toss 앱은 PayToken과 사용자를 매칭하고 결제 화면을 사용자에게 보여줍니다. 사용자는 Toss 앱에 설정한 비밀번호를 입력하여 결제를 완료할 수 있습니다. 

#### Toss 앱이 설치되어 있지 않은 경우

Toss 앱이 설치되어 있지 않은 경우, 가맹점 앱은 사용자가 개인정보(전화번호)를 입력하는 웹페이지를 보여줌으로써 결제를 진행할 수 있습니다.

## 3. UIWebView에서 결제가 요청되는 경우

TossPayExampleForWebShop Target이 결제가 웹뷰에서 이뤄지는 경우를 위한 예제입니다.

#### WebShopViewController

테스트 결제 화면입니다. 가맹점 등록 후에 사용할 수 있는 테스트 결제 페이지를 이용하였으며, 앱 실행시 로그인이 필요합니다. 

Toss는 기본적으로 PC, Mobile 의 웹페이지에서 결제 요청을 하는 경우, 사용자의 개인정보를 입력하는 페이지로 이동시킵니다. 가맹점 앱이 UIWebView로 구성되어 있는 경우엔 `[UIWebViewDelegate webView:shouldStartLoadWithRequest:navigationType:]` 에서 사용자 전화번호 입력 페이지 로딩 Request를 캐치하여 Toss앱이 설치되어 있는 경우, Toss 앱을 실행시킵니다. 

## 4. Native View에서 결제가 요청되는 경우

TossPayExampleForNativeShop Target이 결제가 웹뷰가 아닌 UIView에서 결제가 이뤄지는 경우를 위한 예제입니다. 

#### ShopViewController

상품명과 가격을 입력할 수 있는 화면으로 구성되어 있습니다. 예제에선 Toss API를 이용한 결제 생성을 앱에서 수행합니다. 이를 위해 Toss 가맹점 등록 후 발행되는 Test API Key를 입력해야 합니다. (실제 적용시에는 앱에서 직접 결제 생성하는 것을 권장하지 않습니다. Toss API Key는 서버에서 관리되고 노출되지 않도록 해야합니다.)

결제 생성 API 를 통해 PayToken이 생성되면, Toss URL Scheme을 이용하여 Toss 앱을 실행시킵니다. Toss가 설치되어 있지 않은 경우, 사용자가 개인정보를 입력할 수 있는 화면이 모달뷰로 나타납니다. 

## 5. TossPay Target

TossPayExampleForWebShop 및 TossPayExampleForNativeShop 에서 Toss 결제를 진행하기 위해 사용하는 메소드 모음입니다. 예제를 위해 준비된 메소드인 만큼, 가맹점 앱 상황에 맞게 변경하여 사용하세요. 

#### TossPay

Toss 앱 설치 여부 확인 및 Toss 앱을 URL Scheme 으로 실행하는 메소드가 정의되어 있습니다. 

  - +(BOOL)isTossInsatlled
  - +(BOOL)launchTossAppWithPayToken:sourceName:successURL:successBlock:

URL Scheme을 실행할 떄 x-callback-url 파라미터를 지정할 수 있습니다. (단, x-source 및 x-success 파라미터만 지원합니다.)
x-callback-url 파라미터는 사용자가 Toss 앱을 통해 결제를 완료했을 때, 다시 가맹점으로 돌아갈 수 있는 인터페이스를 보여줍니다. 

#### NoTossAppUserViewController 

Toss 앱이 설치되어 있지 않을 경우에 화면에 보여지는 사용자 개인정보 입력화면입니다. UIWebView로 구성되어 있으며 웹 페이지 URL은 소스 코드 내에 정의되어 있습니다. (예제에서는 TossPayExampleForNativeShop에서만 사용합니다.)

사용자 정보 입력 화면 웹 페이지는 payToken과 retUrl 을 파라미터로 받습니다. retUrl은 개인정보 입력 완료 후 화면에서, 사용자가 '가맹점으로 돌아가기' 버튼을 누를 경우에 요청되는 URL 입니다. NoTossAppUserViewController에서는 retUrl을 임의의 값으로 전달하고 `[UIWebViewDelegate webView:shouldStartLoadWithRequest:navigationType:]` 를 이용하여 retUrl이 요청되는 시점을 캐치하여, NoTossAppUserViewDelegate 를 통해 결제 화면에 전화번호 입력 완료 시점을 전달합니다. 

에제를 위해 만든 ViewController 이니 참고하시어 가맹점 상황에 맞게 변경하여 사용하세요. 

## 6. Support

앱 개발시 어려운 부분이나 개선 관련 피드백이 있다면 mr.park@toss.im 으로 메일주세요. 도움 드리도록 하겠습니다.

## 7. 향후 계획

가맹점 앱에서 Toss 결제를 위한 개발이 수월하도록 라이브러리를 제공할 예정입니다. 

## 8. License

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
Version 2, December 2004

Copyright (C) 2015 Viva Republica

Everyone is permitted to copy and distribute verbatim or modified
copies of this license document, and changing it is allowed as long
as the name is changed.

DO WHAT THE FUCK YOU WANT TO PUBLIC LICENSE
TERMS AND CONDITIONS FOR COPYING, DISTRIBUTION AND MODIFICATION

0. You just DO WHAT THE FUCK YOU WANT TO.


