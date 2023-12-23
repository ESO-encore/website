package com.eso_encore.website.page

import com.eso_encore.website.Main
import com.eso_encore.website.ResponseView
import com.eso_encore.website.service.SessionService
import freemarker.template.Configuration
import java.io.File
import java.io.StringWriter
import org.eclipse.xtend.lib.annotations.Accessors
import spark.Request
import spark.Service

@Accessors
class Page<T> {
	
	static val Configuration cfg = buildFtlConfig
	
	val Service service
	val SessionService sessionService
	val String path
	val String template
	
	new(Service service, SessionService sessionService, String path, String template) {
		this.service = service
		this.sessionService = sessionService
		this.path = path
		this.template = template
	}
	
	def T getData(Request req) {
		return null
	}
	
	def get() {
		service.get(path) [req, res| 
			req.respond()
		]
	}
	
	def post() {
		service.post(path) [req, res| 
			req.respond()
		]
	}
	
	def respond(Request req) {
		respond(req, req.responseView.build())
	}
	
	def respond(Request req, ResponseView<T> response) {
		freemarker(response, template)
	}
	
	def responseView(Request req) {
		new ResponseView.Builder<T>()
				.setSession(sessionService.getSession(req))
				.setPage(getData(req))
	}
	
	def freemarker(ResponseView<T> view, String file) {
		val stringWriter = new StringWriter()
		cfg.getTemplate(file).process(view, stringWriter)
		stringWriter.toString
	}

	def static buildFtlConfig() {
		val cfg = new Configuration(Configuration.VERSION_2_3_32)
		cfg.directoryForTemplateLoading = new File(Main.properties.templateDirectory)
		return cfg
	}
	
}