package com.eso_encore.website.page

import com.eso_encore.website.service.SessionService
import org.eclipse.xtend.lib.annotations.Data
import spark.Request

class Mail extends Page<Mail.PageData> {
	
	new(SessionService sessionService) {
		super(sessionService, "/mail", "mail.html")
		get()
	}
	
	override getData(Request req) {
		return new PageData()
	}
	
	@Data
	static class PageData {
	}
		
}