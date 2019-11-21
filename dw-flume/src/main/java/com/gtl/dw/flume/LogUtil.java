package com.gtl.dw.flume;

import org.apache.commons.lang.math.NumberUtils;

public class LogUtil {
    public static boolean validateStartLog(String msg) {
        if (!msg.startsWith("{") || !msg.endsWith("}")) {
            return false;
        }
        return true;
    }

    public static boolean validateEventLog(String msg) {
        String[] split = msg.split("\\|"); //需要转义
        String ts = split[0].trim();
        if (ts.length() != 13 || !NumberUtils.isDigits(ts)) {
            return  false;
        }
        String str = split[1].trim();
        if (!str.startsWith("{") || !str.endsWith("}")) {
            return false;
        }
        return true;
    }

}
