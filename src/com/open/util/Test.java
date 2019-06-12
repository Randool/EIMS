package com.open.util;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

public class Test {
    public static void main(String[] args) {
        MySQLJava open = new MySQLJava();
        Connection conn = open.getConnection();
        // System.out.println("连接数据库成功");

        String Mno = "M00001", Mname = null;
        String sql = String.format("select * from manager where Mno='%s'", Mno);

        Statement stmt;
        try {
            stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            rs.next();
            Mname = rs.getString("Mname");
        } catch (SQLException e) {
            e.printStackTrace();
        }

        // System.out.println(Mname);
    }
}
