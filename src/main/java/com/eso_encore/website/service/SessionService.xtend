package com.eso_encore.website.service

import java.util.Map
import com.eso_encore.website.SessionData
import java.util.HashMap
import spark.Request

class SessionService {
	
	val Map<String, SessionData> sessions = new HashMap()
	
	def getSession(Request req) {
		sessions.getOrDefault(req.session.id, SessionData.unauthenticated)
	}
	
	def putSession(Request req, SessionData session) {
		sessions.put(req.session(true).id, session)
	}
	
	def clearSession(Request req) {
		sessions.remove(req.session.id)
	}
	
}