<%@ page language="java" contentType="text/html; charset=utf-8" pageEncoding="utf-8" %>
<%@ page import="java.io.*,java.util.*,java.sql.*" %>
<%@ page import="com.open.util.OpenConnection" %>
<%
    String sql;
    OpenConnection open = new OpenConnection();
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
            <h1>
                <%
                    try {
                        Statement stmt = conn.createStatement();
                        ResultSet rs = stmt.executeQuery(String.format("select * from student where Sno='%s'", Sno));
                        rs.next();
                        String sname = rs.getString("Sname");
                        out.println(sname);
                        stmt.close();
                    } catch (SQLException e) {
                        e.printStackTrace();
                    }
                %>
            </h1>
            <p>本学期课表如下</p>
            <div class="templatemo-panels">
                <div class="row">
                    <div class="col-md-12 col-sm-12 margin-bottom-30">
                        <div class="panel panel-primary">
                            <div class="panel-heading" style="text-align:center"><h1>课程表</h1></div>
                            <div class="panel-body">
                                <table class="table table-striped">
                                    <thead>
                                    <tr>
                                        <th>节数</th> <th>星期一</th>
                                        <th>星期二</th> <th>星期三</th>
                                        <th>星期四</th> <th>星期五</th>
                                        <th>星期六</th> <th>星期日</th>
                                    </tr>
                                    </thead>
                                    <tbody>
                                    <%
                                        String name[] = new String[20];
                                        String week[] = new String[20];
                                        String day[] = new String[20];
                                        sql = String.format("SELECT * FROM SC,course where course.Cno = SC.Cno and Sno='%s'", Sno);
                                        try {
                                           Statement statement = conn.createStatement();
                                            ResultSet rs1 = statement.executeQuery(sql);
                                            int j = 0;
                                            while (rs1.next()) {
                                                String cname = rs1.getString("Cname");
                                                String cweek = rs1.getString("Cweek");
                                                String cday = rs1.getString("Cday");
                                                name[j] = cname;
                                                week[j] = cweek;
                                                day[j] = cday;
                                                j++;
                                            }
                                            for (int i = 1; i < 5; i++) {
                                                String ii = i + "";
                                                out.println("<tr>");
                                                out.println("<td>" + ii + "</td>");
                                                for (int k = 1; k < 8; k++) {
                                                    String kk = k + "";
                                    %>
                                    <%
                                                    int flag = 1;
                                                    for (int m = 0; m < j; m++) {
                                                        if (week[m].equals(kk) && day[m].equals(ii)) {
                                                            out.println("<td>" + name[m] + "</td>");
                                                            flag = 0;
                                                            break;
                                                        }
                                                    }
                                                    if (flag == 1)
                                                        out.println("<td></td>");
                                                }
                                                out.println("</tr>");
                                            }
                                            rs1.close();
                                            statement.close();
                                            conn.close();
                                        } catch (SQLException e) {
                                            e.printStackTrace();
                                        }
                                    %>
                                    </tbody>
                                </table>
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