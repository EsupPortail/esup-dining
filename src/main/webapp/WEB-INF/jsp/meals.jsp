<%@ include file="/WEB-INF/jsp/header.jsp"%>
	
	<p>
		<a href="<portlet:renderURL portletMode="view"/>" class="icn-fam icn-fam-back">
			<spring:message code="go.back.home" />
		</a>
	</p>

	<c:if test="${not empty restaurant}">
		
		<nav class="navbar navbar-default" role="navigation">
		
  	    	    <div class="navbar-header">
		    	<span type="button" class="navbar-toggle" data-toggle="collapse" data-target="#bs-example-navbar-collapse-1">
				    <span class="sr-only">Toggle navigation</span>
				    <span class="icon-bar"></span>
				    <span class="icon-bar"></span>
				    <span class="icon-bar"></span>
		    	</span>
		    	<span class="navbar-brand">${restaurant.title}</span>
		    </div>

			<div class="collapse navbar-collapse" id="bs-example-navbar-collapse-1">
				<ul class="nav navbar-nav">
					<li>
						<c:choose>
							<c:when test="${isFavorite}">
								<portlet:actionURL var="removeFromFavorite">
									<portlet:param name="action" value="removeFavorite" />
									<portlet:param name="restaurant-id" value="${restaurant.id}" />
								</portlet:actionURL>
								<a href="${removeFromFavorite}" class="icn-fam icn-fam-fav">
									<spring:message code="restaurant.link.removeFromFavorite"/>
								</a>
							</c:when>
							<c:otherwise>

								<portlet:actionURL var="addToFavorite">
									<portlet:param name="action" value="setFavorite" />
									<portlet:param name="id" value="${restaurant.id}" />
								</portlet:actionURL>
								<a href="${addToFavorite}" class="icn-fam icn-fam-fav">
									<spring:message code="restaurant.link.addToFavorite"/>
								</a>
								
							</c:otherwise>
						</c:choose>
					</li>
					<li>
						<portlet:renderURL var="viewRestaurant">
							<portlet:param name="action" value="viewRestaurant" />
							<portlet:param name="id" value="${restaurant.id}" />
						</portlet:renderURL>
						
						<a href="${viewRestaurant}" class="icn-fam icn-fam-meal">
							<spring:message code="restaurant.link.viewRestaurant"/>
						</a>
					</li>
					<c:if test="${restaurant.accessibility}">
					<li>
						<a href="" class="icn-fam icn-fam-disability disabled">
							<spring:message code="restaurant.msg.disability"/>
						</a>
					</li>
					</c:if>
					<c:if test="${restaurant.wifi}">
					<li>
						<a href="" class="icn-fam icn-fam-wifi disabled">
							<spring:message code="restaurant.wifi"/>					
						</a>
					</li>
					</c:if>
				</ul>
			</div>
		</nav>
		
                <c:if test="${restaurantClosed}">
                        <div class="alert alert-warning">
                                <a class="close" data-dismiss="alert">×</a>
                                <strong><spring:message code="restaurant.closed"/></strong>
                        </div>
                </c:if>

		<c:if test="${!restaurantClosed}">
			<div class="menus">
				<ul class="tab-header">
					<c:forEach var="menu" items="${menus}">
						<li>
							<a href="#menu-${menu.date}">
								<fmt:parseDate value="${menu.date}" var="parsedDate" pattern="yyyy-MM-dd" />
								<fmt:formatDate value="${parsedDate}" pattern="${sessionScope.dateLocalePattern}" />
							</a>
						</li>
					</c:forEach>
				</ul>
				<c:if test="${empty menus}">
				<center><h2>Aucun menu disponible</h2></center>
				</c:if>
	
				<c:forEach var="menu" items="${menus}">
					
					<div id="menu-${menu.date}">
						<h2>
							<fmt:parseDate value="${menu.date}" var="parsedDate" pattern="yyyy-MM-dd" />
							<fmt:formatDate value="${parsedDate}" pattern="${sessionScope.dateLocalePattern}" />
						</h2>
						<div class="meals-accordion">
							
							<c:forEach var="meal" items="${menu.meal}">
			
								<h3 class="accordion-title">
									${meal.name}
								</h3>
	
								<div class="meal-container" style="height: auto !important;">
	
									<c:forEach var="foodCategory" items="${meal.foodcategory}">
				
										<h4>
											${foodCategory.name}
										</h4>
										
										<table>
											<c:forEach var="dish" items="${foodCategory.dishes}">
												<c:set var="findAllergen" value="0"/>
												<portlet:renderURL var="viewDish">
													<portlet:param name="action" value="viewDish"/>
													<portlet:param name="id" value="${restaurant.id}"/>
													<portlet:param name="name" value="${dish.name}"/>
													<portlet:param name="ingredients" value="${dish.ingredients}"/>
													<portlet:param name="nutritionitems" value="${dish.nutritionitems}"/>
													<portlet:param name="code" value="${dish.code}"/>
												</portlet:renderURL>
												<tr>
												<th width="75px" style="padding-right:1em; background-color: transparent; text-align:right">
													<c:if test="${not empty dish.code}">
														<c:forEach var="codeNumber" items="${dish.code}">
															<c:forEach var="userCodeNumber" items="${nutritionPrefs}">
																
																<c:if test="${codeNumber==userCodeNumber}">
																	
																	<c:choose>
																		<c:when test="${codeNumber=='12'}">
																			<a href="${viewDish}">
																			<img src="<%= renderRequest.getContextPath() %><spring:message code="meal.code.${codeNumber}.img" />"
																				 alt="<spring:message code="meal.code.${codeNumber}.description" />"
																				 title="<spring:message code="meal.code.${codeNumber}.name" />"/>	
																			</a>
																		</c:when>
																		<c:when test="${codeNumber=='15'}">
																			<a href="${viewDish}">
																			<img src="<%= renderRequest.getContextPath() %><spring:message code="meal.code.${codeNumber}.img" />"
																				 alt="<spring:message code="meal.code.${codeNumber}.description" />"
																				 title="<spring:message code="meal.code.${codeNumber}.name" />"/>	
																			</a>
																		</c:when>
																		<c:otherwise>
																		
																			<c:set var="findAllergen" value="1"/>
																		</c:otherwise>
																	</c:choose>
																</c:if>
															</c:forEach>								
														</c:forEach>
														
														<c:if test="${findAllergen == 1}">
															<a href="${viewDish}">
															<img src="/esup-dining/images/danger.png" width="16px" height="16px"
																 alt="<spring:message code="meal.danger.name" />"
																 title="<spring:message code="meal.danger.description" />"/>	
															</a>
														</c:if>
													</c:if>
												</th>
												<th style="background-color: transparent;">
													<li>

														<c:if test="${not empty dish.code or not empty dish.ingredients or not empty dish.nutritionitems}">
														<a href="${viewDish}">
														</c:if>
														${dish.name}
														<c:if test="${not empty dish.code or not empty dish.ingredients or not empty dish.nutritionitems}">
														</a>
														</c:if>	
													</li>
												</th>
												<th width="200px" STYLE="padding-left:1em; background-color: transparent;">
													<c:if test="${not empty dish.code or not empty dish.ingredients or not empty dish.nutritionitems}">
													<a href="${viewDish}">
													</c:if>
													
													<c:if test="${not empty dish.code or not empty dish.ingredients or not empty dish.nutritionitems}">
														<c:forEach var="codeNumber" items="${dish.code}">
														
															<c:choose>
																<c:when test="${codeNumber=='12'}">
																</c:when>
																<c:when test="${codeNumber=='15'}">
																</c:when>
																<c:otherwise>
																	<img src="<%= renderRequest.getContextPath() %><spring:message code="meal.code.${codeNumber}.img" />"
																		 alt="<spring:message code="meal.code.${codeNumber}.description" />"
																		 title="<spring:message code="meal.code.${codeNumber}.name" />"/>	
																</c:otherwise>
															</c:choose>

														</c:forEach>
													</c:if>	
													
													<c:if test="${not empty dish.code or not empty dish.ingredients or not empty dish.nutritionitems}">
													</a>
													</c:if>		
												</th>
												</tr>
											</c:forEach>
										</table>

									</c:forEach>
								</div>
							</c:forEach>
						</div>
					</div>
		
				</c:forEach>
			</div>
		</c:if>
	</c:if>	

<script type="text/javascript">
	$(window).load(function() {

		var $menus = $(".menus").tabs();
		var $meals = $(".meals-accordion").accordion();

		$menus.each(function(index) {

			var $menuLi = $(this).find('.tab-header li');

			$menuLi.click(function(e) {
				var indexClick = $menuLi.index($(this));
				// We need to refresh the accordion because jQuery UI cannot calculate the height of a display none accordion element.
				$menus.eq(indexClick).tabs("refresh");
				$meals.accordion("refresh");
			});

		});
		
	});
</script>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>
