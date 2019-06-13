package com.open.util;

public class Grade2Credit {
    public static double Credit(int grade) {
        if (grade >= 90) {
            return 4.5;
        } else if (grade >= 80) {
            return 3.5;
        } else if (grade >= 70) {
            return 2.5;
        } else if (grade >= 60) {
            return 1.5;
        } else {
            return 0.0;
        }
    }
}
