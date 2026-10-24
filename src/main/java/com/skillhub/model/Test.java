package com.skillhub.model;

public class Test {
    public static void main(String[] args) {
        User user = new User("admin", "admin123", "System Administrator", "admin@skillhub.com", Role.ADMIN);
        System.out.println(user.toString());
    }
}
