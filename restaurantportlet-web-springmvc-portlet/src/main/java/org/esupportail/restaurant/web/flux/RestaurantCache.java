package org.esupportail.restaurant.web.flux;

import java.net.URL;

import net.sf.ehcache.Cache;
import net.sf.ehcache.CacheManager;
import net.sf.ehcache.Element;

import org.springframework.context.annotation.Scope;

public class RestaurantCache {
	
	private static RestaurantCache instance;
	private URL url;
	private Cache fluxCache;
	private CacheManager singletonManager;
	
	private RestaurantCache() {
		singletonManager = CacheManager.create();
		singletonManager.addCache("restaurantFlux");
		fluxCache = singletonManager.getCache("restaurantFlux");
		instance = this;
	}
	
	public static RestaurantCache getInstance() {
		if(instance == null)
			instance = new RestaurantCache();
		return instance;
	}
	
	public void init() {
		RestaurantFlux flux = new RestaurantFlux(this.url);	
		Element elFlux = new Element("restaurantFlux", flux);	
		this.fluxCache.put(elFlux);		
	}
	
	public void setUrl(URL url) {
		this.url = url;
	}
	
	public URL getUrl() {
		return this.url;
	}
	
	public RestaurantFlux getCachedElement() {
		return (RestaurantFlux) this.fluxCache.get("restaurantFlux").getObjectValue();
	}
	
	public void update() {
		
		System.out.println("In Business manager, I Call the business action.");
		
		if(this.url != null) {
			
			// Get cached JSON File
			Element elCache = fluxCache.get("restaurantFlux");
			RestaurantFlux fluxFromCache = (RestaurantFlux) elCache.getObjectValue();
			
			// Access the non-cached JSON File
			RestaurantFlux fluxFromUrl = new RestaurantFlux(this.url);	
			
			// If content is != we put the non-cached version to the cache.
			if(!fluxFromCache.equals(fluxFromUrl)) {
				Element newEl = new Element("restaurantFlux", fluxFromUrl);
				this.fluxCache.put(newEl);
			}
			
			System.out.println("Url != null");
		} else {
			System.out.println("Url == null, we don't proceed to cache update, because it doesn't exist yet");
		}
		
	}
}