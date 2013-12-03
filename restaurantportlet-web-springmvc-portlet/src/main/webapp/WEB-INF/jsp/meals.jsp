<%@ include file="/WEB-INF/jsp/header.jsp"%>
	
	<style type="text/css">
		.smart-choice {
			background: #00FF6A;
		}
		.warning {
			background: #FFD859;
		}
	</style>
	
	<p>${nothingToDisplay}</p>

	<c:if test="${not empty restaurant}">
		
		<h1>
			<spring:message code="meal.title" arguments="${restaurant.title}"/>
		</h1>

		<p>
			<portlet:renderURL var="viewRestaurant">
					<portlet:param name="action" value="viewRestaurant"/>
					<portlet:param name="id" value="${restaurant.id}"/>
			</portlet:renderURL>
			<a href="${viewRestaurant}" class="icn-fam icn-fam-back">
				<spring:message code="restaurant.link.back"/>
			</a>
		</p>
		
		<div class="menus">
			<ul class="tab-header">
				<c:forEach var="menu" items="${menus}">
					<li>
						<a href="#menu-${menu.date}">
							${menu.date}
						</a>
					</li>
				</c:forEach>
			</ul>
			<c:forEach var="menu" items="${menus}">
				
				<div id="menu-${menu.date}">
					<h2>
						${menu.date}
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
									
									<ul>
										<c:forEach var="dish" items="${foodCategory.dishes}">
											<li
												<c:if test="${not empty dish.code}">
													<c:forEach var="codeNumber" items="${dish.code}">
														<c:forEach var="userCodeNumber" items="${nutritionPrefs}">
															
															<c:if test="${codeNumber==userCodeNumber}">
																
																<c:choose>
																	<c:when test="${codeNumber=='15'}">
																		class="smart-choice"
																	</c:when>
																	<c:otherwise>
																		class="warning"
																	</c:otherwise>
																</c:choose>
															</c:if>
															
														</c:forEach>								
													</c:forEach>
												</c:if>
											>

												<portlet:renderURL var="viewDish">
													<portlet:param name="action" value="viewDish"/>
													<portlet:param name="id" value="${restaurant.id}"/>
													<portlet:param name="name" value="${dish.name}"/>
													<portlet:param name="ingredients" value="${dish.ingredients}"/>
													<portlet:param name="nutritionitems" value="${dish.nutritionitems}"/>
													<portlet:param name="code" value="${dish.code}"/>
												</portlet:renderURL>

												<c:if test="${not empty dish.code or not empty dish.ingredients or not empty dish.nutritionitems}">
												<a href="${viewDish}" class="icn-fam icn-fam-infos">
												</c:if>
													${dish.name}
												<c:if test="${not empty dish.code or not empty dish.ingredients or not empty dish.nutritionitems}">
												</a>
												</c:if>	
												<c:if test="${not empty dish.code}">
														<c:forEach var="codeNumber" items="${dish.code}">
															<img src="<%= renderRequest.getContextPath() %><spring:message code="meal.code.${codeNumber}.img" />"
															     alt="<spring:message code="meal.code.${codeNumber}.description" />"
																 title="<spring:message code="meal.code.${codeNumber}.name" />"
															/>									
														</c:forEach>
												</c:if>
			
											</li>
										</c:forEach>
									</ul>
								</c:forEach>
							</div>
						</c:forEach>
					</div>
				</div>
	
			</c:forEach>
		</div>
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
