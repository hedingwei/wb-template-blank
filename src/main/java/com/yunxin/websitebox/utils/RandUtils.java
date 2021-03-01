package com.yunxin.websitebox.utils;

import org.apache.commons.lang.RandomStringUtils;

public class RandUtils {
    /**
     *  随机长度的字符串
     * @param len
     * @return
     */
    public static String randomString(int len){
        return RandomStringUtils.random(len);
    }

    /**
     *  指定长度的随机数值字符串
     * @param len
     * @return
     */
    public static String randomNumeric(int len){
        return RandomStringUtils.randomNumeric(len);
    }

}
