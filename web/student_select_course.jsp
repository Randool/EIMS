<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.MySQLJava" %>
<%@ page import="com.open.util.RedisJava" %>
<%@ page import="com.open.util.NoInj" %>
<%
    String sql;
    MySQLJava open = new MySQLJava();
    Connection conn = open.getConnection();
    String Sno = request.getParameter("Sno");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8">
    <!--[if IE]>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><![endif]-->
    <title>课程管理系统-学生版</title>
    <meta name="keywords" content=""/>
    <meta name="description" content=""/>
    <meta name="viewport" content="width=device-width">
    <link rel="stylesheet" href="css/templatemo_main.css">
    <!--
    Dashboard Template
    http://www.templatemo.com/preview/templatemo_415_dashboard
    -->
</head>
<body>

<div class="navbar navbar-inverse" role="navigation">
    <div class="navbar-header">
        <div class="logo"><h1>学生系统</h1></div>
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
    </div>
</div>
<div class="template-page-wrapper">
    <div class="navbar-collapse collapse templatemo-sidebar">
        <ul class="templatemo-sidebar-menu">

            <li class="active"><a href="student.jsp?user_no=<%out.println(Sno);%>"><i class="fa fa-home"></i>学生</a></li>
            <li class="sub open">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 选课服务
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="student_select_course.jsp?Sno=<%out.println(Sno);%>">选课</a></li>
                    <li><a href="student_elective_result.jsp?Sno=<%out.println(Sno);%>">选课结果</a></li>
                </ul>
            </li>
            <li class="sub">
                <a href="student_view_classtable.jsp?Sno=<%out.println(Sno);%>">
                    <i class="fa fa-database"></i> 查看课程
                    <div class="pull-right"></div>
                </a>
            </li>
            <li class="sub">
                <a href="student_view_score.jsp?Sno=<%out.println(Sno);%>">
                    <i class="fa fa-database"></i> 查看成绩
                    <div class="pull-right"></div>
                </a>
            </li>
            <li><a href="javascript:;" data-toggle="modal" data-target="#confirmModal"><i class="fa fa-sign-out"></i>Sign
                Out</a></li>
        </ul>
    </div><!--/.navbar-collapse -->

    <div class="templatemo-content-wrapper">
        <div class="templatemo-content">

            <h1>请注意：</h1>
            <p>本系学生只能选择本系开设课程</p>

            <div class="templatemo-panels">
                <div class="row">
                    <div class="col-md-12 col-sm-12 margin-bottom-30">
                        <div class="panel panel-primary">
                            <div class="panel-heading" style="text-align:center"><h1>选课表</h1></div>
                            <div class="panel-body">
                                <%
                                    out.println("<table class='table table-striped'><thead><tr><th>课程号</th><th>课程名</th><th>学分</th><th>课程系别</th><th>教师</th><th>授课星期</th><th>授课时间</th><th>课程容量</th><th>已选人数</th><th>授课地点</th><th>选择课程</th></tr></thead>");
                                    out.println("<tbody>");
                                    sql = String.format("select * from student where Sno='%s' LIMIT 1", Sno);   // 限制1条
                                    sql = NoInj.TransInjection(sql);  // 防止注入
                                    ResultSet rs;
                                    Statement stmt;
                                    try {
                                        stmt = conn.createStatement();
                                        rs = stmt.executeQuery(sql);
                                        rs.next();
                                        String Sdept = rs.getString("Sdept"); //获取系
                                        RedisJava redis = new RedisJava();
                                        Set<String> courses = redis.CourseBuf(Sdept, 20);   // 使用Redis作为选课缓存
                                        for (String item: courses) {
                                            List<String> seq = Arrays.asList(item.split("\\|"));
                                            String Cno = seq.get(0);
                                            String Cname = seq.get(1);
                                            String Credit = seq.get(2);
                                            String Cdept = seq.get(3);
                                            String Tname = seq.get(4);
                                            String Cweek = seq.get(5);
                                            String Cday = seq.get(6);
                                            String Cap = seq.get(7);
                                            String Addr = seq.get(8);

                                            rs = stmt.executeQuery(String.format("select count(*) from sc where Cno='%s'", Cno));
                                            rs.next();
                                            String count = rs.getString("count(*)");

                                            out.println("<tr>");
                                            out.println(String.format("<td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td>",
                                                    Cno, Cname, Credit, Cdept, Tname, Cweek, Cday, Cap, count, Addr));
                                            out.println(String.format("<td><a href='student_update_course.jsp?Cno=%s&Sno=%s&panduan=select'>选择</a></td>", Cno, Sno));
                                            out.println("</tr>");
                                        }
//                                        sql = String.format("select * from course where Cdept='%s'", Sdept);
//                                        rs = stmt.executeQuery(sql);
//                                        Statement stmt1 = conn.createStatement();
//                                        ResultSet rs1;
//                                        while (rs.next()) {
//                                            String Cno = rs.getString("Cno");
//                                            String Cname = rs.getString("Cname");
//                                            String Credit = rs.getString("Credit");
//                                            String Cdept = rs.getString("Cdept");
//                                            String Tno = rs.getString("Tno");
//                                            String Cweek = rs.getString("Cweek");
//                                            String Cday = rs.getString("Cday");
//                                            String Cap = rs.getString("Cap");
//                                            String Addr = rs.getString("Addr");
//
//                                            rs1 = stmt1.executeQuery(String.format("select * from teacher where Tno='%s'", Tno));
//                                            rs1.next();
//                                            String Tname = rs1.getString("Tname");
//
//                                            //选择了这个课程的人数
//                                            rs1 = stmt1.executeQuery(String.format("select count(*) from sc where Cno='%s'", Cno));
//                                            rs1.next();
//                                            String count = rs1.getString("count(*)");
//
//                                            out.println("<tr>");
//                                            out.println(String.format("<td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td><td>%s</td>",
//                                                    Cno, Cname, Credit, Cdept, Tname, Cweek, Cday, Cap, count, Addr));
//                                            out.println(String.format("<td><a href='student_update_course.jsp?Cno=%s&Sno=%s&panduan=select'>选择</a></td>", Cno, Sno));
//                                            out.println("</tr>");
//                                        }
//                                        stmt1.close();
//                                        stmt.close();
//                                        conn.close();
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
                                    out.println("</tbody></table>");
                                %>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Modal -->
    <div class="modal fade" id="confirmModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel"
         aria-hidden="true">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal"><span
                            aria-hidden="true">&times;</span><span class="sr-only">Close</span></button>
                    <h4 class="modal-title" id="myModalLabel">是否注销登录</h4>
                </div>
                <div class="modal-footer">
                    <a href="index.jsp" class="btn btn-primary">是</a>
                    <button type="button" class="btn btn-default" data-dismiss="modal">否</button>
                </div>
            </div>
        </div>
    </div>
    <footer class="templatemo-footer">
        <div class="templatemo-copyright">
            <p>Copyright &copy; College of Information Science and Engineering,Hunan University</p>
        </div>
    </footer>
</div>

<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/Chart.min.js"></script>
<script src="js/templatemo_script.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $(".templatemo-sidebar-menu li.sub a").parent().removeClass('open');
    })
</script>
</body>
</html>