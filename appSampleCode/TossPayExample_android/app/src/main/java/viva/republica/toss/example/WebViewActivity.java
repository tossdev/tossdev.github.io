package viva.republica.toss.example;

import android.app.ProgressDialog;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

/**
 * 결제 건은 성공적으로 생성되었지만, 주문을 완료하기 위해 사용자 정보(전화번호)를 입력하기 위한 Activity 입니다.
 * Activity 가 실행되면, 생성된 결제 Token을 이용하여, 결제를 진행합니다.
 */
public class WebViewActivity extends AppCompatActivity {

    private ProgressDialog mProgressDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_web_view);

        Intent intent = getIntent();
        //Intent에서 결제 토큰 정보를 가져옵니다.
        String payToken = intent.getStringExtra(TossConstants.INTENT_EXTRA_PAY_TOKEN);

        //결제 토큰이 올바르지 않을 경우 Activity 를 종료합니다.
        if (TextUtils.isEmpty(payToken)) {
            finish();
            return;
        }

        WebView webView = (WebView) findViewById(R.id.web_view);
        webView.setWebViewClient(new MyWebViewClient());

        WebSettings webSettings = webView.getSettings();
        webSettings.setJavaScriptEnabled(true);

        //주문을 완료하기 위해, 결제 토큰과 함께 사용자 정보를 입력하는 페이지를 불러옵니다.
        webView.loadUrl(TossConstants.ORDER_WAIT_URL + "?payToken=" + payToken);
    }

    private class MyWebViewClient extends WebViewClient {
        @Override
        public boolean shouldOverrideUrlLoading(WebView view, String url) {
            Uri uri = Uri.parse(url);

            //사용자 정보 입력이 완료되어, 주문 완료 페이지로 이동할 때 엡에서 처리하도록 합니다.
            if (Uri.parse(TossConstants.ORDER_COMPLETE_URL).getLastPathSegment().equals(uri.getLastPathSegment())) {

                //주문이 완료되었을 때, 토스 앱이 설치되어 있지 않으면 Play Store로 이동
                if (!TossUtils.isTossInstalled(WebViewActivity.this)) {
                    TossUtils.goToPlayStore(WebViewActivity.this);
                    finish();
                }
            }
            return false;
        }

        @Override
        public void onPageStarted(WebView view, String url, Bitmap favicon) {
            super.onPageStarted(view, url, favicon);

            if (mProgressDialog == null) {
                mProgressDialog = new ProgressDialog(WebViewActivity.this);
                mProgressDialog.setMessage("잠시만 기다려주세요.");
                mProgressDialog.show();
            }
        }

        @Override
        public void onPageFinished(WebView view, String url) {
            super.onPageFinished(view, url);
            if (mProgressDialog != null && mProgressDialog.isShowing()) {
                mProgressDialog.dismiss();
            }
        }
    }
}
