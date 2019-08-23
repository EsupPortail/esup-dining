<%@ include file="/WEB-INF/jsp/header.jsp"%>

	<p>
		<portlet:renderURL var="viewRestaurant">
			<portlet:param name="action" value="viewRestaurant"/>
			<portlet:param name="id" value="${restaurantId}"/>
		</portlet:renderURL>
		<a href="${viewRestaurant}" class="icn-fam icn-fam-back">
			<spring:message code="restaurant.link.back"/>
		</a>
		 |
		<portlet:renderURL var="viewMeals">
			<portlet:param name="action" value="viewMeals" />
			<portlet:param name="id" value="${restaurantId}" />
		</portlet:renderURL>
		<a href="${viewMeals}" class="icn-fam icn-fam-back">
			<spring:message code="restaurant.link.viewMeals"/>
		</a>

	</p>
	
	<h1>
		${name}
	</h1>
	
	<c:if test="${not empty ingredients}">
		<p>
			<strong><spring:message code="meal.ingredients"/> :</strong>
			${ingredients}
		</p>
	</c:if>
	</br>
	

	<c:if test="${not empty nutritionitems}">
		<p>
			<strong><spring:message code="meal.nutritionitems"/> :</strong>
			<ul>
				<c:forEach var="nutritionitem" items="${nutritionitems}">
					<li>
						<strong>${nutritionitem.name}</strong> : ${nutritionitem.value}
					</li>
				</c:forEach>
			</ul>
		</p>
	</c:if>

	<c:set var="findAllergen" value="0"/>
	
	<c:if test="${not empty code}">
		<c:forEach var="codeNumber" items="${code}">
			<c:choose>
				<c:when test="${fn:trim(codeNumber)=='12'}">
				</c:when>
				<c:when test="${fn:trim(codeNumber)=='15'}">
				</c:when>

				<c:otherwise>
					<c:forEach var="userCodeNumber" items="${nutritionPrefs}">
						<c:if test="${fn:trim(codeNumber)==fn:trim(userCodeNumber)}">
							<c:set var="findAllergen" value="1"/>
						</c:if>
					</c:forEach>
				</c:otherwise>
			</c:choose>	
		</c:forEach>
	</c:if>

	<c:if test="${findAllergen == 1}">
		<div>
			<h2>
				<img src="/esup-dining/images/danger.png" width="30px" height="30px"
				/>
				<spring:message code="meal.danger.name"/>
			</h2>
		</div>
	</c:if>

	<c:if test="${not empty code}">
		<c:forEach var="codeNumber" items="${code}">
			<c:choose>
				<c:when test="${fn:trim(codeNumber)=='12'}">
				</c:when>
				<c:when test="${fn:trim(codeNumber)=='15'}">
				</c:when>

				<c:otherwise>
					<c:if test="${not empty fn:trim(codeNumber)}">
						<p style="margin-left:44px;">
							<img src="<%=renderRequest.getContextPath()%><spring:message code="meal.code.${fn:trim(codeNumber)}.img" />"
							 	alt="<spring:message code="meal.code.${fn:trim(codeNumber)}.description" />"
							 	title="<spring:message code="meal.code.${fn:trim(codeNumber)}.name" />"
							/>
							<spring:message code="meal.code.${fn:trim(codeNumber)}.description" />
						</p>
					</c:if>
				</c:otherwise>
			</c:choose>	
		</c:forEach>
	</c:if>
	

	

	<c:if test="${not empty code}">
			<c:forEach var="codeNumber" items="${code}">
				<c:if test="${fn:trim(codeNumber) == '12'}">
					<div>
						<h2>
							<img src="<%=renderRequest.getContextPath()%><spring:message code="meal.code.${fn:trim(codeNumber)}.img" />"
							 width="30px" height="30px"
							/>
							<spring:message code="meal.code.${fn:trim(codeNumber)}.name"/>
						</h2>
						<p style="margin-left:44px;">
							<spring:message code="meal.code.${fn:trim(codeNumber)}.description"/>
						</p>
					</div>
				
				</c:if>
				
				<c:if test="${fn:trim(codeNumber) == '15'}">
					<div>
						<h2>
							<img src="<%=renderRequest.getContextPath()%><spring:message code="meal.code.${fn:trim(codeNumber)}.img" />"
							 width="30px" height="30px"
							/>
							<spring:message code="meal.code.${fn:trim(codeNumber)}.name"/>
						</h2>
						<p style="margin-left:44px;">
							<spring:message code="meal.code.${fn:trim(codeNumber)}.description"/>
						</p>
					</div>
				</c:if>
			</c:forEach>		
	</c:if>
	
</br>
<%@ include file="/WEB-INF/jsp/footer.jsp"%>	
