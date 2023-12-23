package com.eso_encore.website.page

import com.eso_encore.website.service.SessionService
import org.eclipse.xtend.lib.annotations.Data
import spark.Request
import spark.Service

class MailPost extends Page<MailPost.PageData> {
	
	new(Service service, SessionService sessionService) {
		super(service, sessionService, "/mail", "mail.html")
		post()
	}
	
	override getData(Request req) {
		return new PageData()
	}
	
	@Data
	static class PageData {
	}
		
}