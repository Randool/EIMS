<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.MySQLJava" %>
<%@ page import="static java.nio.charset.StandardCharsets.ISO_8859_1" %>
<%@ page import="static java.nio.charset.StandardCharsets.UTF_8" %>
<%!ResultSet rs; //全局作用域%>
<%
    String sql;
    Cookie cookies[] = request.getCookies(); //读出用户硬盘上的Cookie，并将所有的Cookie放到一个cookie对象数组里面
    Cookie sCookie = null;
    String svalue = null;
    String sname = null;

    for (int i = 0; i < cookies.length - 1; i++) {    //用一个循环语句遍历刚才建立的Cookie对象数组
        sCookie = cookies[i]; //取出数组中的一个Cookie对象
        if (sCookie.getName().equals("user_no")) {
            sname = sCookie.getName(); //取得这个Cookie的名字
            svalue = sCookie.getValue(); //取得这个Cookie的内容
        }
    }
    request.setCharacterEncoding("utf-8");
    String panduan = request.getParameter("panduan");
    String user_no = svalue;
    String change = request.getParameter("change");
    String Cno = request.getParameter("Cno");
    String Cname = request.getParameter("Cname");
    String Sno = request.getParameter("Sno");
    String Newgrade = request.getParameter("Newgrade");
    String Sdept = request.getParameter("Sedpt");

    // System.out.print(change);
    // System.out.print(Cno);
    // System.out.print(panduan);
    // System.out.print(user_no);

    MySQLJava open = new MySQLJava();
    Connection conn = open.getConnection();
    Statement stmt = null;
    try {
        stmt = conn.createStatement();
        if (change == null && panduan != null) {//判断是否更新
            int grade = 0;
            int flag = 1;//判断标志
            if (Newgrade.equals("")) {
                grade = -1;
            } else if (Newgrade.length() > 3) {
                grade = -1;
            } else {
                grade = Integer.parseInt(Newgrade);
            }

            if (Cno.equals("")) {
                // System.out.print("Cno");
                out.print("<script>alert('课程号为空！');window.location.href='teacher_update_grade.jsp'  </script>");
                flag = 0;
            } else if (Cname.equals("")) {
                // System.out.print("Cname");
                out.print("<script>alert('课程名为空！');window.location.href='teacher_update_grade.jsp' </script>");
                flag = 0;
            } else if (Sno.length() != 12) {
                // System.out.print("Sno");
                out.print("<script>alert('学生学号长度不为12');window.location.href='teacher_update_grade.jsp' </script>");
                flag = 0;
            } else if (grade < 0 || grade > 100) {
                // System.out.print("grade" + user_no);
                out.print("<script>alert('输入[0,100]的成绩值');window.location='teacher_update_grade.jsp'</script>");
                flag = 0;
            }
            // System.out.print(flag);
            if (flag == 1) {
                // System.out.print("flag");
                sql = String.format("select * from course where Cno='%s'and Cname='%s'", Cno, Cname);
                rs = stmt.executeQuery(sql);
                if (!rs.next()) {
                    out.print("<script>alert('课程号和课程名不匹配');window.location='teacher_update_grade.jsp' </script>");
                }
                sql = String.format("select * from student where Sno='%s'", Sno);
                rs = stmt.executeQuery(sql);
                if (!rs.next()) {
                    out.print("<script>alert('不存在该学生');window.location='teacher_update_grade.jsp' </script>");
                }
                sql = String.format("select * from sc,course,teacher where sc.Cno=course.Cno and teacher.Tno=course.Tno and Sno='%s' and course.Cno='%s' and teacher.Tno='%s'", Sno, Cno, user_no);
                rs = stmt.executeQuery(sql);
                if (!rs.next()) {
                    out.print("<script>alert('该学生不在你所教的学生范围内');window.location='teacher_update_grade.jsp' </script>");
                }
                sql = String.format("update sc,course,teacher set grade=%d where sc.Cno=course.Cno and teacher.Tno=course.Tno and Sno='%s' and course.Cno='%s' and teacher.Tno='%s'", grade, Sno, Cno, user_no);
                stmt.executeUpdate(sql);
                out.print("<script>alert('提交成功');window.location='teacher_view_grade.jsp' </script>");
                rs.close();
                stmt.close();
                conn.close();
            }
        } else if (change != null && change.length() != 0) {
            sql = String.format("select Cname, Sdept from course where Cno='%s'", Cno);
            // System.out.println(sql);
            rs = stmt.executeQuery(sql);
            rs.next();
        }
    } catch (SQLException e) {
        e.printStackTrace();
    }
%>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

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
            <li class="sub open">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 学生信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="teacher_view_grade.jsp?user_no=<%out.println(user_no);%>">查看学生成绩</a></li>
                    <li class="active"><a href="teacher_update_grade.jsp?user_no=<%out.println(user_no);%>">更改学生成绩</a>
                    </li>
                </ul>
            </li>
            <!--     <li class="sub open">
                       <a href="javascript:;">
                         <i class="fa fa-database"></i> 教师信息 <div class="pull-right"><span class="caret"></span></div>
                       </a>
                       <ul class="templatemo-submenu">
                           <li><a href="manager_view_teacher.jsp" >查看教师信息</a></li>
                         <li><a href="manager_add_teacher.jsp">注册/修改教师信息</a></li>
                         <li><a href="manager_update_teacher.jsp">删除教师信息</a></li>
                       </ul>
                     </li>
           -->
            <li class="sub open" id="now">
                <a href="javascript:;">
                    <i class="fa fa-database"></i> 课程信息
                    <div class="pull-right"><span class="caret"></span></div>
                </a>
                <ul class="templatemo-submenu">
                    <li><a href="teacher_view_course.jsp?user_no=<%out.println(user_no);%>">查看所教课程</a></li>
                    <li><a href="teacher_export_course.jsp?user_no=<%out.println(user_no);%>">导出课表</a></li>
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
                            <div class="panel-heading" style="text-align:center"><h1>修改成绩</h1></div>
                            <div class="panel-body">


                                <p class="margin-bottom-15" style="color: red">请正确填写以下信息！</p>
                                <div class="row">
                                    <div class="col-md-12">
                                        <form role="form" id="templatemo-preferences-form" action="#">
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Cno" class="control-label">课程号</label>
                                                <input type="text" class="form-control" name="Cno"
                                                       value="<%if(change!=null&&change.length()!=0)out.print(Cno);%>" <%
                                                    if (change != null && change.length() != 0)
                                                        out.print("readonly");
                                                %>/>
                                            </div>
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Cname" class="control-label">课程名</label>
                                                <input type="text" class="form-control" name="Cname"
                                                       value="<%if(change!=null&&change.length()!=0){try {
out.print(rs.getString("Cname"));} catch (SQLException e) {
    e.printStackTrace();
}}%>" <%
                                                    if (change != null && change.length() != 0)
                                                        out.print("readonly");
                                                %>/>
                                            </div>
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Sno" class="control-label">学生学号</label>
                                                <input type="text" class="form-control" name="Sno"
                                                       value="<%if(change!=null&&change.length()!=0)out.print(Sno);%>" <%
                                                    if (change != null && change.length() != 0)
                                                        out.print("readonly");
                                                %>/>
                                            </div>
                                            <div class="col-md-6 margin-bottom-15">
                                                <label for="Newgrade" class="control-label">修改学生成绩</label>
                                                <input type="text" class="form-control" name="Newgrade">
                                            </div>
                                            <div class="col-md-12 margin-bottom-15">
                                                <label for="singleSelect">所属系</label>
                                                <select class="form-control margin-bottom-15" name="Sdept">
                                                    <option value="计算机工程系" <% try {
                                                        if (change != null && change.length() != 0 && rs.getString("Sdept").equals("计算机工程系")) {
                                                            out.print("selected = 'selected'");
                                                        }
                                                    } catch (SQLException e) {
                                                        e.printStackTrace();
                                                    }%>>计算机工程系
                                                    </option>
                                                    <option value="通信工程系" <% try {
                                                        if (change != null && change.length() != 0 && rs.getString("Sdept").equals("通信工程系")) {
                                                            out.print("selected = 'selected'");
                                                        }
                                                    } catch (SQLException e) {
                                                        e.printStackTrace();
                                                    }%>>通信工程系
                                                    </option>
                                                    <option value="软件工程系" <% try {
                                                        if (change != null && change.length() != 0 && rs.getString("Sdept").equals("软件工程系")) {
                                                            out.print("selected = 'selected'");
                                                        }
                                                    } catch (SQLException e) {
                                                        e.printStackTrace();
                                                    }%>>软件工程系
                                                    </option>
                                                    <option value="信息工程系" <% try {
                                                        if (change != null && change.length() != 0 && rs.getString("Sdept").equals("信息工程系")) {
                                                            out.print("selected = 'selected'");
                                                            rs.close();
                                                            stmt.close();
                                                            conn.close();
                                                        }
                                                    } catch (SQLException e) {
                                                        e.printStackTrace();
                                                    }%>>信息工程系
                                                    </option>
                                                </select>
                                            </div>
                                            <div class="col-md-12">
                                                <button type="submit" class="btn btn-primary">提交</button>
                                                <button type="reset" class="btn btn-default">重置</button>
                                            </div>
                                            <input type="hidden" name="user_no" value="<%out.println(user_no);%>">
                                            <input type="hidden" name="panduan" value="123123">
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
            <p>Copyright &copy; </p>
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