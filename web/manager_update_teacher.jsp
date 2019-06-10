<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.OpenConnection" %>
<%
    String sql;
    String panduan = request.getParameter("panduan");
    if (panduan == null) out.print("<script>alert('请指定教工！'); window.location='manager_view_teacher.jsp' </script>");
    OpenConnection open = new OpenConnection();
    Connection conn = open.getConnection();
    try {
        Statement stmt = conn.createStatement();
        if (panduan != null && panduan.equals("true")) {//直接删除
            String Tno = request.getParameter("Tno");
            sql = String.format("delete  from teacher where Tno='%s'", Tno);
            stmt.executeUpdate(sql);
            stmt.close();
            conn.close();
            out.print("<script>alert('删除成功'); window.location='manager_view_teacher.jsp' </script>");
        } else if (panduan != null && panduan.equals("update")) {//二次更新
            ResultSet rs;
            int panduan2 = 1;
            String Tno = request.getParameter("Tno");
            String Tname = request.getParameter("Tname");
            if (Tname == null || Tname.length() == 0) {
                out.print("<script>alert('姓名为空！'); window.location='manager_update_teacher.jsp?Tno=" + Tno + "&panduan=false' </script>");
                panduan2 = 0;
            }//判断姓名
            String Tsex = request.getParameter("Tsex");
            String Sdept = request.getParameter("Sdept");
            String password_get = request.getParameter("password");
            if (password_get == null || password_get.length() == 0) {
                out.print("<script>alert('密码为空！'); window.location='manager_update_teacher.jsp?Tno=" + Tno + "&panduan=false' </script>");
                panduan2 = 0;
            }//判断学号
            if (panduan2 == 1) {
                sql = String.format("update teacher set Tname='%s',Tsex='%s',Tdept='%s',Password='%s' where Tno='%s'", Tname, Tsex, Sdept, password_get, Tno);
                stmt.executeUpdate(sql);
                stmt.close();
                conn.close();
                out.print("<script>alert('更新成功！'); window.location='manager_view_teacher.jsp' </script>");
            }
        }%>
<%!ResultSet rs; //作用域%>
<%
        if (panduan != null && panduan.equals("false")) {
            String Tno = request.getParameter("Tno");
            sql = String.format("select *  from teacher where Tno='%s'", Tno);
            rs = stmt.executeQuery(sql);
            rs.next();
        }
    } catch (SQLException e) {
        e.printStackTrace();
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
            <li class="sub open" id="now">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 教师信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="manager_view_teacher.jsp">查看教师信息</a></li>
                    <li><a href="manager_add_teacher.jsp">注册教师</a></li>
                    <%--<li class="active"><a href="#">修改/删除教师信息</a></li>--%>
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
                            <div class="panel-heading" style="text-align:center"><h1>修改教工信息</h1></div>
                            <div class="panel-body">
                                <p class="margin-bottom-15" style="color: red">请正确修改以下信息！</p>
                                <div class="row">
                                    <div class="col-md-12">
                                        <form role="form" id="templatemo-preferences-form" action="#">
                                            <div class="col-md-12 margin-bottom-15">
                                                <label for="firstName" class="control-label">姓名</label>
                                                <input type="text" class="form-control" name="Tname"
                                                       value="<%if(panduan!=null&&panduan.equals("false"))out.print(rs.getString("Tname"));%>">
                                            </div>
                                            <div class="col-md-12 margin-bottom-15">
                                                <label for="lastName" class="control-label">学号</label>
                                                <input type="text" class="form-control" name="Tno"
                                                       value="<%if(panduan!=null&&panduan.equals("false"))out.print(rs.getString("Tno"));%>"
                                                       readonly/>
                                            </div>
                                            <div class="col-md-12 margin-bottom-15">
                                                <label for="Sex"
                                                       class="control-label,col-md-12 margin-bottom-15">性别</label>
                                                <label class="radio-inline">
                                                    <input type="radio" name="Tsex"
                                                           value="男" <% if(panduan!=null&&panduan.equals("false")&&rs.getString("Tsex").equals("男")){ out.print("checked");}%>>
                                                    男
                                                </label>
                                                <label class="radio-inline">
                                                    <input type="radio" name="Tsex"
                                                           value="女" <% if(panduan!=null&&panduan.equals("false")&&rs.getString("Tsex").equals("女")){ out.print("checked");}%>>
                                                    女
                                                </label>
                                            </div>
                                            <div class="col-md-12 margin-bottom-15">
                                                <label for="singleSelect">所属系</label>
                                                <select class="form-control margin-bottom-15" name="Sdept">
                                                    <option value="计算机工程系" <% if (panduan != null && panduan.equals("false") && rs.getString("Tdept").equals("计算机工程系")) {
                                                        out.print("selected = 'selected'");
                                                    }%>>计算机工程系
                                                    </option>
                                                    <option value="通信工程系" <% if (panduan != null && panduan.equals("false") && rs.getString("Tdept").equals("通信工程系")) {
                                                        out.print("selected = 'selected'");
                                                    }%>>通信工程系
                                                    </option>
                                                    <option value="软件工程系" <% if (panduan != null && panduan.equals("false") && rs.getString("Tdept").equals("软件工程系")) {
                                                        out.print("selected = 'selected'");
                                                    }%>>软件工程系
                                                    </option>
                                                    <option value="信息工程系" <% if (panduan != null && panduan.equals("false") && rs.getString("Tdept").equals("信息工程系")) {
                                                        out.print("selected = 'selected'");
                                                    }%>>信息工程系
                                                    </option>
                                                </select>
                                            </div>
                                            <div class="col-md-12 margin-bottom-15">
                                                <label for="password" class="control-label">密码</label>
                                                <input type="password" class="form-control" name="password"
                                                       value="<%if(panduan!=null&&panduan.equals("false"))out.print(rs.getString("password"));%>">
                                            </div>
                                            <div class="col-md-12">
                                                <input type="hidden" name="panduan" value="update"/>
                                                <button type="submit" class="btn btn-primary">更新</button>
                                                <!--            <button type="reset" class="btn btn-default">重置</button>    -->
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
        $("#now").addClass('open');
    })
</script>
</body>
</html>