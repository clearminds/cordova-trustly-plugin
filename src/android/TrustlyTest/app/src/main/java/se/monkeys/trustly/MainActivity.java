package se.monkeys.trustly;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
//import android.support.design.widget.FloatingActionButton;
//import android.support.design.widget.Snackbar;
import android.util.Log;
import android.view.View;
import android.widget.EditText;

public class MainActivity extends Activity {
    private static final String LOGTAG = "Trustly";

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);
    }

    public void submit(View view) {
        EditText trustlyURLText = (EditText) findViewById(R.id.submit_trustly_url);
        Intent trustlyIntent = new Intent(this, TrustlyActivity.class);
        String urlString = trustlyURLText.getText().toString();
//        try {
//            new URL(urlString);
//        } catch (MalformedURLException e) {
//            Log.w(LOGTAG, "URL not valid: " + urlString);
//            trustlyURLText.setText("");
//            return;
//        }

        String[] endUrls = {"trustly/account/app/done/",
                            "trustly/account/app/fail/",
                            "trustly/p2p/app/done/",
                            "trustly/p2p/app/fail/"};

        trustlyIntent.putExtra(TrustlyActivity.TRUSTLY_URL_MESSAGE, urlString);
        trustlyIntent.putExtra(TrustlyActivity.TRUSTLY_END_URLS_MESSAGE, endUrls);
        startActivityForResult(trustlyIntent, 0);
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        Log.d(LOGTAG, String.format(
                "onActivityResult requestCode = %d, resultCode = %d, data = %s",
                requestCode, resultCode, String.valueOf(data)));

        super.onActivityResult(requestCode, resultCode, data);
    }
}
