package viva.republica.toss.example;

/**
 * 토스 결제를 위해 필요한 URL, PARAMETER 정보를 제공합니다.
 */

public class TossConstants {

    private TossConstants() {

    }

    /**
     * 토스 결제 HOME URL
     */
    private static final String TOSS_PAY_HOME = "https://toss.im/tosspay";

    /**
     * 토스 결제 주문 HOME URL
     */
    private static final String ORDER_HOME = TOSS_PAY_HOME + "/order";

    /**
     * 토스 결제 생성 API URL
     */
    public static final String PAYMENT_API_URL = TOSS_PAY_HOME + "/api/v1/payments";

    /**
     * 결제를 생성하고, 구매자의 전화번호를 입력하는 URL
     */
    public static final String ORDER_WAIT_URL = ORDER_HOME + "/orderWait";

    /**
     * 결제 생성 후, 구매자의 전화번호 입력이 완료되었을 때 이동하는 URL
     */
    public static final String ORDER_COMPLETE_URL = ORDER_HOME + "/orderComplete";

    /**
     * 결제 Token을 INTENT에 전달 시 사용하는 EXTRA 이름
     */
    public static final String INTENT_EXTRA_PAY_TOKEN = "viva.republica.toss.intent.extra.PAY_TOKEN";

    /**
     * Toss 가맹점 페이지에서 발급한 API Key
     */
    public static final String PARAM_API_KEY = "apiKey";

    /**
     * 가맹점의 상품 주문 번호 파라미터
     */
    public static final String PARAM_ORDER_NO = "orderNo";

    /**
     * 주문하려는 상품의 금액 파라미터
     */
    public static final String PARAM_AMOUNT = "amount";

    /**
     * 주문하려는 상품 설명 파라미터
     */
    public static final String PARAM_PRODUCT_DESC = "productDesc";

    /**
     * 결제 만료 기한 파라미터 (기본값 : 최장 24시간, 최단 10분)
     * 형식 : 1970-01-01 00:00:00
     */
    public static final String PARAM_EXPIRED_TIME = "expiredTime";

    /**
     * 결제 전 주문 가능 여부를 최종 확인하기 위한 callback URL 파라미터
     * 아직 품절되거나 취소되지 않았는지 확인할 수 있습니다.
     */
    public static final String PARAM_ORDER_CHECK_CALLBACK_URL = "orderCheckCallback";

    /**
     * 결제 결과 callback URL 파라미터
     * (성공, 취소, 환불 등)
     */
    public static final String PARAM_RESULT_CALL_BACK_URL = "resultCallback";

    /**
     * 서버에 요청 시 결과 코드 파라미터
     */
    public static final String PARAM_RESULT_CODE = "code";

    /**
     * 가맹점의 상품 주문 번호 파라미터
     */
    public static final String PARAM_PAY_TOKEN = "payToken";

    /**
     * 서버에 요청 실패 사유 파라미터
     */
    public static final String PARAM_MSG = "msg";

    /**
     * 결제 생성이 성공적으로 완료 되었을 때의 결과 값
     */
    public static final int RESULT_SUCCEED = 0;

    /**
     * 결제 생성을 실패하였을 때의 결과 값
     */
    public static final int RESULT_FAILED = 10;

    /**
     * 결제 생성 시 중복 주문 번호에 의한 실패
     */
    public static final int RESULT_FAILED_ORDER_DUPLICATED = 11;

    /**
     * 결제 생성 시 1회 결제 한도 초과 금액에 의한 실패
     */
    public static final int RESULT_FAILED_EXCEED_LIMIT = 12;

}
