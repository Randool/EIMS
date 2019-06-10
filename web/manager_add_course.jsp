<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.OpenConnection" %>
<%
    String sql;
    String Cname = request.getParameter("Cname");
    String Ccredit = request.getParameter("Ccredit");
    String Sdept = request.getParameter("Sdept");
    String Cno = request.getParameter("Cno");
    String Tno = request.getParameter("Tno");
    String Cweek = request.getParameter("Cweek");
    String Cday = request.getParameter("Cday");
    String Cap = request.getParameter("Cap");
    String Addr = request.getParameter("Addr");
    if (Sdept != null) {//检查更新
        int panduan = 1;
        if (Cname == null) {
            out.print("<script>alert('课程名为空！'); window.location='manager_add_course.jsp' </script>");
            panduan = 0;
        }
        if (Cno.length() > 4) {
            out.print("<script>alert('课程号长度大于4位！'); window.location='manager_add_course.jsp' </script>");
            panduan = 0;
        }
        if (Ccredit == null) {
            out.print("<script>alert('学分为空！'); window.location='manager_add_course.jsp' </script>");
            panduan = 0;
        }
        if (Tno.length() != 9) {
            out.print("<script>alert('教工号长度不为9位！'); window.location='manager_add_course.jsp' </script>");
            panduan = 0;
        }
        if (Cweek == null || Cweek.length() > 10) {
            out.print("<script>alert('上课星期长度不合法！'); window.location='manager_add_course.jsp' </script>");
            panduan = 0;
        }
        if (Cday == null || Cday.length() > 2) {
            out.print("<script>alert('上课时间不合法！'); window.location='manager_add_course.jsp' </script>");
            panduan = 0;
        }
        if (Cap == null) {
            out.print("<script>alert('开课人数不合法！'); window.location='manager_add_course.jsp' </script>");
            panduan = 0;
        }
        //建立连接
        OpenConnection open = new OpenConnection();
        Connection conn = open.getConnection();
        try {
            Statement stmt = conn.createStatement();
            //检测课程编号
            ResultSet rs = stmt.executeQuery("select Cno from course");
            while (rs.next()) {
                String temp = rs.getString("Cno");
                if (temp.equals(Cno)) {
                    panduan = 0;
                    out.print("<script>alert('课程号重复'); window.location='manager_add_course.jsp' </script>");//判断学号
                    break;
                }
            }
            int panduant = 0;
            rs = stmt.executeQuery("select Tno from teacher");
            while (rs.next()) {
                String temp = rs.getString("Tno");
                if (temp.equals(Tno)) {
                    panduant = 1;
                    break;
                }
            }
            if (panduan == 1 && panduant == 0) {
                out.print("<script>alert('教工号无效'); window.location='manager_add_course.jsp' </script>");//判断学号
                panduan = 0;
            }
            if (panduan == 1) {//插入数据
                sql = String.format("insert into course values('%s','%s',%s,'%s','%s','%s',%s,%s,'%s')", Cno, Cname, Ccredit, Sdept, Tno, Cweek, Cday, Cap, Addr);
                stmt.executeUpdate(sql);
                out.print("<script>alert('注册成功'); window.location='manager_view_course.jsp' </script>");//判断学号
            }
            stmt.close();
            conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
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
            <li class="sub open">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 学生信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="manager_view_student.jsp">查看学籍</a></li>
                    <li><a href="manager_add_student.jsp">注册学籍</a></li>
                    <%--<li><a href="manager_update_student.jsp">修改/删除学籍</a></li>--%>
                </ul>
            </li>
            <li class="sub open">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 教师信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="manager_view_teacher.jsp">查看教师信息</a></li>
                    <li><a href="manager_add_teacher.jsp">注册/修改教师信息</a></li>
                    <li><a href="manager_update_teacher.jsp">删除教师信息</a></li>
                </ul>
            </li>
            <li class="sub open" id="now">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 课程信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="manager_view_course.jsp">查看课程</a></li>
                    <li class="active"><a href="#">增加课程</a></li>
                    <%--<li><a href="manager_update_course.jsp">修改/删除课程</a></li>--%>
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
                            <div class="panel-heading" style="text-align:center"><h1>课程添加</h1></div>
                            <div class="panel-body">
                                <p class="margin-bottom-15" style="color: red">请正确填写以下信息！</p>
                                <div class="row">
                                    <div class="col-md-12">
                                        <form role="form" id="templatemo-preferences-form" action="#">
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Cno" class="control-label">课程号</label>
                                                <input type="text" class="form-control" name="Cno">
                                            </div>
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Cname" class="control-label">课程名</label>
                                                <input type="text" class="form-control" name="Cname">
                                            </div>
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Ccredit" class="control-label">学分</label>
                                                <input type="text" class="form-control" name="Ccredit">
                                            </div>
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Tno" class="control-label">教工号</label>
                                                <input type="text" class="form-control" name="Tno">
                                            </div>
                                            <div class="col-md-12 margin-bottom-15">
                                                <label for="singleSelect">所属系</label>
                                                <select class="form-control margin-bottom-15" name="Sdept">
                                                    <option value="计算机工程系">计算机工程系</option>
                                                    <option value="通信工程系">通信工程系</option>
                                                    <option value="软件工程系">软件工程系</option>
                                                    <option value="信息工程系">信息工程系</option>
                                                </select>
                                            </div>
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Cweek" class="control-label">上课星期</label>
                                                <input type="text" class="form-control" name="Cweek">
                                            </div>
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Cday" class="control-label">上课时间</label>
                                                <input type="text" class="form-control" name="Cday">
                                            </div>
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Cap" class="control-label">开课人数</label>
                                                <input type="text" class="form-control" name="Cap">
                                            </div>
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Addr" class="control-label">上课地点</label>
                                                <input type="text" class="form-control" name="Addr">
                                            </div>
                                            <div class="col-md-12">
                                                <button type="submit" class="btn btn-primary">增加</button>
                                                <button type="reset" class="btn btn-default">重置</button>
                                            </div>
                                        </form>
                                    </div>
                                </div>

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