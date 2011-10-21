<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="jcr" uri="http://www.jahia.org/tags/jcr" %>
<%@ taglib prefix="functions" uri="http://www.jahia.org/tags/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="template" uri="http://www.jahia.org/tags/templateLib" %>
<%@ taglib prefix="utility" uri="http://www.jahia.org/tags/utilityLib" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="sql" uri="http://java.sun.com/jsp/jstl/sql" %>
<template:addResources type="css" resources="dbSqlDisplay.css"/>
<script type="text/javascript" src="/modules/SQLDisplay/javascript/jquery.dataTables.min.js"></script>
<template:addResources type="javascript" resources="jquery.min.js"/>

<!-- Sample query: SELECT * FROM jahia.jahia_qrtz_triggers j -->
		<div id="DB Module">
			<span class="header">${currentNode.properties["jcr:title"].string}</span>
			<br/><b><fmt:message key='jnt_DBSqlDisplay.executeLabel'/>:</b> ${currentNode.properties['selectStatement'].string}	
			<c:choose>
				<c:when test="${!renderContext.editMode}">
					<br/>
					<br/>
					<sql:setDataSource dataSource="${currentNode.properties['dataSource'].string}"/> 
					<sql:query var="items" sql="${currentNode.properties['selectStatement'].string}">
					</sql:query>
					<c:set var="resultSet"  value="${items.rowsByIndex}" scope="session"  />	
					<input type="hidden" id="redirectPath" name="redirectPath" value="<c:url value='${currentNode.path}.sqlPaging.do' context='${url.base}'/>?maxSize=${currentNode.properties['maxRows'].string}">	
					<div id="resultsContainer">
						<table cellpadding="0" cellspacing="0" border="0" class="display" id="dbSqlTable">
							<thead>				
								<tr>
									<c:forEach var="rowName" items="${items.columnNames}">
											<th>${rowName}</th>			
									</c:forEach>				
								</tr>
							</thead>
							<tbody>
								<tr>
									<td colspan="${fn:length(items.columnNames)}" class="dataTables_empty">Loading data from server</td>
								</tr>
							</tbody>
							<tfoot>
						
								<tr>
									<c:forEach var="rowName" items="${items.columnNames}">
											<th>${rowName}</th>			
									</c:forEach>
								</tr>
							</tfoot>
						</table>			    
					</div>
				</c:when>
				<c:otherwise>
					<br/><fmt:message key='jnt_DBSqlDisplay.displayWarningLabel'/>
				</c:otherwise>
			</c:choose>		
		</div>
		<script type="text/javascript" charset="utf-8">
			$(document).ready(function() {
				var oTable = $('#dbSqlTable').dataTable( {
				"bFilter": false,
				"bSort": false,
				"bSearchable": false,
				"bLengthChange": false,
				"iDisplayLength": ${currentNode.properties['pageSize'].string},
				"bProcessing": true,
		        "bServerSide": true,
		        "sAjaxSource": $('#redirectPath').val()
				} );
			} );
		</script>