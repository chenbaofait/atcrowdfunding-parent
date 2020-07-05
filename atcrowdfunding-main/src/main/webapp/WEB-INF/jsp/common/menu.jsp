
<%--
  Created by IntelliJ IDEA.
  User: Maibenben
  Date: 2020/6/16
  Time: 22:21
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<div class="col-sm-3 col-md-2 sidebar">
    <div class="tree">
        <ul style="padding-left:0px;" class="list-group">
<%--            父菜单没孩子的--%>
            <c:forEach items="${sessionScope.parentMenuList}" var="parentMenu">
                <c:if test="${empty parentMenu.children}">
                    <li class="list-group-item tree-closed" >
                        <a href="${PATH}/${parentMenu.url}"><i class="${parentMenu.icon}"></i> ${parentMenu.name}</a>
                    </li>
                </c:if>
                <c:if test="${not empty parentMenu.children}">
                    <%--    父菜单有孩子的--%>
                    <li class="list-group-item tree-closed">
                        <span><i class="${parentMenu.icon}"></i> ${parentMenu.name} <span class="badge" style="float:right">${parentMenu.children.size()}</span></span>
                        <ul style="margin-top:10px;display:none;">
                            <c:forEach items="${parentMenu.children}" var="childMenu">
                                <li style="height:30px;">
                                    <a href="${PATH}/${childMenu.url}"><i class="${childMenu.icon}"></i> ${childMenu.name}</a>
                                </li>
                            </c:forEach>
                        </ul>
                    </li>
                </c:if>

            </c:forEach>
        </ul>
    </div>
</div>