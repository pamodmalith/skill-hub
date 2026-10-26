package com.skillhub.util;

public class HtmlUtil {

    public static String escape(String s) {
        if (s == null) {
            return "";
        }
        String result = s;
        result = result.replace("&", "&amp;");
        result = result.replace("<", "&lt;");
        result = result.replace(">", "&gt;");
        result = result.replace("\"", "&quot;");
        result = result.replace("'", "&#x27;");
        return result;
    }
}