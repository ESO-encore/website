package com.eso_encore.website

import org.eclipse.xtend.lib.annotations.Data
import com.eso_encore.website.model.User

@Data
class SessionData {
	
	val User user
	val boolean isAdmin
	
	public static val unauthenticated = new SessionData(null, false)
	
}