package com.palyground.pgnative;

import android.app.Activity;
import android.content.Context;
import android.telephony.TelephonyManager;
import android.util.Log;

import java.io.File;

public class Utils {

    public static int isRoot() {
        int result = 0;
        try {
            if ((!new File("/system/bin/su").exists()) && (!new File("/system/xbin/su").exists())) {
                result = 0;
            } else {
                result = 1;
            }
            Log.d("EC.isROOT", "result = " + result);
        } catch (Exception e) {
            Log.e("isRoot", e.getMessage());
        }
        return result;
    }

    public static String getCellularProviderName(Activity activity){
        TelephonyManager manager = (TelephonyManager)activity.getSystemService(Context.TELEPHONY_SERVICE);
        String carrierName = manager.getNetworkOperatorName();
        return carrierName;
    }
}
