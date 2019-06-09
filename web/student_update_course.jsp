<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.OpenConnection" %>
<%
    String sql;
    String panduan = request.getParameter("panduan");
    OpenConnection open = new OpenConnection();
    Connection conn = open.getConnection();
    Statement stmt = conn.createStatement();
    if (panduan.equals("select")) {//选择课程
        String Sno = request.getParameter("Sno1");
        String Cno = request.getParameter("Cno");

        sql = String.format("select * from sc where Sno='%s' and Cno='%s'", Sno, Cno);
        ResultSet rs = stmt.executeQuery(sql);
        int i = 0;
        while (rs.next()) {
            i++;
        }
        //System.out.println(i);
        if (i != 0) {
            out.print("<script>alert('你已选择过该课程！'); window.location='student_select_course.jsp?Sno=" + Sno + "' </script>");
            stmt.close();
            conn.close();
        } else { //通过第一条检验
            sql = String.format("select count(*) from sc where Cno='%s'", Cno);
            rs = stmt.executeQuery(sql);
            rs.next();
            String yixuan = rs.getString("count(*)"); //获取已经选择的人数
            //System.out.println(yixuan);
            sql = String.format("select * from course where Cno='%s'", Cno);
            rs = stmt.executeQuery(sql);
            rs.next();
            String capacity = rs.getString("Cap"); //获取容量
            //	System.out.println(capacity);
            if (yixuan.equals(capacity)) {
                out.print("<script>alert('课程容量已满！'); window.location='student_select_course.jsp?Sno=" + Sno + "' </script>");
                stmt.close();
                conn.close();
            } else { //通过第二道检验
                //开始检查是否冲突
                sql = String.format("select * from course where Cno='%s'", Cno); //即将选择的课程信息
                rs = stmt.executeQuery(sql);
                rs.next();
                String week1 = rs.getString("Cweek");
                String day1 = rs.getString("Cday");
                //查看这个学生已经选择的课程信息
                sql = String.format("select * from sc,course where sc.cno=course.cno and Sno='%s'", Sno);
                rs = stmt.executeQuery(sql);
                String flag = "false";
                while (rs.next()) {
                    String week2 = rs.getString("Cweek");
                    String day2 = rs.getString("Cday");
                    if (week1.equals(week2) && day1.equals(day2)) {
                        flag = "true"; //有冲突
                        break;
                    }
                }
                if (flag.equals("false")) { //没冲突，通过第三道检验
                    sql = String.format("insert into SC(Sno,Cno) values('%s','%s')", Sno, Cno);
                    stmt.executeUpdate(sql);
                    stmt.close();
                    conn.close();
                    out.print("<script>alert('选择成功'); window.location='student_select_course.jsp?Sno=" + Sno + "' </script>");
                } else {
                    stmt.close();
                    conn.close();
                    out.print("<script>alert('课程时间有冲突！'); window.location='student_select_course.jsp?Sno=" + Sno + "' </script>");
                }
            }
        }
    } else if (panduan.equals("cancel")) {
        String Sno = request.getParameter("Sno1");
        String Cno = request.getParameter("Cno");
        sql = String.format("delete from sc where Sno='%s' and Cno='%s'", Sno, Cno);
        stmt.executeUpdate(sql);
        stmt.close();
        conn.close();
        out.print("<script>alert('删除成功'); window.location='student_elective_result.jsp?Sno=" + Sno + "' </script>");
    }
%>