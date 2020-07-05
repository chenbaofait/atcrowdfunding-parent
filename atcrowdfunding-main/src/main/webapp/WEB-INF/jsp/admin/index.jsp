<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%--
  Created by IntelliJ IDEA.
  User: Maibenben
  Date: 2020/6/18
  Time: 21:10
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <%@include file="/WEB-INF/jsp/common/css.jsp"%>
    <style>
        .tree li {
            list-style-type: none;
            cursor:pointer;
        }
        table tbody tr:nth-child(odd){background:#F4F4F4;}
        table tbody td:nth-child(even){color:#C00;}
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/jsp/common/menu.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">


                    <form id="queryForm" class="form-inline" role="form" style="float:left;" action="${PATH}/admin/index" method="post">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input class="form-control has-success" type="text" name="condition" value="${param.condition}" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="queryBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>


                    <button id="deleteBatchBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='${PATH}/admin/toAdd'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">序号</th>
                                <th width="30"><input id="theadCheckbox" type="checkbox"></th>
                                <th>账号</th>
                                <th>名称</th>
                                <th>邮箱地址</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach var="admin" items="${sessionScope.page.list}" varStatus="status" >
                                <tr>
                                    <td>${status.count}</td>
                                    <td><input class="tbodyCheckboxclass" type="checkbox" adminId="${admin.id}"></td>
                                    <td>${admin.loginacct}</td>
                                    <td>${admin.username}</td>
                                    <td>${admin.email}</td>
                                    <td>
                                        <button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>
                                        <button type="button" class="btn btn-primary btn-xs" onclick="window.location.href='${PATH}/admin/toUpdate?id=${admin.id}&pageNum=${sessionScope.page.pageNum}'"><i class=" glyphicon glyphicon-pencil"></i></button>
                                        <button type="button" class="btn btn-danger btn-xs" onclick="deleteAdmin(${admin.id},'${admin.loginacct}')"><i class=" glyphicon glyphicon-remove"></i></button>
                                    </td>
                                </tr>
                           </c:forEach>
                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">
                                        <c:if test="${sessionScope.page.isFirstPage}">
                                            <li class="disabled"><a href="#">上一页</a></li>
                                        </c:if>
                                        <c:if test="${not sessionScope.page.isFirstPage}">
                                            <li ><a href="${PATH}/admin/index?pageNum=${page.pageNum - 1}&condition=${param.condition}">上一页</a></li>
                                        </c:if>

                                        <c:forEach items="${sessionScope.page.navigatepageNums}" var="num">
                                            <c:if test="${sessionScope.page.pageNum == num}">
                                                <li class="active"><a href="${PATH}/admin/index?pageNum=${num}&condition=${param.condition}">${num}</a></li>
                                            </c:if>
                                            <c:if test="${sessionScope.page.pageNum != num}">
                                                <li><a href="${PATH}/admin/index?pageNum=${num}&condition=${param.condition}">${num}</a></li>
                                            </c:if>

                                        </c:forEach>
                                        <c:if test="${sessionScope.page.isLastPage}">
                                            <li class="disabled"><a href="#">下一页</a></li>
                                        </c:if>
                                        <c:if test="${not sessionScope.page.isLastPage}">
                                            <li ><a href="${PATH}/admin/index?pageNum=${sessionScope.page.pageNum +  1}&condition=${param.condition}">下一页</a></li>
                                        </c:if>
                                    </ul>
                                </td>
                            </tr>

                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@include file="/WEB-INF/jsp/common/js.jsp"%>
<script type="text/javascript">
    $(function () {
        $(".list-group-item").click(function(){
            if ( $(this).find("ul") ) {
                $(this).toggleClass("tree-closed");
                if ( $(this).hasClass("tree-closed") ) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });
    });
    $("#queryBtn").click(function () {
        $("#queryForm").submit();

    });
    function deleteAdmin(id,loginacct) {


        layer.confirm("您确定要删除【"+loginacct+"】账户？",{btn:["确定","取消"]},function () {
                window.location.href="${PATH}/admin/doDelete?id="+id+"&pageNum=${sessionScope.page.pageNum}"
        },function () {

        });

    }

    $("#theadCheckbox").click(function () {
        var theadChecked = this.checked;
        $(".tbodyCheckboxclass").prop("checked",theadChecked);
    });

    $("#deleteBatchBtn").click(function () {

        var tbodyCheckedList = $(".tbodyCheckboxclass:checked");
        if (tbodyCheckedList.length == 0){
            layer.msg("请选择数据后进行删除！");
            return false
        }
        layer.confirm("您确定要删除这些账户？",{btn:["确定","取消"]},function () {
            var  idstr = '';

            var arrayObj = new Array();

            $.each(tbodyCheckedList,function (i,e) {
                var adminId = $(e).attr("adminId");
                // alert(adminId);
                arrayObj.push(adminId);

            });

            idstr = arrayObj.join(",");
            window.location.href="${PATH}/admin/doDeleteBatch?ids="+idstr+"&pageNum=${sessionScope.page.pageNum}"
        },function () {

        });




    });
</script>
</body>
</html>

