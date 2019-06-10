<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.OpenConnection" %>
<%
    String sql;
    OpenConnection open = new OpenConnection();
    Connection conn = open.getConnection();
%>
<!DOCTYPE html>
<head>
    <meta charset="utf-8">
    <!--[if IE]>
    <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1"><![endif]-->
    <title>课程管理系统-管理员版</title>
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
        <div class="logo"><h1>管理员系统</h1></div>
        <button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-collapse">
            <span class="sr-only">李辰</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
        </button>
    </div>
</div>
<div class="template-page-wrapper">
    <div class="navbar-collapse collapse templatemo-sidebar">
        <ul class="templatemo-sidebar-menu">
            <li><a href="manager.jsp"><i class="fa fa-home"></i>管理员</a></li>
            <li class="sub open" id="now">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 学生信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li class="active"><a href="#">查看学籍</a></li>
                    <li><a href="manager_add_student.jsp">注册学籍</a></li>
                    <li><a href="manager_update_student.jsp">修改/删除学籍</a></li>
                </ul>
            </li>
            <li class="sub open">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 教师信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="manager_view_teacher.jsp">查看教师信息</a></li>
                    <li><a href="manager_add_teacher.jsp">注册教师信息</a></li>
                    <li><a href="manager_update_teacher.jsp">修改/删除教师信息</a></li>
                </ul>
            </li>
            <li class="sub open">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 课程信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="manager_view_course.jsp">查看课程</a></li>
                    <li><a href="manager_add_course.jsp">增加课程</a></li>
                    <li><a href="manager_update_course.jsp">修改/删除课程</a></li>
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
                            <div class="panel-heading" style="text-align:center"><h1>学籍信息</h1></div>
                            <div class="panel-body">
                                <%
                                    try {
                                        Statement stmt = conn.createStatement();
                                        ResultSet rs = stmt.executeQuery("select * from student");
                                        out.println("<table class='table table-striped'><thead><tr><th>学号</th><th>姓名</th><th>性别</th><th>所属系</th><th>密码</th><th>更改</th></tr></thead>");
                                        out.println("<tbody>");
                                        while (rs.next()) {
                                            out.println("<tr><td>" + rs.getString("Sno") + "</td><td>" + rs.getString("Sname") + "</td><td>" + rs.getString("Ssex") + "</td><td>" + rs.getString("Sdept") + "</td><td>" + rs.getString("Password") + "</td><td>" + "<a href='manager_update_student.jsp?Sno=" + rs.getString("Sno") + "&panduan=false'>修改</a>/<a href='manager_update_student.jsp?Sno=" + rs.getString("Sno") + "&panduan=true'>删除</a>" + "</td></tr>");
                                        }
                                        out.println("</tbody></table>");
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
            <p>Copyright &copy; College of Information Science and Engineering,Hunan University</p>
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