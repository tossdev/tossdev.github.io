package viva.republica.toss.example;

import android.content.Context;
import android.content.Intent;
import android.net.Uri;


/**
 * 토스 페이를 쉽게 사용하기 위한 Helper Class 입니다.
 * 토스의 설치여부를 확인하거나, 결제 시 앱을 실행하는 편의 기능 등을 제공합니다.
 */
public class TossUtils {

    /**
     * Toss 앱의 Package 이름
     */
    private static final String TOSS_PACKAGE_NAME = "viva.republica.toss";

    /**
     * 토스 앱의 설치 유무를 확인합니다.
     *
     * @param context 설치 여부를 확인하기 위해 사용하는 {@link Context}.
     * @return 설치가 되어있다면 true 아니라면 false 리턴합니다.
     */
    public static boolean isTossInstalled(Context context) {
        return context.getPackageManager().getLaunchIntentForPackage(TOSS_PACKAGE_NAME) != null;
    }

    /**
     * 결제를 하기 위해 토스 앱을 실행합니다.
     *
     * @param context  토스 앱을 실행하기 위해 사용하는 {@link Context}.
     * @param payToken 결제 시 사용되는 결제 Token
     */
    public static void launchForPayment(Context context, String payToken) {
        if (isTossInstalled(context)) {
            //Toss 앱의 설치 유무를 확인하고, 앱이 설치되어 있다면 토스의 main activity 를 실행하는 Intent를 반환합니다.
            Intent tossLauncherIntent = context.getPackageManager().getLaunchIntentForPackage(TOSS_PACKAGE_NAME);

            //PayToken 정보를 uri 포맷에 맞추어 생성합니다.
            //supertoss://pay?payToken=XXXXX
            Uri uri = Uri.parse("supertoss://pay?payToken=" + payToken);

            //Intent에 uri 형태로 생성된 PayToken 값을 설정합니다.
            tossLauncherIntent.setData(uri);
            //PayToken 정보와 함께 토스 앱을 실행합니다.
            context.startActivity(tossLauncherIntent);
        }
    }

    /**
     * Google Play Store 로 이동합니다.
     *
     * @param context Play Store로 이동하기 위해 사용하는 {@link Context}.
     */
    public static void goToPlayStore(Context context) {
        Intent intent = new Intent(Intent.ACTION_VIEW);
        intent.setData(Uri.parse("market://details?id=" + TOSS_PACKAGE_NAME));
        context.startActivity(intent);
    }
}
