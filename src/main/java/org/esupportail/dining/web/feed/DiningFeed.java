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
package org.esupportail.dining.web.feed;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.sql.ResultSet;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import javax.annotation.PostConstruct;

import org.apache.commons.lang.StringEscapeUtils;
import org.codehaus.jackson.JsonParseException;
import org.codehaus.jackson.map.JsonMappingException;
import org.codehaus.jackson.map.ObjectMapper;
import org.esupportail.dining.web.dao.DatabaseConnector;
import org.esupportail.dining.web.models.Restaurant;
import org.esupportail.dining.web.models.RestaurantFeedRoot;
import org.springframework.web.client.RestTemplate;

public class DiningFeed implements Serializable {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1367711775088961505L;
	DiningCache cache;
	private DatabaseConnector dc;
	private String jsonStringified;
	private RestaurantFeedRoot feed;
	private ObjectMapper mapper;
	private URL path;
	private RestTemplate restTemplate;
	private String feedListUrl;

	@PostConstruct
	public void init() {
		this.cache = new DiningCache(this);
		this.jsonStringified = new String();
		this.mapper = new ObjectMapper();

		try {
			ResultSet results = this.dc.executeQuery("SELECT URLFLUX FROM PATHFLUX WHERE IS_DEFAULT=true");
			results.next();
			URL urlfeed = null;
			try {
				urlfeed = new URL(results.getString("URLFLUX"));
			} catch (MalformedURLException e) {
				// Nothing to do because normally, we check the URL validity
				// before the inserting this row.
			}
			this.setPath(urlfeed);
		} catch (Exception e) { /* */

			// The database isn't populated
			// Grab the content from the server.

			FeedResponse response = this.restTemplate.getForObject(this.feedListUrl, FeedResponse.class);
			
			try {
				List<FeedInformation> feedList = response.getFeedInformationList();
				
				for(FeedInformation fi : feedList) {
					
					this.dc.executeUpdate("INSERT INTO PATHFLUX(ID, NAME, URLFLUX, IS_DEFAULT)"
					+ "VALUES(" + fi.getId() + ", '" + StringEscapeUtils.escapeSql(fi.getName()) + "', '" + StringEscapeUtils.escapeSql(fi.getPath()) + "', " + fi.isDefault() + ")");
					
					if(fi.isDefault() == true) {
						URL urlFeed = new URL(fi.getPath());
						this.setPath(urlFeed);
					}
				}
			} catch (Exception e2) {
				e2.printStackTrace();
			}
				
		}
	}

	private RestaurantFeedRoot mapJson() throws JsonParseException,
	JsonMappingException, IOException {
		return this.mapper.readValue(this.jsonStringified, RestaurantFeedRoot.class);
	}

	public URL getPath() {
		return this.path;
	}

	public void setPath(URL path) throws JsonParseException,
	JsonMappingException, IOException {
		this.path = path;
		// If the user sets a new path, we have to update json string and re-map
		// the all json file.
		this.updateJson();
	}

	public String getJsonStringified() {
		return this.jsonStringified;
	}

	public void updateJson() throws JsonParseException, JsonMappingException,
	IOException {
		URLConnection yc = null;
		try {
			yc = this.path.openConnection();
		} catch (IOException e) {
			e.printStackTrace();
		}
		BufferedReader br = null;
		try {
			br = new BufferedReader(new InputStreamReader(yc.getInputStream(),
					"UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		// get a stringified version of the feed to help equality comparison
		this.jsonStringified = this.getJsonContent(br);

		try {
			br.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		// Init feed by mapping JSON to POJO
		this.feed = this.mapJson();
	}

	private String getJsonContent(BufferedReader in) {
		String jsonText = new String();
		while (true) {
			String str = null;
			try {
				str = in.readLine();
				if (str == null) {
					break;
				}
				jsonText += str;
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		return jsonText;
	}

	public RestaurantFeedRoot getFeed() {
		return this.feed;
	}

	public void setFeed(RestaurantFeedRoot feed) {
		this.feed = feed;
	}

	public boolean update() {

		if (this.path == null) {
			return false;
		}

		URLConnection yc = null;
		try {
			yc = this.path.openConnection();
		} catch (IOException e) {
			e.printStackTrace();
		}
		BufferedReader br = null;
		try {
			br = new BufferedReader(new InputStreamReader(yc.getInputStream(),
					"UTF-8"));
		} catch (UnsupportedEncodingException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}

		String tempJson = this.getJsonContent(br);

		try {
			br.close();
		} catch (IOException e) {
			e.printStackTrace();
		}

		if (!this.jsonStringified.equals(tempJson)) {
			this.jsonStringified = tempJson;
			try {
				this.feed = this.mapJson();
				this.cache.cacheReset(DiningCache.DINING_CACHE_NAME);
				this.cache.cacheDining();
			} catch (JsonParseException e) {
				e.printStackTrace();
			} catch (JsonMappingException e) {
				e.printStackTrace();
			} catch (IOException e) {
				e.printStackTrace();
			}

			return true;
		} else {
			return false;
		}
	}

        public boolean isClosed(Restaurant r) {
                if (!"0".equals(r.getClosing()))
                {
                        return true;
                } else {
                        return false;
                }
        }

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result
				+ (this.jsonStringified == null ? 0 : this.jsonStringified.hashCode());
		result = prime * result + (this.path == null ? 0 : this.path.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (obj == null) {
			return false;
		}
		if (getClass() != obj.getClass()) {
			return false;
		}
		DiningFeed other = (DiningFeed) obj;
		if (this.jsonStringified == null) {
			if (other.jsonStringified != null) {
				return false;
			}
		} else if (!this.jsonStringified.equals(other.jsonStringified)) {
			return false;
		}
		if (this.path == null) {
			if (other.path != null) {
				return false;
			}
		} else if (!this.path.equals(other.path)) {
			return false;
		}
		return true;
	}

	@Override
	public String toString() {
		return this.jsonStringified;
	}

	public void setDc(DatabaseConnector dc) {
		this.dc = dc;
	}

	public DatabaseConnector getDc() {
		return this.dc;
	}

	public void setFeedListUrl(String feedListUrl) {
		this.feedListUrl = feedListUrl;
	}
	
	public void setRestTemplate(RestTemplate restTemplate) {
		this.restTemplate = restTemplate;
	}
	
	/* automated task */

	public void run() {
		this.update();
	}

}
