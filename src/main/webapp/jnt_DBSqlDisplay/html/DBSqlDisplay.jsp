<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<template:addResources type="css" resources="dbsql.css"/>
<script type="text/javascript" src="/modules/SQLDisplay/javascript/dbsql.js"></script>
<!-- Sample query: SELECT * FROM jahia.jahia_qrtz_triggers j -->

<div id="DB Module">
			<span class="header"><fmt:message key='jnt_DBSqlDisplay.title'/></span>
			<br/><b>Executed query:</b> ${currentNode.properties['selectStatement'].string}	
			<c:choose>
				<c:when test="${!renderContext.editMode}">
					<br/><b>Page Size: </b>${currentNode.properties['pageSize'].string}
					<br/><b>Current Page: </b><span id="displayPage"></span>	
					<br/> <a href="javascript:void(0)" onclick="dbPaging(-1)">prev</a>|<a href="javascript:void(0)" onclick="dbPaging(1)">next</a>
				</c:when>
				<c:otherwise>
					<br/>The data of this module is shown only on Live and Preview Mode
				</c:otherwise>
			</c:choose>
			<sql:setDataSource dataSource="${currentNode.properties['dataSource'].string}"/> 
				<sql:query var="items" sql="${currentNode.properties['selectStatement'].string}">
			</sql:query>
			
			<input type="hidden" id="pageSize" name="pageSize" value="${currentNode.properties['pageSize'].string}">
			<input type="hidden" id="redirectPath" name="redirectPath" value="<c:url value='${currentNode.path}.sqlPaging.do' context='${url.base}'/>">
			<input type="hidden" id="totalRows" name="totalRows" value="${items.rowCount}">
			<input type="hidden" id="totalColumns" name="totalColumns" value="${fn:length(items.columnNames)}">
			<input type="hidden" id="currentPage" name="currentPage" value="1">
			
			<div id="resultsContainer">	    
			     <table border="1" id="results">
			     <tbody>
			     <!-- Print table Name -->
			     <tr><td colspan="${fn:length(items.columnNames)}" class="tableTitle">${currentNode.properties["jcr:title"].string}</td></tr>
			     <!-- Print Column Names -->
				     <tr>
				     	<c:forEach var="rowName" items="${items.columnNames}">
								<th>${rowName}</th>			
						</c:forEach>
					</tr>
					<c:set var="resultSet"  value="${items.rowsByIndex}" scope="session"  />			
				<!-- Column Values via AJAX -->	
				<script type="text/javascript">	
						printResults($('#redirectPath').val(),$('#pageSize').val(), $('#totalRows').val(), $('#totalColumns').val(), 1);
						setPage(1);
				</script>
				</tbody>			
			    </table>		
			</div>		
</div>