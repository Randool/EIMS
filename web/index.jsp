<%@ page language="java" contentType="text/html; charset=utf-8"
         pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.MySQLJava" %>
<%!
    public static boolean isNumeric(String str) {
        for (int i = str.length(); --i >= 0; ) {
            if (!Character.isDigit(str.charAt(i))) {
                return false;
            }
        }
        return true;
    }
%>
<%
    String panduan = request.getParameter("panduan");
    if (panduan != null && panduan.length() != 0) {
        String user_type = request.getParameter("user_type");
        String username = request.getParameter("username");
        String password_get = request.getParameter("password");
        int panduan2 = 1;
        if (username != null && username.length() == 0) {
            out.print("<script>alert('用户名为空'); window.location='index.jsp' </script>");
            panduan2 = 0;
        }
        if (password_get != null && password_get.length() == 0) {
            out.print("<script>alert('密码为空'); window.location='index.jsp' </script>");
            panduan2 = 0;
        }
        String user_no = null;
        if (user_type.equals("student"))
            user_no = "Sno";
        else if (user_type.equals("teacher"))
            user_no = "Tno";
        else if (user_type.equals("manager"))
            user_no = "Mno";
        else
            panduan2 = 0;

        if (panduan2 == 1) {
            String sql = String.format("select * from %s where %s='%s'", user_type, user_no, username);
            // System.out.println(sql);
            MySQLJava open = new MySQLJava();
            Connection conn = open.getConnection();
//            System.out.println("连接数据库成功");
            Statement stmt = conn.createStatement();
            ResultSet rs = stmt.executeQuery(sql);
            if (rs.next()) {
                String temp = rs.getString("password");
                if (temp.equals(password_get)) { //获取学号
                    out.print("<script>alert('登录成功');   window.location='" + user_type + ".jsp?user_no=" + username + "' </script>");
                } else {
                    out.print("<script>alert('密码错误'); </script>");
                }
                stmt.close();
                conn.close();
            } else {
                out.print("<script>alert('用户名不存在'); </script>");
            }
        }
    }

%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css"
          type="text/css">
    <link rel="stylesheet" href="css/theme.css" type="text/css">
</head>

<body class="filter-gradient border">
<div class="py-5">
    <div class="container">
        <div class="row">
            <div class="col-md-3"></div>
            <div class="col-md-6">
                <div class="card p-5 bg-primary text-dark text-left text-capitalize border border-light">
                    <div class="card-body">
                        <h1 class="">课程管理系统</h1>
                        <form action="#">
                            <div class="form-group">
                                <label>Type of user</label>
                                <select class="custom-control custom-select" name="user_type">
                                    <option value="student">学生</option>
                                    <option value="teacher">老师</option>
                                    <option value="manager">管理员</option>
                                </select>
                            </div>
                            <div class="form-group">
                                <label>Username</label>
                                <input type="text" class="form-control" placeholder="Username" name="username"></div>
                            <div class="form-group">
                                <label>Password</label>
                                <input type="password" class="form-control" placeholder="Password" name="password">
                            </div>
                            <input type="hidden" name="panduan" value="123123">
                            <button type="submit" class="btn btn-secondary">Login</button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>
</body>

</html>