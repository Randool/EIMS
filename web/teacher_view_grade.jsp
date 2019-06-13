<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.MySQLJava" %>
<%@ page import="com.open.util.NoInj" %>
<%
    String sql;
    MySQLJava open = new MySQLJava();
    Connection conn = open.getConnection();
    Cookie cookies[] = request.getCookies(); //读出用户硬盘上的Cookie，并将所有的Cookie放到一个cookie对象数组里面
    Cookie sCookie = null;
    String svalue = null;
//    String sname = null;

    for (int i = 0; i < cookies.length - 1; i++) {    //用一个循环语句遍历刚才建立的Cookie对象数组
        sCookie = cookies[i]; //取出数组中的一个Cookie对象
        if (sCookie.getName().equals("user_no")) {
//            sname = sCookie.getName(); //取得这个Cookie的名字
            svalue = sCookie.getValue(); //取得这个Cookie的内容
        }
    }
    String user_no = svalue;    //index.jsp的传递参数
%>
<!DOCTYPE html>
<head>
    <meta charset="utf-8">
    <!--[if IE]>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><![endif]-->
    <title>课程管理系统-教师版</title>
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
        <div class="logo"><h1>教职工系统</h1></div>
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
    </div>
</div>
<div class="template-page-wrapper">
    <div class="navbar-collapse collapse templatemo-sidebar">
        <ul class="templatemo-sidebar-menu">
            <li><a href="teacher.jsp?user_no=<%out.println(user_no);%>"><i class="fa fa-home"></i>教师</a></li>
            <li class="sub open" id="now">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 学生信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li class="active"><a href="teacher_view_grade.jsp">查看学生成绩</a></li>
                    <li><a href="teacher_update_grade.jsp">更改学生成绩</a></li>
                </ul>
            </li>
            <!--        <li class="sub open">
                        <a href="javascript:;">
                          <i class="fa fa-database"></i> 教师信息 <div class="pull-right"><span class="caret"></span></div>
                        </a>
                        <ul class="templatemo-submenu">
                            <li><a href="manager_view_teacher.jsp" >查看教师信息</a></li>
                          <li><a href="manager_add_teacher.jsp">注册教师信息</a></li>
                          <li><a href="manager_update_teacher.jsp">修改/删除教师信息</a></li>
                        </ul>
                      </li>
            -->
            <li class="sub open">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 课程信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="teacher_view_course.jsp">查看所教课程</a></li>
                    <li><a href="teacher_export_course.jsp">导出课表</a></li>
                </ul>
            </li>
            <li><a href="javascript:;" data-toggle="modal" data-target="#confirmModal"><i class="fa fa-sign-out"></i>Sign
                Out</a></li>
        </ul>
    </div><!--/.navbar-collapse -->

    <div class="templatemo-content-wrapper">
        <div class="templatemo-content">
            <div class="templatemo-panels">
                <div class="row">
                    <div class="col-md-12 col-sm-12 margin-bottom-30">
                        <div class="panel panel-primary">
                            <div class="panel-heading" style="text-align:center"><h1>学生成绩</h1></div>
                            <div class="panel-body">
                                <%
                                    try {
                                        Statement stmt = conn.createStatement();
                                        sql = String.format("SELECT student.Sno,Sname,Ssex,student.Sdept,course.Cno,course.Cname,Grade,GPA FROM student,sc,course,teacher WHERE student.Sno=sc.Sno and course.Cno=sc.Cno and course.Tno=teacher.Tno and course.Tno='%s'", user_no);
                                        sql = NoInj.TransInjection(sql);  // 防止注入
                                        ResultSet rs = stmt.executeQuery(sql);
                                        out.println("<table class='table table-striped'><thead><tr><th>学号</th><th>姓名</th><th>性别</th><th>所属系</th><th>课程号</th><th>课程名</th><th>成绩</th><th>绩点</th></tr></thead>");
                                        out.println("<tbody>");
                                        while (rs.next()) {
                                            out.println("<tr><td>" + rs.getString("student.Sno") + "</td><td>" + rs.getString("Sname") + "</td><td>" + rs.getString("Ssex") + "</td><td>" + rs.getString("student.Sdept") + "</td><td>" + rs.getString("course.Cno") + "</td><td>" + rs.getString("course.Cname") + "</td><td>" + rs.getString("Grade") + "</td><td>" + rs.getString("GPA") + "</td><td>" + "<a href='teacher_update_grade.jsp?Cno=" + rs.getString("Cno") + "&Sno=" + rs.getString("student.Sno") + "&user_no=" + user_no + "&change=first_admit'>修改成绩</a>" + "</td></tr>");
                                        }
                                        out.println("</tbody></table>");
                                        rs.close();
                                        stmt.close();
                                        conn.close();
                                    } catch (SQLException e) {
                                        e.printStackTrace();
                                    }
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
                    <h4 class="modal-title" id="myModalLabel">是否确定退出?</h4>
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
            <p>Copyright &copy; 计科1605班</p>
        </div>
    </footer>
</div>

<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/templatemo_script.js"></script>
<script type="text/javascript">
    $(document).ready(
        function () {
            $(".templatemo-sidebar-menu li.sub a").parent().removeClass('open');
            $("#now").addClass('open');
        }
    )
</script>
</body>
</html>