package com.eso_encore.website.page

import com.eso_encore.website.service.SessionService
import org.eclipse.xtend.lib.annotations.Data
import com.eso_encore.website.service.DatabaseService
import spark.Request

class Home extends Page<Home.PageData> {
	
	val DatabaseService database
	
	new(SessionService sessionService, DatabaseService database) {
		super(sessionService, "/", "index.html")
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