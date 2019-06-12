package com.open.util;

import java.io.IOException;
import java.sql.Connection;       // for JDK 8
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;


public class MySQLJava {

    public Connection getConnection() {
        String driver = null;
        String url = null;
        String user_name = null;
        String password = null;
        Connection conn;

        //新建一个properties实例，用于从DBConfig中拿到连接参数。
        Properties pro = new Properties();
        try {
            pro.load(this.getClass().getClassLoader().getResourceAsStream("DBConfig.properties")); //加载DBConfig文件。
            driver = pro.getProperty("driver");
            url = pro.getProperty("url");
            user_name = pro.getProperty("user_name");
            password = pro.getProperty("password");
        } catch (IOException e) {
            e.printStackTrace();
        }

        if (url == null || user_name == null || password == null)
            return null;

        try {
            Class.forName(driver);   //加载jdbc驱动
            conn = DriverManager.getConnection(url, user_name, password);  //获取数据库连接
            conn.setAutoCommit(true);
            return conn;    //返回一个数据库连接。
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
        }

        return null;
    }
}
