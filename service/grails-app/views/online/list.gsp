
<%@ page import="videochat.Online" %>
<!DOCTYPE html>
<html>
	<head>
		<meta name="layout" content="main">
		<g:set var="entityName" value="${message(code: 'online.label', default: 'Online')}" />
		<title><g:message code="default.list.label" args="[entityName]" /></title>
	</head>
	<body>
		<a href="#list-online" class="skip" tabindex="-1"><g:message code="default.link.skip.label" default="Skip to content&hellip;"/></a>
		<div class="nav" role="navigation">
			<ul>
				<li><g:link class="list" action="list" controller="mediaService"><g:message code="default.list.label" args="[message(code: 'mediaService.label', default: 'Services')]" /></g:link></li>
				<li><g:link class="list" action="list" controller="mediaBackup"><g:message code="default.list.label" args="[message(code: 'mediaBackup.label', default: 'Backups')]" /></g:link></li>
				<li><g:link class="list" action="list" controller="online"><g:message code="default.list.label" args="[message(code: 'online.label', default: 'Onlines')]" /></g:link></li>
				<li><g:link class="list" action="list" controller="mediaEvent"><g:message code="default.list.label" args="[message(code: 'mediaEvent.label', default: 'Media Event')]" /></g:link></li>
			</ul>
		</div>
		<div id="list-online" class="content scaffold-list" role="main">
			<h1><g:message code="default.list.label" args="[entityName]" /></h1>
			<g:if test="${flash.message}">
			<div class="message" role="status">${flash.message}</div>
			</g:if>
			<table>
				<thead>
					<tr>
					
						<g:sortableColumn property="uid" title="${message(code: 'online.uid.label', default: 'Uid')}" />
					
						<g:sortableColumn property="mediaServiceId" title="${message(code: 'online.mediaServiceId.label', default: 'Media Service Id')}" />
					
						<g:sortableColumn property="sessionId" title="${message(code: 'online.sessionId.label', default: 'Session Id')}" />
					
						<g:sortableColumn property="dateCreated" title="${message(code: 'online.dateCreated.label', default: 'Date Created')}" />
					
						<g:sortableColumn property="subscriber" title="${message(code: 'online.subscriber.label', default: 'Subscriber')}" />
					
						<g:sortableColumn property="lastPing" title="${message(code: 'online.lastPing.label', default: 'Last Ping')}" />
                        
                        <th>&nbsp;</th>
					
					</tr>
				</thead>
				<tbody>
				<g:each in="${onlineInstanceList}" status="i" var="onlineInstance">
                    <g:set var="mediaService" value="${videochat.MediaService.get(onlineInstance.mediaServiceId)}" />
					<tr class="${(i % 2) == 0 ? 'even' : 'odd'}">
					
						<td uuid="${onlineInstance?.id}"><g:link controller="mediaBackup" action="listByUid" id="${onlineInstance.uid}">${fieldValue(bean: onlineInstance, field: "uid")}</g:link></td>

                        <g:if test="${mediaService}">
                        <td><g:link action="show" id="${mediaService?.id}" controller="mediaService">${fieldValue(bean: mediaService, field: "name")}</g:link></td>
                        </g:if>
                        <g:else>
						<td>${fieldValue(bean: onlineInstance, field: "mediaServiceId")}</td>
                        </g:else>
					
						<td><g:link controller="mediaBackup" action="listBySession" id="${onlineInstance.sessionId}">${fieldValue(bean: onlineInstance, field: "sessionId")}</g:link></td>
					
						<td><g:formatDate date="${onlineInstance.dateCreated}" /></td>
					
						<td>${fieldValue(bean: onlineInstance, field: "subscriber")}</td>
					
						<td><g:formatDate date="${onlineInstance.lastPing}" /></td>
                        
                        <td><g:remoteLink before="if(!confirm('Are you sure?')) return false" onSuccess="location.reload()" onFailure="alert('删除失败！')"
                                controller="api" action="removeSession" id="${onlineInstance.sessionId}">下线</g:remoteLink></td>
					
					</tr>
				</g:each>
				</tbody>
			</table>
			<div class="pagination">
				<g:paginate total="${onlineInstanceTotal}" />
			</div>
		</div>


	</body>
</html>
