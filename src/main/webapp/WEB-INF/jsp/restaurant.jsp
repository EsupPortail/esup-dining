<%@ include file="/WEB-INF/jsp/header.jsp"%>

	<p>
		<a href="<portlet:renderURL portletMode="view"/>" class="icn-fam icn-fam-back">
			<spring:message code="go.back.home" />
		</a>
	</p>
	
	<c:if test="${restaurantClosed}">
		<div class="alert alert-warning">
			<a class="close" data-dismiss="alert">×</a>			
			${restaurant.operationalhours}
		</div>
	</c:if>

	<c:if test="${empty restaurant}">
		<h1>
			<spring:message code="restaurant.empty"/>
		</h1>
		<portlet:renderURL var="goToHome"/>	
		<a href="${goToHome}">
			<spring:message code="go.back.home"/>
		</a>
	</c:if>

	<c:if test="${not empty restaurant && !restaurantClosed}">		
			
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
						<portlet:renderURL var="viewMeals">
							<portlet:param name="action" value="viewMeals" />
							<portlet:param name="id" value="${restaurant.id}" />
						</portlet:renderURL>
						
						<a href="${viewMeals}" class="icn-fam icn-fam-meal">
							<spring:message code="restaurant.link.viewMeals"/>
						</a>
					</li>
					<c:if test="${restaurant.accessibility}">
					<li>
						<span class="icn-fam icn-fam-disability">
							<spring:message code="restaurant.msg.disability"/>
						</span>
					</li>
					</c:if>
					<c:if test="${restaurant.wifi}">
					<li>
						<span class="icn-fam icn-fam-wifi">
							<spring:message code="restaurant.wifi"/>					
						</span>
					</li>
					</c:if>
				</ul>
			<div>
		</nav>
		
		<%-- start short desc --%>
		<c:if test="${not empty restaurant.shortdesc}">
			<p>
				${restaurant.shortdesc}
			</p>
		</c:if>		
		<%-- end short desc --%>

			<%-- Start photo block --%>
			<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4 ta-center">
				<c:if test="${not empty restaurant.photo.src}">
					<img src="${restaurant.photo.src}" alt="${restaurant.photo.alt}" />
				</c:if>	
			</div>
			<%-- end photo block --%>
			<div class="col-xs-12 col-sm-6 col-md-8 col-lg-8">
				<%-- start description --%>
				<c:if test="${not empty restaurant.description}">
					<p>
						<strong><spring:message code="restaurant.msg.description"/></strong> :
						${restaurant.description}
					</p>
				</c:if>		
				<%-- end description --%>
				<%-- start capacity --%>
				<c:if test="${not empty restaurant.capacity}">
					<p>
						<strong><spring:message code="restaurant.msg.capacity"/></strong> : 
						${restaurant.capacity}
					</p>
				</c:if>
				<%-- end capacity --%>
				<%-- start operational hours --%>
				<c:if test="${not empty restaurant.operationalhours}">
					<p>
						<strong><spring:message code="restaurant.msg.operationalhours"/></strong> :
						${restaurant.operationalhours}
					</p>
				</c:if>		
				<%-- end operational hours --%>
				<%-- start address --%>
				<c:if test="${not empty restaurant.address}">
					<p>
						<strong><spring:message code="restaurant.msg.address"/></strong> :
						${restaurant.address}
					</p>
				</c:if>
				<%-- end address --%>
				<%-- start access --%>
				<c:if test="${not empty restaurant.access}">
					<p>
						<strong><spring:message code="restaurant.msg.access"/></strong> :
						${restaurant.access}
					</p>
				</c:if>		
				<%-- end access --%>
				<%-- start tel --%>
				<c:if test="${not empty restaurant.contact.tel}">
					<p>
						<strong><spring:message code="restaurant.msg.tel"/></strong> :
						${restaurant.contact.tel}
					</p>
				</c:if>		
				<%-- end tel --%>
				<%-- start email --%>
				<c:if test="${not empty restaurant.contact.email}">
					<p>
						<strong><spring:message code="restaurant.msg.email"/></strong> :
						${restaurant.contact.email}
					</p>
				</c:if>	
				<%-- end email --%>		
				<%-- start payment method --%>
				<c:if test="${not empty restaurant.payment}">
					<p>
						<strong><spring:message code="restaurant.payment"/></strong> :
					</p>
					<ul>
						<c:forEach var="method" items="${restaurant.payment}">
							<li>
								${method.name}
							</li>
						</c:forEach>
					</ul>
				</c:if>	
				<%-- end payment method --%>	

				<%-- start extras --%>
				<c:if test="${not empty restaurant.extras}">
					<c:forEach var="extra" items="${restaurant.extras}">
						<p>
							<strong>${extra.name}</strong> : ${extra.value}
						</p>
					</c:forEach>
				</c:if>

			</div>

			<%-- start table opening --%>			
			<div class="col-xs-12 col-sm-6 col-md-4 col-lg-4">
				<c:if test="${not empty restaurant.lat and not empty restaurant.lon}">
					<h2>
						<spring:message code="restaurant.msg.map"/>
					</h2>
					
					<div id="map-canvas"></div>
					<script type="text/javascript">
					function initialize() {
					    var myLatlng = new google.maps.LatLng(${restaurant.lat}, ${restaurant.lon});
						var mapOptions = {
					      center: myLatlng,
					      zoom: 14,
					      mapTypeId: google.maps.MapTypeId.ROADMAP
					    };
					    var map = new google.maps.Map(document.getElementById("map-canvas"),
					        mapOptions);
					    var marker = new google.maps.Marker({
					        position: myLatlng,
					        map: map,
					        title:"${restaurant.title}",
					        icon: "<%= renderRequest.getContextPath() + "/images/pin_resto.png" %>"
					    });
		    			window.onresize = function() {
							map.setCenter(myLatlng);
						}
					  }
					  google.maps.event.addDomListener(window, 'load', initialize);
					</script>
				</c:if>			
			</div>
			<%-- end table opening --%>
			<%-- start map --%>
			<div class="col-xs-12 col-sm-6 col-md-8 col-lg-8">
				<c:if test="${not empty restaurant.opening}">
					<h2>Jours d'ouverture</h2>
					<table id="opening" class="table table-striped">
						<tr>
							<th></th>
							<th><strong><spring:message code="restaurant.msg.opening.morning"/></strong></th>
							<th><strong><spring:message code="restaurant.msg.opening.midday"/></strong></th>
							<th><strong><spring:message code="restaurant.msg.opening.evening"/></strong></th>
					</table>
					<script type="text/javascript">
						var opening = "${restaurant.opening}";
						opening = opening.split(",");

						var dayOfTheWeek = ["<spring:message code="restaurant.msg.opening.monday"/></strong>", 
											"<spring:message code="restaurant.msg.opening.tuesday"/></strong>", 
											"<spring:message code="restaurant.msg.opening.wednesday"/></strong>", 
											"<spring:message code="restaurant.msg.opening.thursday"/></strong>", 
											"<spring:message code="restaurant.msg.opening.friday"/></strong>", 
											"<spring:message code="restaurant.msg.opening.saturday"/></strong>", 
											"<spring:message code="restaurant.msg.opening.sunday"/></strong>"];

						var tableOpening = document.getElementById("opening");

						for(var i=0; i<opening.length; i++) {

							var ligne = document.createElement("tr");

							var dayNode = document.createElement("th");
							dayNode.innerHTML = dayOfTheWeek[i];

							ligne.appendChild(dayNode);

							for(var j=0; j<3; j++) {
								var tableNode = document.createElement("td");

								if(opening[i].charAt(j) == "1") {
									tableNode.innerHTML = "O";
									tableNode.className="is-openned";
								} else {
									tableNode.innerHTML = "X";	
									tableNode.className="is-closed";
								}
								
								ligne.appendChild(tableNode);
							}					
							tableOpening.appendChild(ligne);
						}
					</script>
				</c:if>								
			</div>
			<%-- end map --%>
	</c:if>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>
