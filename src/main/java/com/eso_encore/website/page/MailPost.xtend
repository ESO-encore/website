package com.eso_encore.website.page

import com.eso_encore.website.service.DatabaseService
import com.eso_encore.website.service.SessionService
import org.eclipse.xtend.lib.annotations.Data
import spark.Request

class MailPost extends Page<MailPost.PageData> {
	
	val DatabaseService database
	
	new(SessionService sessionService, DatabaseService database) {
		super(sessionService, "/mail", "mail.html")
		this.database = database
		post()
	}
	
	override getData(Request req) {
		return new PageData()
	}
	
	@Data
	static class PageData {
	}
		
}