<%@ include file="/WEB-INF/jsp/header.jsp"%>

<portlet:renderURL var="renderRefreshUrl" />

<c:if test="${not empty user}">

	<h1><spring:message code="edit.title"/></h1>

	<a href="<portlet:renderURL portletMode="edit"/>" class="icn-fam icn-fam-back">
		<spring:message code="edit.admin.back"/>
	</a> - 	
	<a href="<portlet:renderURL portletMode="view"/>" class="icn-fam icn-fam-back">
		<spring:message code="go.back.home"/>
	</a> - 	
	<portlet:renderURL var="statsAdmin" portletMode="edit">
	  <portlet:param name="action" value="adminStats"/>
	</portlet:renderURL>
	<a href="${statsAdmin}" class="icn-fam icn-fam-stats">
		Stats
	</a>

<br/>
	
<portlet:actionURL var="setAreas">
  <portlet:param name="action" value="setDefaultArea"/>
</portlet:actionURL>

	<legend><spring:message code="edit.admin.form.chooseFeed"/></legend>
	<portlet:actionURL var="urlFlux">
	  <portlet:param name="action" value="urlFeed"/>
	</portlet:actionURL>

	<form method="post" action="${urlFlux}" class="clearfix">		
		<c:if test="${not empty feedList}">
			
			<c:set var="feediIdSelected" value="0"/>
			<select id="field-feed" name="feedId">
				<c:forEach var="feedInfo" items="${feedList}">
					<c:choose>
						<c:when test="${feedInfo.isDefault == true}">
							<c:set var="selected" value="selected=\"selected\""/>
							<c:set var="feediIdSelected" value="${feedInfo.id}"/>
						</c:when>
						<c:otherwise>
							<c:set var="selected" value=""/>
						</c:otherwise>
					</c:choose>
					<option value="${feedInfo.id}" ${selected}>
						${feedInfo.name}
					</option>
				</c:forEach>
			</select>
			
			<input type="submit"/>
											
		</c:if>
	</form>
	<hr/>
		
	<div>
	<legend><spring:message code="edit.form.zone.legend"/></legend>
	<form method="post" action="${setAreas}" class="clearfix"> 
	
		<c:forEach var="areaValue" items="${areaList}" varStatus="status">
			<label for="field-areas-${status.index}">
				<input type="checkbox" value="${areaValue}" name="chkArea[]" id="field-areas-${status.index}"
					<c:forEach var="areaDb" items="${defaultArea}">
						<c:if test="${areaDb == areaValue}">checked="checked"</c:if>
					</c:forEach>
				>
				${areaValue}
			</label>
		</c:forEach>
		<input type="hidden" value="${feediIdSelected}" name="feedId"> 
		
		<br/>
		<c:if test="${areaSubmit}">
			<label class="is-valid icn-fam icn-fam-valid">
				<spring:message code="edit.msg.success"/>
			</label>
		</c:if>
		
		<input type="submit"/>
	</form>
</div>

<hr/>
		
		<portlet:actionURL var="forceFeedUpdate">
		  <portlet:param name="action" value="forceFeedUpdate"/>
		</portlet:actionURL>
		
		<p>
			<a href="${forceFeedUpdate}" class="btn btn-primary">
				<spring:message code="edit.admin.forceupdate"/>
			</a>
		</p>
		<c:if test="${not empty updateFeed}">
			${updateFeed}
		</c:if>
		
</c:if>
<c:if test="${empty user}">
	<spring:message code="admin.notallowed"/>
</c:if>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>
