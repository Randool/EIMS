package com.open.util;

import java.util.Scanner;

public class NoInj {

    public static String TransInjection(String str) {
        return str.replaceAll(".*([;]+|(--)+).*", " ");
    }

    public static void main(String[] argv) {
        Scanner sc = new Scanner(System.in);
        while (true) {
            String sql = sc.nextLine();
            if (sql.equals("exit")) break;
            System.out.println(NoInj.TransInjection(sql));
        }
    }
}
