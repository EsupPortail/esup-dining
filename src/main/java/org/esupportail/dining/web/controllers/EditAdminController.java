/**
 * Licensed to ESUP-Portail under one or more contributor license
 * agreements. See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.
 *
 * ESUP-Portail licenses this file to you under the Apache License,
 * Version 2.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at:
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.esupportail.dining.web.controllers;

import java.net.URL;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.portlet.RenderRequest;
import javax.portlet.RenderResponse;

import org.esupportail.dining.domain.beans.User;
import org.esupportail.dining.domainservices.services.auth.Authenticator;
import org.esupportail.dining.web.dao.DatabaseConnector;
import org.esupportail.dining.web.feed.DiningFeed;
import org.esupportail.dining.web.feed.FeedInformation;
import org.esupportail.dining.web.models.Restaurant;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.portlet.ModelAndView;

@Controller
@RequestMapping("EDIT")
public class EditAdminController extends AbstractExceptionController {

	@Autowired
	private Authenticator authenticator;
	@Autowired
	private DatabaseConnector dc;
	@Autowired
	private DiningFeed feed;

	@RequestMapping(params = { "action=adminSettings" })
	public ModelAndView renderEditAdminView(RenderRequest request,
			RenderResponse response) throws Exception {

		ModelMap model = new ModelMap();

		User user = this.authenticator.getUser();
		model.put("user", user);

		// try {

		/* Get all area in the current feed */

		try {
			Set<String> areaList = new HashSet<String>();
			for (Restaurant r : this.feed.getFeed().getRestaurants()) {
				areaList.add(r.getArea());
			}
			model.put("areaList", areaList);
		} catch (Exception e) {
			// Here we go if the URL isn't set.
		}

		String urlflux = null;
		String[] areanames = null;
		List<FeedInformation> feedInfoList = new ArrayList<FeedInformation>();
		ResultSet results = null;
		try {
			results = this.dc.executeQuery("SELECT * FROM PATHFLUX");
			
			while(results.next()) {
				FeedInformation feedInfo = new FeedInformation(
					results.getInt("id"),
					results.getString("name"),
					results.getString("areaname"),
					results.getString("urlflux"),
					results.getBoolean("is_default"));
				feedInfoList.add(feedInfo);
			}
			
		} catch (SQLException e) {
			// URL isn't set yet...
		}

		try {
			for(FeedInformation fi : feedInfoList) {
				if(fi.isDefault()) {
					areanames = fi.getAreaname().split(",");
				}
			}
		} catch (Exception e) {
			// URL may be set be default area is not
		}
		model.put("feedList", feedInfoList);
		model.put("defaultArea", areanames);
		
		/* Action urlFeed set urlError if form URL was not well-formed */
		String hasError = request.getParameter("urlError");
		if (hasError != null) {
			model.put("urlError", hasError);
		}

		/* Action setDefaultArea set urlError if form URL was not well-formed */
		String areaSubmit = request.getParameter("areaSubmit");
		if (areaSubmit != null) {
			model.put("areaSubmit", areaSubmit);
		}

		/* From ForceFeedUpdate */
		if (request.getParameter("update") != null) {
			Boolean isUpdated = new Boolean(request.getParameter("update"));
			if (isUpdated.booleanValue()) {
				model.put("updateFeed", "The feed has been correctly updated");
			} else {
				model.put("updateFeed", "The feed is already up to date");
			}
		}
		return new ModelAndView("editadmin", model);
	}

	@RequestMapping(params = { "action=adminStats" })
	public ModelAndView renderStatsAdminView(RenderRequest request,
			RenderResponse response) throws Exception {

		ModelMap model = new ModelMap();

		/* Favorite Restaurants stats */

		ResultSet results = this.dc
				.executeQuery("SELECT RESTAURANTID FROM FAVORITERESTAURANT");

		HashMap<Integer, Integer> nbRestaurant = new HashMap<Integer, Integer>();

		while (results.next()) {
			int currentValue = nbRestaurant
					.get(results.getInt("RESTAURANTID")) == null ? 0
							: nbRestaurant.get(results.getInt("RESTAURANTID"));
			if (currentValue == 0) {
				nbRestaurant.put(results.getInt("RESTAURANTID"), 1);
			} else {
				nbRestaurant
				.put(results.getInt("RESTAURANTID"), ++currentValue);
			}
		}

		HashMap<Integer, String> restaurantsName = new HashMap<Integer, String>();
		for (Restaurant r : this.feed.getFeed().getRestaurants()) {
			restaurantsName.put(r.getId(), r.getTitle());
		}

		/* Nutrition preferences stats */

		ResultSet resultsNutrit = this.dc
				.executeQuery("SELECT NUTRITIONCODE, COUNT(*) FROM NUTRITIONPREFERENCES GROUP BY NUTRITIONCODE");
		Map<Integer, Integer> prefCodeList = new HashMap<Integer, Integer>();

		while (resultsNutrit.next()) {
			prefCodeList.put(resultsNutrit.getInt(1), resultsNutrit.getInt(2));
		}

		model.put("prefCodeList", prefCodeList);
		model.put("stats", nbRestaurant);
		model.put("restaurantsName", restaurantsName);

		return new ModelAndView("stats", model);
	}

	@RequestMapping(params = { "action=urlFeed" })
	public void setURLFeed(ActionRequest request, ActionResponse response,
			@RequestParam(value = "feedId", required = true) int feedId)
					throws Exception {
		
		response.setRenderParameter("action", "adminSettings");
		
		try {
			this.dc.executeUpdate("UPDATE PATHFLUX SET is_default=false WHERE is_default=true");
			
			ResultSet result = this.dc.executeQuery("SELECT * FROM PATHFLUX WHERE ID=" + feedId);
			result.next();
			result.updateBoolean("is_default", true);
			result.updateRow();
			URL urlFeed = new URL(result.getString("URLFLUX"));
			response.setRenderParameter("urlError", "false");
			
			// We just avoid problem this way
			// Favorite are feed related
			// If admin update default feed then fav are not relevant anymore.
			this.dc.execute("DELETE FROM USERAREA");
			this.dc.execute("DELETE FROM FAVORITERESTAURANT");
			
			this.feed.setPath(urlFeed);
			
		} catch (Exception e) {
			e.printStackTrace();
			response.setRenderParameter("urlError", "true");
		}
	}

	@RequestMapping(params = { "action=setDefaultArea" })
	public void setDefaultArea(
			ActionRequest request,
			ActionResponse response,
			@RequestParam(value = "chkArea[]", required = false) String[] listAreas,
			@RequestParam(value = "feedId", required = true) int feedId)
					throws Exception {
		String areanames = "";
		if (listAreas != null) {
			for (int i = 0; i < listAreas.length; i++) {
				areanames += listAreas[i]
						+ (i < listAreas.length - 1 ? "," : "");
			}
		}

		response.setRenderParameter("action", "adminSettings");
		response.setRenderParameter("areaSubmit", "true");

		ResultSet results = this.dc.executeQuery("SELECT * FROM PATHFLUX WHERE ID=" + feedId);
		results.next();
		results.updateString("AREANAME", areanames);
		results.updateRow();
	}

	@RequestMapping(params = { "action=forceFeedUpdate" })
	public void feedUpdate(ActionRequest request, ActionResponse response)
			throws Exception {

		Boolean isUpdated = this.feed.update();

		response.setRenderParameter("action", "adminSettings");
		response.setRenderParameter("update", isUpdated.toString());
	}
}
