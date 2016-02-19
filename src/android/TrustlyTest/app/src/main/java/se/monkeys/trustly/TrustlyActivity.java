package se.monkeys.trustly;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.graphics.Color;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.LinearLayout;

import java.net.MalformedURLException;
import java.net.URL;

public class TrustlyActivity extends Activity {
    public static final String TRUSTLY_URL_MESSAGE = "TrustlyActivity.URL_MESSAGE";
    public static final String TRUSTLY_END_URLS_MESSAGE = "TrustlyActivity.END_URLS_MESSAGE";
    public static final int RESULT_ERROR = 500;
    private static final String LOGTAG = "TrustlyActivity";
    private LinearLayout rootLayout;
    private View closeView;
    WebView webView;

    @SuppressLint({"SetJavaScriptEnabled", "AddJavascriptInterface"})
    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        webView = new WebView(this);

        updateUI();

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
    }

    @Override
    public void onWindowFocusChanged(boolean hasFocus) {
        // Update the height of the closeView
        // in updateUI we have no height set yet.
        int closeViewHeight = rootLayout.getMeasuredHeight() / 10;
        ViewGroup.LayoutParams closeViewParams = closeView.getLayoutParams();
        if (closeViewParams != null) {
            closeViewParams.height = closeViewHeight;
        }
        Log.d(LOGTAG, "onWindowFocusChanged, setting height to " + closeViewHeight);
    }

    private void updateUI() {
        rootLayout = new LinearLayout(this);
        LinearLayout.LayoutParams rootParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
        );
        rootLayout.setLayoutParams(rootParams);
        rootLayout.setOrientation(LinearLayout.VERTICAL);
        setContentView(rootLayout);

        closeView = new View(this);
        LinearLayout.LayoutParams closeViewParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT  // Updated in onWindowFocusChanged
        );
        closeView.setBackgroundColor(Color.TRANSPARENT);
        closeView.setLayoutParams(closeViewParams);
        rootLayout.addView(closeView);

        closeView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                setResult(RESULT_CANCELED);
                finish();
            }
        });

        LinearLayout.LayoutParams webViewParams = new LinearLayout.LayoutParams(
                LinearLayout.LayoutParams.MATCH_PARENT,
                LinearLayout.LayoutParams.MATCH_PARENT
        );
        webView.setLayoutParams(webViewParams);
        rootLayout.addView(webView);
    }

}
