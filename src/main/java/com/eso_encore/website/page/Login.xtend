package com.eso_encore.website.page

import com.eso_encore.website.service.SessionService
import org.eclipse.xtend.lib.annotations.Data
import spark.Service

class Login extends Page<Login.PageData> {
	
	new(Service service, SessionService sessionService) {
		super(service, sessionService, "/login", "login.html")
		get()
	}
	
	@Data
	static class PageData {
	}
		
}