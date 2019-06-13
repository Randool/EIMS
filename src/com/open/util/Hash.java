package com.open.util;

import java.security.MessageDigest;
import java.util.Scanner;

public class Hash {

    private static final String hexDigIts[] = {"0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "a", "b", "c", "d", "e", "f"};

    public static String MD5Encode(String origin, String charsetname) {
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            if (null == charsetname || "".equals(charsetname)) {
                origin = byteArrayToHexString(md.digest(origin.getBytes()));
            } else {
                origin = byteArrayToHexString(md.digest(origin.getBytes(charsetname)));
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return origin;
    }

    private static String byteArrayToHexString(byte b[]) {
        StringBuilder resultSb = new StringBuilder();
        for (byte aB : b) {
            resultSb.append(byteToHexString(aB));
        }
        return resultSb.toString();
    }

    private static String byteToHexString(byte b) {
        int n = b;
        if (n < 0) {
            n += 256;
        }
        int d1 = n / 16;
        int d2 = n % 16;
        return hexDigIts[d1] + hexDigIts[d2];
    }

    public static void main(String[] argv) {
        Scanner sc = new Scanner(System.in);

        while (true) {
            System.out.print("Your password> ");
            String passwd = sc.nextLine();
            if (passwd.equals("exit")) break;
            System.out.println(Hash.MD5Encode(passwd, ""));
        }

    }
}