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


                    <form id="queryForm" class="form-inline" role="form" style="float:left;" >
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input class="form-control has-success" type="text" name="condition" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="queryBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>


                    <button id="deleteBatchBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button id="addBtn" type="button" class="btn btn-primary" style="float:right;" ><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">序号</th>
                                <th width="30"><input id="theadCheckbox" type="checkbox"></th>
                                <th>角色名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>

                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">

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



<!-- 添加角色的模态框 -->
<div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabel">添加角色</h4>
            </div>
            <div class="modal-body">
                <form id="addFrom" role="form">
                    <div class="form-group">
                        <label >角色名称</label>
                        <input type="text" class="form-control" name="name" placeholder="请输入角色名称">
                    </div>


                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
            </div>
        </div>
    </div>
</div>
<!-- 修改角色的模态框 -->
<div class="modal fade" id="updateModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel">
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                <h4 class="modal-title" id="myModalLabe2">修改角色</h4>
            </div>
            <div class="modal-body">
                <form id="updateFrom" role="form">
                    <div class="form-group">
                        <label >角色名称</label>
                        <input type="hidden" name="id">
                        <input type="text" class="form-control" name="name" placeholder="请输入角色名称">
                    </div>


                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                <button id="updateBtn" type="button" class="btn btn-primary">修改</button>
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
        showData(1);
    });
    var json ={
        pageNum:1,
        pageSize:2,
        condition:''
    }
    function showData(pageNum){
        //发起异步请求加载数据局部刷新
        json.pageNum = pageNum;
        $.ajax({
            type:"post",
            url:"${PATH}/role/loadData",
            data:json,
            success:function (result) {
                //result就表示服务器请求返回的结果，一般就是json格式数据
                console.log(result);
                //局部刷新
                showTable(result.list);//通过分页对象获取列表数据
                showNavg(result);//显示导航包
            }

        });

    }
    //通过分页对象获取列表数据
    function showTable(list) {
        var  content = '';
        $.each(list,function (i,e) {
            content+='<tr>';
            content+='	<td>'+(i+1)+'</td>';
            content+='	<td><input type="checkbox"></td>';
            content+='	<td>'+e.name+'</td>';
            content+='	<td>';
            content+='	<button type="button" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>';
            content+='	<button type="button" roleId="'+e.id+'" class="updateBtnClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>';
            content+='	<button type="button" roleId="'+e.id+'" class="deleteBtnClass btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>';
            content+='	</td>';
            content+='</tr>';
        });
        $("tbody").html(content);//把拼接好的html代码局部的刷新到tbody标签体中
    }
        //显示导航包
        function showNavg(pageInfo) {
            var  navg ='';
            if(pageInfo.isFirstPage){
                navg+='<li class="disabled"><a href="#">上一页</a></li>';
            }else{
                navg+='<li ><a onclick="showData('+(pageInfo.pageNum-1)+')">上一页</a></li>';
            }

            // navg+='<li class="active"><a href="#">1 <span class="sr-only">(current)</span></a></li>';
            $.each(pageInfo.navigatepageNums,function (i,num) {
                if (num == pageInfo.pageNum){
                    navg+='<li class="active"><a onclick="showData('+num+')">'+num+'</a></li>';
                }else{
                    navg+='<li><a onclick="showData('+num+')">'+num+'</a></li>';
                }

            });



            if(pageInfo.isLastPage){
                navg+='<li class="disabled"><a href="#">下一页</a></li>';
            }else{
                navg+='<li ><a onclick="showData('+(pageInfo.pageNum+1)+')">下一页</a></li>';
            }

            $(".pagination").html(navg);


        }


    //·······························~~~~~~~~~~~~~~~华丽分割线·~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    $("#queryBtn").click(function () {
       var condition =$("#queryForm input[name = 'condition']").val();
       json.condition = condition;//查询条件赋值到json对象作为请求参数
       showData(1);
    });

    //·······························~~~~~~~~~~~~~~~华丽分割线·~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    //添加角色：单机添加按钮弹出
    $("#addBtn").click(function () {
        $("#myModal").modal({
            show:true,
            backdrop:'static',//点击背景模态框不消失
            keyboard:false
        });
    });
//给模态框上的保存按钮增加事件
    $("#saveBtn").click(function () {
        // alert();
        //获取表单数据
        var name = $("#myModal input[name='name']").val();//val无参数表示获取值
        // var name = $("#myModal input[name='name']").val();

        //发起异步请求
        $.ajax({
            type: "post",
            url: "${PATH}/role/doRole",
            data:{name:name},
            success:function (result) {
                    if ("ok" == result){
                        $("#myModal input[name = 'name']").val("");//val有参数表示赋值
                        layer.msg("保存成功",function () {
                            $("#myModal").modal("hide");
                        });
                    }else {
                        layer.msg("保存失败");
                    }
            }
        });
    });
    //·······························~~~~~~~~~~~~~~~华丽分割线·~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    $("tbody").on("click",".updateBtnClass",function () {
        //首先获取id
        var roleId =$(this).attr("roleId");//将我们this dom对象转换为jquery对象通过attr（）函数来获取自定义属性值
        //获取修改数据，进行表单回显
        $.get("${PATH}/role/get",{id:roleId},function (result) {
           $("#updateModal input[name='name']").val(result.name);
            $("#updateModal input[name='id']").val(result.id);
           //弹出修改模态框
            $("#updateModal").modal({
                show:true,
                backdrop:'static',
                keyboard: false

            });
        });
        //弹出修改模态框


    });

    //提交修改表单，完成修改功能
    $("#updateBtn").click(function () {
        var name = $("#updateModal input[name='name']").val();
        var id = $("#updateModal input[name='id']").val();

        $.post("${PATH}/role/doUpdate",{id:id,name:name},function(result){


            if ("ok" == result){
                // $("#myModal input[name = 'name']").val("");//val有参数表示赋值
                layer.msg("修改成功",function () {
                    $("#updateModal").modal("hide");
                    showData(json.pageNum);
                });
            }else {
                layer.msg("修改失败");
            }
        });
    });
    $("tbody").on("click",".deleteBtnClass",function () {
        var roleId = $(this).attr("roleId");
        layer.confirm("您确定要删除数据吗",{btn:["确定","取消"]},function (index) {
            $.post("${PATH}/role/doDelete",{id:roleId},function (result) {
                if ("ok" == result){
                    layer.msg("删除成功",function () {
                        //刷新列表
                        showData(json.pageNum);
                    });

                }else{
                    layer.msg("删除失败");
                }

            });
            layer.close(index);
        },function (index) {
            layer.close(index);
        });

    });
</script>
</body>
</html>

