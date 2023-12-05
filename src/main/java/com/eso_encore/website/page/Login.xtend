package com.eso_encore.website.page

import com.eso_encore.website.service.SessionService
import org.eclipse.xtend.lib.annotations.Data

class Login extends Page<Login.PageData> {
	
	new(SessionService sessionService) {
		super(sessionService, "/login", "login.html")
		get()
	}
	
	@Data
	static class PageData {
	}
		
}