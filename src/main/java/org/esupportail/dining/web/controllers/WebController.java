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

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;

import org.apache.commons.lang.StringEscapeUtils;
import org.esupportail.dining.domainservices.services.auth.Authenticator;
import org.esupportail.dining.web.dao.DatabaseConnector;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
public class WebController {

	@Autowired
	private Authenticator authenticator;
	@Autowired
	private DatabaseConnector dc;

	/*
	 * this method is used in user edit param and in the restaurant and meal
	 * view
	 */
	@RequestMapping(value = { "EDIT", "VIEW" }, params = { "action=removeFavorite" })
	public final void removeFavorite(
			final ActionRequest request,
			final ActionResponse response,
			@RequestParam(value = "restaurant-id", required = true) final String id)
			throws Exception {
		try {
			dc.executeUpdate("DELETE FROM FAVORITERESTAURANT "
					+ "WHERE RESTAURANTID='" + StringEscapeUtils.escapeSql(id) + "' AND USERNAME='"
					+ StringEscapeUtils.escapeSql(authenticator.getUser().getLogin()) + "'");
		} catch (NullPointerException e) { /*
											 * Useful is the user isn't logged
											 * in
											 */
		}
	}

}
