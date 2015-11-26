package viva.republica.toss.example;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.widget.Button;
import android.widget.Toast;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;


public class MainActivity extends AppCompatActivity implements View.OnClickListener {

    //Toss 가맹점 페이지에서 발급한 API Key를 입력하세요.
    private static final String API_KEY = "여기에 API KEY를 넣어주세요";

    private ProgressDialog mProgressDialog;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        if (API_KEY.contains("API KEY")) {
            throw new IllegalStateException("API KEY를 올바르게 입력해주세요");
        }

        Button payWithTossBtn = (Button) findViewById(R.id.pay_with_toss_btn);
        payWithTossBtn.setOnClickListener(this);
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.pay_with_toss_btn:
                //"토스로 결제" 버튼을 누르면 API 서버에 결제 생성을 요청 합니다.
                new RequestTask(generatePaymentParams()).execute(TossConstants.PAYMENT_API_URL);
                break;
        }
    }

    /**
     * 결제 생성 API 요청에 필요한 파라미터들을 설정합니다.
     * 파라미터에 대한 자세한 정보는 https://toss.im/tosspay/developer/apidoc#charge 에서 확인 할 수 있습니다..
     *
     * @return 테스트 결제용으로 10,000원짜리 상품에 대한 파라미터 {@link JSONObject}
     */
    private JSONObject generatePaymentParams() {
        JSONObject params = new JSONObject();
        try {
            //필수 항목
            params.put(TossConstants.PARAM_API_KEY, API_KEY);
            //필수 항목, 테스트 용도로 매번 다른 주문번호를 생성하도록 함
            params.put(TossConstants.PARAM_ORDER_NO, System.currentTimeMillis());
            //필수 항목
            params.put(TossConstants.PARAM_AMOUNT, 10000);
            //필수 항목
            params.put(TossConstants.PARAM_PRODUCT_DESC, "테스트 결제");

        } catch (JSONException e) {
            e.printStackTrace();
        }

        return params;
    }

    /**
     * 결제 건이 성공적으로 생성되면 토스 앱을 실행하거나, 사용자 정보를 입력받는 페이지를 통해 주문을 완료합니다.
     *
     * @param payToken 결제 시 사용되는 결제 Token
     */
    private void payWithToss(String payToken) {
        if (TossUtils.isTossInstalled(this)) {
            TossUtils.launchForPayment(this, payToken);
        } else {
            Intent intent = new Intent(this, WebViewActivity.class);
            intent.putExtra(TossConstants.INTENT_EXTRA_PAY_TOKEN, payToken);
            startActivity(intent);
        }
    }

    /**
     * 결제 API 서버에 결제 생성을 요청하고, 성공 시 결제를 시도합니다.
     */
    private class RequestTask extends AsyncTask<String, Void, String> {

        private JSONObject params;

        public RequestTask(JSONObject params) {
            this.params = params;
        }

        public String readSomething(InputStream in) throws IOException {
            StringBuilder content = new StringBuilder();
            String line;
            BufferedReader br = new BufferedReader(new InputStreamReader(in, "UTF-8"));
            while ((line = br.readLine()) != null) {
                content.append(line);
            }

            return content.toString();
        }

        @Override
        protected void onPreExecute() {
            super.onPreExecute();
            if (mProgressDialog == null) {
                mProgressDialog = new ProgressDialog(MainActivity.this);
                mProgressDialog.setCancelable(false);
                mProgressDialog.setMessage("서버와 통신중입니다.");
            }
            mProgressDialog.show();
        }

        @Override
        protected String doInBackground(String... urls) {
            InputStream is = null;
            OutputStream os = null;

            try {
                URL url = new URL(urls[0]);
                HttpURLConnection conn = (HttpURLConnection) url.openConnection();
                conn.addRequestProperty("Content-Type", "application/json");
                conn.setReadTimeout(10000 /* milliseconds */);
                conn.setConnectTimeout(15000 /* milliseconds */);
                conn.setRequestMethod("POST");
                conn.setDoOutput(true);
                conn.setDoInput(true);

                os = conn.getOutputStream();
                os.write(params.toString().getBytes());
                os.flush();
                int response = conn.getResponseCode();
                is = conn.getInputStream();

                String contentAsString = readSomething(is);
                return contentAsString;
            } catch (IOException e) {
                e.printStackTrace();
                return "Error : Unable to retrieve web page. URL may be invalid.";
            } finally {
                if (is != null) {
                    try {
                        is.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }

                if (os != null) {
                    try {
                        os.close();
                    } catch (IOException e) {
                        e.printStackTrace();
                    }
                }
            }
        }

        @Override
        protected void onPostExecute(String result) {
            if (mProgressDialog.isShowing()) {
                mProgressDialog.dismiss();
            }

            //서버에 요청이 실패하였을 때
            if (result.contains("Error")) {
                Toast.makeText(MainActivity.this, result, Toast.LENGTH_SHORT).show();
                return;
            }

            //서버에서 응답이 온 경우
            try {
                JSONObject response = new JSONObject(result);
                int resultCode = response.optInt(TossConstants.PARAM_RESULT_CODE, TossConstants.RESULT_FAILED);
                switch (resultCode) {
                    case TossConstants.RESULT_SUCCEED:
                        //결제 건이 성공적으로 생성된 경우, 결제 요청을 합니다.
                        payWithToss(response.optString(TossConstants.PARAM_PAY_TOKEN));
                        break;
                    case TossConstants.RESULT_FAILED:
                    case TossConstants.RESULT_FAILED_ORDER_DUPLICATED:
                    case TossConstants.RESULT_FAILED_EXCEED_LIMIT:
                        //실패 사유를 Toast로 보여줍니다.
                        String msg = response.optString(TossConstants.PARAM_MSG);
                        Toast.makeText(MainActivity.this, msg, Toast.LENGTH_SHORT).show();
                        break;
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }
}
