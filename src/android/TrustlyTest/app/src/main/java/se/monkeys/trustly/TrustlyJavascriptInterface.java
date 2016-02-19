package se.monkeys.trustly;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.webkit.JavascriptInterface;

import java.util.logging.Logger;

public class TrustlyJavascriptInterface {
    Activity mContext;

    TrustlyJavascriptInterface(Activity c) {
        mContext = c;
    }

    @JavascriptInterface
    public boolean openURLScheme(String packageName, String uriScheme) {
        if (isPackageInstalledAndEnabled(packageName, mContext)) {
            Intent intent = new Intent();
            intent.setPackage(packageName);
            intent.setAction(Intent.ACTION_VIEW);
            intent.setData(Uri.parse(uriScheme));
            mContext.startActivityForResult(intent, 0);
            return true;
        }
        return false;
    }

    private boolean isPackageInstalledAndEnabled(String packageName, Context context) {
        PackageManager pm = context.getPackageManager();
        try {
            pm.getPackageInfo(packageName, PackageManager.GET_ACTIVITIES);
            ApplicationInfo ai = context.getPackageManager()
                    .getApplicationInfo(packageName, 0);
            return ai.enabled;
        } catch (PackageManager.NameNotFoundException e) {
            Logger.getLogger("TrustlyJavascriptInterface")
                    .severe("Could not check if package " + packageName +
                            " is installed. Exception: " + e.getMessage());
        }
        return false;
    }
}
