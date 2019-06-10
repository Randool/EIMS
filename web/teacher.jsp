<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.MySQLJava" %>
<%
    String sql;
    MySQLJava open = new MySQLJava();
    Connection conn = open.getConnection();
    String user_no = request.getParameter("user_no");
    Cookie cookie = new Cookie("user_no", user_no);
    cookie.setMaxAge(10000000);
    response.addCookie(cookie);
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
            <li class="active"><a href="#?user_no=<%out.println(user_no);%>"><i class="fa fa-home"></i>教师</a></li>
            <li class="sub open">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 学生信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="teacher_view_grade.jsp">查看学生成绩</a></li>
                    <li><a href="teacher_update_grade.jsp">更改学生成绩</a></li>
                </ul>
            </li>
            <!--        <li class="sub open">
                        <a href="javascript:;">
                          <i class="fa fa-database"></i> 教师信息 <div class="pull-right"><span class="caret"></span></div>
                        </a>
                        <ul class="templatemo-submenu">
                            <li><a href="manager_view_teacher.jsp" >查看教师信息</a></li>
                          <li><a href="manager_add_teacher.jsp">注册教师</a></li>
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
            <h1>
                <%
                    sql = String.format("select * from teacher where Tno='%s'", user_no);
                    try {
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(sql);
                        rs.next(); //有毒！
                        String tname = new String(request.getParameter("Tname").getBytes(ISO_8859_1), UTF_8);
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                    out.println(tname);
                %>
            </h1>
            <p>欢迎来到湖南大学信息科学与工程学院教务管理系统</p>
            <%
                try {
                    conn.close();
                } catch (SQLException e) {
                    e.printStackTrace();
                }
            %>
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
            <p>Copyright &copy; 计科1503班yzsy组</p>
        </div>
    </footer>
</div>

<script src="js/jquery.min.js"></script>
<script src="js/bootstrap.min.js"></script>
<script src="js/templatemo_script.js"></script>
<script type="text/javascript">
    $(document).ready(function () {
        $(".templatemo-sidebar-menu li.sub a").parent().removeClass('open');
    })
</script>
</body>
</html>