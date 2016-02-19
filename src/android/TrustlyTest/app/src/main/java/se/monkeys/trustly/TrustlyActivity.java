package se.monkeys.trustly;

import android.content.Intent;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;

import java.net.MalformedURLException;
import java.net.URL;

public class TrustlyActivity extends AppCompatActivity {
    public static final String TRUSTLY_URL_MESSAGE = "TrustlyActivity.URL_MESSAGE";
    public static final String TRUSTLY_END_URLS_MESSAGE = "TrustlyActivity.END_URLS_MESSAGE";
    public static final int RESULT_ERROR = 500;
    private static final String LOGTAG = "TrustlyActivity";
    WebView webView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        webView = new WebView(this);
        setContentView(webView);

        Intent intent = getIntent();
        String urlString = intent.getStringExtra(TRUSTLY_URL_MESSAGE);
        final String[] endUrls = intent.getStringArrayExtra(TRUSTLY_END_URLS_MESSAGE);
        Log.d(LOGTAG, String.format("onCreate going to url %s", urlString));

        try {
            new URL(urlString);
        } catch (MalformedURLException e) {
            Log.e(LOGTAG, "Got malformed url", e);
            setResult(RESULT_ERROR);
            finish();
        }

        webView.setWebViewClient(new WebViewClient() {
            @Override
            public boolean shouldOverrideUrlLoading(WebView view, String url) {
                Log.d(LOGTAG, String.format("shouldOverrideUrlLoading for url: %s", url));
                for (String endUrl : endUrls) {
                    Log.d(LOGTAG, String.format("shouldOverrideUrlLoading matching %s", endUrl));
                    if (url.endsWith(endUrl)) {
                        Intent result = new Intent();
                        result.putExtra("finalUrl", url);
                        setResult(RESULT_OK, result);
                        finish();
                        return true;
                    }
                }
                return false;
            }
        });

        WebSettings settings = webView.getSettings();

        settings.setJavaScriptEnabled(true);
        settings.setDomStorageEnabled(true);

        webView.addJavascriptInterface(new TrustlyJavascriptInterface(this), "TrustlyAndroid");
        webView.loadUrl(urlString);

//        LinearLayout layout = new LinearLayout(this);
//        LinearLayout.LayoutParams params = new LinearLayout.LayoutParams(
//                LinearLayout.LayoutParams.MATCH_PARENT,
//                LinearLayout.LayoutParams.WRAP_CONTENT);
//        layout.setLayoutParams(params);

//        LinearLayout.LayoutParams wvParams = new LinearLayout.LayoutParams(
//                LinearLayout.LayoutParams.MATCH_PARENT,
//                LinearLayout.LayoutParams.MATCH_PARENT);
//        webView.setLayoutParams(wvParams);
//
//        CoordinatorLayout layout = new CoordinatorLayout(this);
//        layout.setLayoutParams(new CoordinatorLayout.LayoutParams(
//                CoordinatorLayout.LayoutParams.MATCH_PARENT,
//                CoordinatorLayout.LayoutParams.MATCH_PARENT));
//
//        layout.addView(webView);

//        CoordinatorLayout.LayoutParams fabParams = new CoordinatorLayout.LayoutParams(
//                CoordinatorLayout.LayoutParams.WRAP_CONTENT,
//                CoordinatorLayout.LayoutParams.WRAP_CONTENT);
//        FloatingActionButton fab = new FloatingActionButton(this);
//        fab.setLayoutParams(fabParams);
//        fab.
//        layout.addView(fab);

//        fab.setOnClickListener(new View.OnClickListener() {
//            @Override
//            public void onClick(View view) {
//                setResult(RESULT_CANCELED);
//                finish();
//            }
//        });

//        setContentView(layout);

    }

//    @Override
//    public void onBackPressed() {
//        setResult(RESULT_CANCELED);
//        super.onBackPressed();
//    }
}
