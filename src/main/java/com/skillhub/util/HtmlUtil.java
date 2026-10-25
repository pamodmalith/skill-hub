package com.skillhub.util;

public class HtmlUtil {

    public static String escape(String s) {
        if (s == null) {
            return "";
        }
        String result = s;
        result = result.replace("&", "&");
        result = result.replace("<", "<");
        result = result.replace(">", ">");
        result = result.replace("\"", "\u0026quot;");
        result = result.replace("'", "\u0026#39;");
        return result;
    }
}