<%@ include file="/WEB-INF/jsp/header.jsp"%>

	<portlet:renderURL var="renderRefreshUrl" />

	<div class="row">
		<div class="map-container col-lg-6 col-md-6 col-sm-12 col-sm-12">
			<div id="map-canvas"></div>
		</div>
		
		<c:if test="${not empty favorites}">
		<div class="favorites col-lg-6 col-md-6 col-sm-12 col-sm-12">
	
			<table class="table table-striped table-responsive fav-dininghall-list">
				<thead>
					<tr>
						<th class="lead">
							<span class="glyphicon glyphicon-star starred-icon"></span>
							<spring:message code="view.favorite.title"/>
						</th>
                                               <th class="" width="80px">
                                                        <spring:message code="view.restaurant.status"/>
                                                </th>
						<th class="ta-right">
							<spring:message code="view.restaurant.detail"/>
						</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="favRestaurant" items="${favorites}">
						<portlet:renderURL var="viewMeals">
			  				<portlet:param name="action" value="viewMeals"/>
			  				<portlet:param name="id" value="${favRestaurant.id}"/>
						</portlet:renderURL>
						<portlet:renderURL var="viewRestaurant">
			  				<portlet:param name="action" value="viewRestaurant"/>
			  				<portlet:param name="id" value="${favRestaurant.id}"/>
						</portlet:renderURL>
						<tr>
							<td>
								<a href="${viewMeals}">
									${favRestaurant.title}
								</a>
							</td>
                                                       <td width="80px">
                                                                <c:if test="${favRestaurant.additionalProperties['isClosed']}">
                                                                        <c:set var = "editHours" value = "${fn:replace(favRestaurant.operationalhours, '<br/>', '&#13;')}" />

                                                                        <img src="<%= renderRequest.getContextPath() %>/images/bullet_closed.png" title="${editHours}"
                                                                        alt="Detail" />
                                                                </c:if>
                                                                <c:if test="${!favRestaurant.additionalProperties['isClosed']}">
                                                                        <img src="<%= renderRequest.getContextPath() %>/images/bullet_open.png" title="<spring:message code="view.restaurant.open"/>"
                                                                        alt="Detail" />
                                                                </c:if>
                                                        </td>
							<td class="ta-right">
								<a href="${viewRestaurant}">
									<img src="<%= renderRequest.getContextPath() %>/images/information.png"
										 alt="Detail" />
								</a>
							</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		</c:if>
		
		<c:forEach var="dininghalls" items="${restaurantLists}">
			<c:if test="${not empty dininghalls.value}">
				
				<div class="dininghalllist col-lg-6 col-md-6 col-sm-12 col-sm-12" data-zone="${dininghalls.key}">

					<table class="table table-striped table-responsive dininghall-list">
						<thead>
							<tr>
								<th class="lead">
									<spring:message code="view.list.title"/> ${dininghalls.key}
								</th>
                                                               <th class="" width="80px">
                                                                        <spring:message code="view.restaurant.status"/>
                                                                </th>
								<th class="ta-right">
									<spring:message code="view.restaurant.detail"/>
								</th>
							</tr>
						</thead>
						<tbody>
							<c:forEach var="dininghall" items="${dininghalls.value}">
								<portlet:renderURL var="viewMeals">
			  						<portlet:param name="action" value="viewMeals"/>
			  						<portlet:param name="id" value="${dininghall.id}"/>
								</portlet:renderURL>
								<portlet:renderURL var="viewRestaurant">
			  						<portlet:param name="action" value="viewRestaurant"/>
			  						<portlet:param name="id" value="${dininghall.id}"/>
								</portlet:renderURL>
								<tr>
									<td>
										<a href="${viewMeals}">
											${dininghall.title}
										</a>
									</td>							
                                                                       <td width="80px">
                                                                                <c:if test="${dininghall.additionalProperties['isClosed']}">
                                                                                        <c:set var = "editHours" value = "${fn:replace(dininghall.operationalhours, '<br/>', '&#13;')}" />

                                                                                        <img src="<%= renderRequest.getContextPath() %>/images/bullet_closed.png" title="${editHours}"
                                                                                        alt="Detail" />
                                                                                </c:if>
                                                                                <c:if test="${!dininghall.additionalProperties['isClosed']}">
                                                                                        <img src="<%= renderRequest.getContextPath() %>/images/bullet_open.png" title="<spring:message code="view.restaurant.open"/>"
                                                                                        alt="Detail" />
                                                                                </c:if>
                                                                        </td>
									<td class="ta-right">
										<a href="${viewRestaurant}">
											<img src="<%= renderRequest.getContextPath() %>/images/information.png"
												 alt="Detail" />
										</a>
									</td>
								</tr>
							</c:forEach>
						</tbody>
					</table>
					
				</div>
			
			</c:if>
		</c:forEach>
		
		<script type="text/javascript">
				
				var diningHalls = new Array();
				<c:forEach var="dininghalls" items="${restaurantLists}">
					<c:if test="${not empty dininghalls.value}">
						<c:forEach var="dininghall" items="${dininghalls.value}">

							<portlet:renderURL var="viewRestaurantFromMaker">
				  				<portlet:param name="action" value="viewRestaurant"/>
				  				<portlet:param name="id" value="${dininghall.id}"/>
							</portlet:renderURL>

							diningHalls.push(["${dininghall.title}", ${dininghall.lat}, ${dininghall.lon}, "${viewRestaurantFromMaker}", "${dininghalls.key}"]);

						</c:forEach>
					</c:if>
				</c:forEach>

				// Data access
				<c:forEach var="dininghall" items="${dininghalls}">
					<portlet:renderURL var="viewRestaurantFromMaker">
		  				<portlet:param name="action" value="viewRestaurant"/>
		  				<portlet:param name="id" value="${dininghall.id}"/>
					</portlet:renderURL>
					diningHalls.push(["${dininghall.title}", ${dininghall.lat}, ${dininghall.lon}, "${viewRestaurantFromMaker}"]);
				</c:forEach>

				var favoriteListLatLng = new Array();
				<c:forEach var="fav" items="${favorites}">
					favoriteListLatLng.push(new google.maps.LatLng(parseFloat(${fav.lat}, 10).toFixed(6), parseFloat(${fav.lon}, 10).toFixed(6)));
				</c:forEach>

				// Event Listener
				google.maps.event.addDomListener(window, 'load', initialize);
				
				var map;
				var diningHallsLatLng = new Array();
				var myLatlng = new google.maps.LatLng(parseFloat(diningHalls[0][1]).toFixed(6), parseFloat(diningHalls[0][2]).toFixed(6));
				
				var mapCenter = mapCenterCalculator(diningHalls);
				
				var mapOptions = 
				{
				     center: mapCenter,
				     mapTypeId: google.maps.MapTypeId.ROADMAP
			    };

			    var bounds = new google.maps.LatLngBounds ();
				
				function initialize() {

					sortByOpenning();
					
					// Map init

				    map = new google.maps.Map(document.getElementById("map-canvas"), mapOptions);
				   
				    // Markers init

				    for(var i=0; i<diningHalls.length; i++) {
				    	
				    	var diningHallPosition = new google.maps.LatLng(diningHalls[i][1],diningHalls[i][2]);				    	
				    	
				    	bounds.extend(diningHallPosition);

				    	// For the distance matrix
				    	diningHallsLatLng.push(diningHallPosition);

				    	var mark = new google.maps.Marker({
					        position: diningHallPosition,
					        map: map,
					        title:diningHalls[i][0],
					        icon: "<%= renderRequest.getContextPath() + "/images/pin_resto.png" %>"
					    });

				    	// Event Listeners

				    	google.maps.event.addListener(mark, 'click', function() {
				    		for(var j=0; j<diningHalls.length; j++) {
				    			if(diningHalls[j][0] == this.getTitle())
				    				location.href=diningHalls[j][3];
				    		}
				    	});
				    }

				    map.fitBounds(bounds);

				    // Geolocation feature

					if(navigator.geolocation) {
						
						$(".map-container").after("<p class='ta-center'><button class='btn btn-default get-located '><span class='glyphicon glyphicon-map-marker'></span> Se localiser</button></p>");

						// $("<button class='get-located'>Se localiser</button>").appendTo(;
						$(".get-located").click(function(e) {
							navigator.geolocation.getCurrentPosition(distanceCalculator, positionUndefined);
							e.preventDefault();
							$(this).fadeOut(500);
							$(this).unbind('click');
						});
					}

					// Event Listeners

					window.onresize = function() {
						map.fitBounds(bounds);
					}
				}
				
				
				/* @return : Approximation of the center of all points displayed on the map 
				   works well if coords are less than 500 miles distant 
				*/
				function mapCenterCalculator(coords) {
					   
					var lat=0, lng=0;
					
					for(var i=0; i<coords.length; ++i) {
					   lat += coords[i][1];
					   lng += coords[i][2];
					}					

					lat /= coords.length;
					lng /= coords.length;
					
					return new google.maps.LatLng(lat, lng);
				}				

				function distanceCalculator(position) {

					// If geolocation succeeded, we create a maker to the user position

					var origin = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);

					var mark = new google.maps.Marker({
				        position: origin,
				        map: map,
				        title:"<spring:message code="view.map.currentpos"/>",
				        zIndex : 99
				    });

					// We center the map at his place

					map.setCenter(origin);
					map.setZoom(14);

					// And calculate the distance from his place to all other dining hall in his area

					var service = new google.maps.DistanceMatrixService();

					service.getDistanceMatrix({
						origins : [origin],
						destinations : diningHallsLatLng,
						travelMode : google.maps.TravelMode.DRIVING,
						unitSystem : google.maps.UnitSystem.METRIC,
						durationInTraffic : true,
						avoidHighways : false,
						avoidTolls : false
					}, sortByDistance);

					service.getDistanceMatrix({
						origins : [origin],
						destinations : diningHallsLatLng,
						travelMode : google.maps.TravelMode.DRIVING,
						unitSystem : google.maps.UnitSystem.METRIC,
						durationInTraffic : true,
						avoidHighways : false,
						avoidTolls : false
					}, sortFavoriteByDistance);
				}

				// Callback from getDistanceMatrix
				function sortByDistance(response, status) {

					// store the results in a var
					var results = response.rows[0].elements;

					$(".dininghall-list").each(function(index) {

						var $list = $(this);
						// append distance attribute and text node
						$list.find('tbody tr').each(function(index) {
							$(this).find('td:first-child').append(" (" + results[index].distance.text+")");
							$(this).attr('data-distance', results[index].distance.value);
						});

						// Dinamically sort by distance attribute numerical value
						var listItems = $list.find('tbody tr').sort(function(a,b){ 
							return $(a).attr('data-distance') - $(b).attr('data-distance'); 
						});
						$list.find('li').remove();
						$list.append(listItems);

					});

				}

				function sortFavoriteByDistance(response, status) {
					// store the results in a var
					var results = response.rows[0].elements;

					$(".fav-dininghall-list").each(function(index) {

						var $list = $(this);
						// append distance attribute and text node
						$list.find('tbody tr').each(function(index) {
							$(this).find('td:first-child').append(" (" + results[index].distance.text+")");
							$(this).attr('data-distance', results[index].distance.value);
						});

						// Dinamically sort by distance attribute numerical value
						var listItems = $list.find('tbody tr').sort(function(a,b){ 
							return $(a).attr('data-distance') - $(b).attr('data-distance'); 
						});
						$list.find('li').remove();
						$list.append(listItems);

					});				
				}
				
				function sortByOpenning() {

					$(".dininghall-list").each(function(index) {

						var $list = $(this);

						var listItems = $list.find('tbody tr').sort(function(a,b){
							return ($(a).find('td').attr('data-closed') == undefined ? 0 : 1) - ($(b).find('td').attr('data-closed') == undefined ? 0 : 1);
						});

						$list.find('tbody tr').remove();
						$list.append(listItems);

					});				
				}

				function positionUndefined(err) {
					console.error(err);
				}
		</script>
	</div>

<%@ include file="/WEB-INF/jsp/footer.jsp"%>
