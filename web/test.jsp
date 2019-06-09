<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*,com.mysql.jdbc.Driver" %>
<%@ page import="com.open.util.OpenConnection" %>
<%
   // String dbdriver = "com.mysql.jdbc.Driver";
    //String url = "jdbc:mysql://localhost:3306/education?characterEncoding=utf8&useSSL=true";
    //String username_root = "root";
    //String password = "lichen123";
    String sql;

    //Class.forName(dbdriver);
    //Connection conn = DriverManager.getConnection(url, username_root, password);
    OpenConnection open = new OpenConnection();
    Connection conn = open.getConnection();
    System.out.println("数据库连接成功");
    Statement stmt = conn.createStatement();
    sql = "select * from course";
    ResultSet rs = stmt.executeQuery(sql);
    out.println("<table class='table table-striped'><thead><tr><th>Cno</th><th>Cname</th><th>Ccredit</th><th>Sedpt</th><th>Tno</th><th>Cweek</th><th>Cday</th><th>Cap</th><th>Adr</th></tr></thead>");
    out.println("<tbody>");
    while (rs.next()) {
        out.println("<tr><td>" + rs.getString("Cno") + "</td><td>" + rs.getString("Cname") + "</td><td>" + rs.getString("Ccredit") + "</td><td>" + rs.getString("Sdept") + "</td><td>" + rs.getString("Tno") + "</td><td>" + rs.getString("Cweek") + "</td><td>" + rs.getString("Cday") + "</td><td>" + rs.getString("Cap") + "</td><td>" + rs.getString("Adr") + "</td></tr>");
    }
    out.println("</tbody></table>");
    stmt.close();
    conn.close();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
    <title>Insert title here</title>
</head>
<body>
</body>
</html>