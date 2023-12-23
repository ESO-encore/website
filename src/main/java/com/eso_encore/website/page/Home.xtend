package com.eso_encore.website.page

import com.eso_encore.website.service.SessionService
import org.eclipse.xtend.lib.annotations.Data
import com.eso_encore.website.service.DatabaseService
import spark.Request
import spark.Service

class Home extends Page<Home.PageData> {
	
	val DatabaseService database
	
	new(Service service, SessionService sessionService, DatabaseService database) {
		super(service, sessionService, "/", "index.html")
		this.database = database
		get()
	}
	
	override getData(Request req) {
		return new PageData(database.onlinePlayerCount)
	}
	
	@Data
	static class PageData {
		
		val int onlinePlayerCount
		
	}
		
}