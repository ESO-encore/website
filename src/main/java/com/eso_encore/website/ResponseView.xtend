package com.eso_encore.website

import org.eclipse.xtend.lib.annotations.Data

@Data
class ResponseView<T> {
	
	val SessionData sessionData
	val String error
	val String info
	val T page
	
	static class Builder<T> {
		
		var SessionData session = SessionData.unauthenticated
		def setSession(SessionData session) {
			this.session = session
			return this
		}
		
		var String error = null
		def setError(String error) {
			this.error = error
			return this
		}
		
		var String info = null
		def setInfo(String info) {
			this.info = info
			return this
		}
		
		var T page
		def setPage(T page) {
			this.page = page
			return this
		}
		
		def build() {
			new ResponseView(session, error, info, page)
		}
		
	}
	
}