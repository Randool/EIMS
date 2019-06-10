<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.MySQLJava" %>
<%
    String sql;
    String panduan = request.getParameter("panduan");
    MySQLJava open = new MySQLJava();
    Connection conn = open.getConnection();
    try {
        Statement stmt = conn.createStatement();
        String Sno = request.getParameter("Sno");
        String Cno = request.getParameter("Cno");

        if (panduan.equals("select")) {//选择课程
            sql = String.format("select * from sc where Sno='%s' and Cno='%s'", Sno, Cno);
            ResultSet rs = stmt.executeQuery(sql);
            boolean selected = false;
            if (rs.next()) {
                selected = true;
            }
            //System.out.println(selected);
            if (selected) {
                out.print("<script>alert('你已选择过该课程！'); window.location='student_select_course.jsp?Sno=" + Sno + "' </script>");
                stmt.close();
                conn.close();
            } else { //通过第一条检验
                rs = stmt.executeQuery(String.format("select count(*) from sc where Cno='%s'", Cno));
                rs.next();
                String yixuan = rs.getString("count(*)"); //获取已经选择的人数
                //System.out.println(yixuan);
                rs = stmt.executeQuery(String.format("select * from course where Cno='%s'", Cno));
                rs.next();
                String capacity = rs.getString("Cap"); //获取容量
                if (yixuan.equals(capacity)) {
                    out.print("<script>alert('课程容量已满！'); window.location='student_select_course.jsp?Sno=" + Sno + "' </script>");
                    stmt.close();
                    conn.close();
                } else { //通过第二道检验
                    //开始检查是否冲突
                    //即将选择的课程信息
                    rs = stmt.executeQuery(String.format("select * from course where Cno='%s'", Cno));
                    rs.next();
                    String week1 = rs.getString("Cweek");
                    String day1 = rs.getString("Cday");
                    //查看这个学生已经选择的课程信息
                    sql = String.format("select * from sc,course where sc.cno=course.cno and Sno='%s'", Sno);
                    rs = stmt.executeQuery(sql);
                    boolean flag = false;
                    while (rs.next()) {
                        String week2 = rs.getString("Cweek");
                        String day2 = rs.getString("Cday");
                        if (week1.equals(week2) && day1.equals(day2)) {
                            flag = true;    //有冲突
                            break;
                        }
                    }
                    if (!flag) { //没冲突，通过第三道检验
                        sql = String.format("insert into SC(Sno,Cno) values('%s','%s')", Sno, Cno);
                        System.out.println(sql);
                        stmt.executeUpdate(sql);
                        stmt.close();
                        conn.close();
                        out.print(String.format("<script>alert('选择成功'); window.location='student_select_course.jsp?Sno=%s' </script>", Sno));
                    } else {
                        stmt.close();
                        conn.close();
                        out.print(String.format("<script>alert('课程时间有冲突！'); window.location='student_select_course.jsp?Sno=%s' </script>", Sno));
                    }
                }
            }
        } else if (panduan.equals("cancel")) {
            sql = String.format("delete from sc where Sno='%s' and Cno='%s'", Sno, Cno);
            int a = stmt.executeUpdate(sql);
            System.out.println(a);
            stmt.close();
            conn.close();
            out.print(String.format("<script>alert('删除成功'); window.location='student_elective_result.jsp?Sno=%s' </script>", Sno));
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>
