package com.eso_encore.website

import com.eso_encore.website.api.ClientVersion
import com.eso_encore.website.page.Download
import com.eso_encore.website.page.Home
import com.eso_encore.website.page.Login
import com.eso_encore.website.page.Mail
import com.eso_encore.website.page.MailPost
import com.eso_encore.website.page.Online
import com.eso_encore.website.service.DatabaseService
import com.eso_encore.website.service.OnlineHistoryService
import com.eso_encore.website.service.SessionService
import com.eso_encore.website.service.UserService
import com.eso_encore.website.service.UserService.AuthenticationError
import com.google.gson.Gson
import freemarker.template.Configuration
import java.io.File
import java.io.StringWriter
import java.nio.file.Files
import java.nio.file.Paths
import java.util.Map
import org.apache.log4j.LogManager
import spark.Request

import static spark.Spark.*

class Main {

	static val gson = new Gson()
	public static val properties = gson.fromJson(
		Files.readAllLines(Paths.get(System.getProperty("properties", "local.properties.json"))).join(),
		Properties
	)
	static val cfg = buildFtlConfig(properties)
	static val sessionService = new SessionService()
	static val databaseService = new DatabaseService()
	static val userService = new UserService(databaseService)
	static val onlineHistoryService = new OnlineHistoryService(databaseService)

	static val logger = LogManager.getLogger(Main)

	def static void main(String[] args) {
		logger.info(properties)
		port(properties.port)
		staticFiles.location(properties.publicDirectory)

		// Pages
		val home = new Home(sessionService, databaseService)
		val login = new Login(sessionService)
		new Online(sessionService, databaseService, onlineHistoryService)
		new Download(sessionService)
		new Mail(sessionService)
		new MailPost(sessionService, databaseService)

		get("/register", [req, res|req.freemarker("register.html")])

		get("/logout", [ req, res |
			sessionService.clearSession(req)
			home.respond(req, home.responseView(req).setInfo('''Successfully logged out''').build())
		])
		post("/login", [ req, res |
			val username = req.queryParams("username")
			val password = req.queryParams("password")
			try {
				val sessionData = userService.login(username, password)
				sessionService.putSession(req, sessionData)
				home.respond(req, home.responseView(req).setInfo('''Welcome back, «username»!''').build())
			} catch (AuthenticationError err) {
				login.respond(req, login.responseView(req).setError(err.message).build())
			}
		])
		post("/register", [ req, res |
			try {
				val user = userService.register(
					req.queryParams("username"),
					req.queryParams("password"),
					req.queryParams("password2"),
					req.queryParams("email")
				)
				val sessionData = new SessionData(user, false)
				sessionService.putSession(req, sessionData)
				home.respond(req, home.responseView(req).setInfo("Successfully registered").build())
			} catch (AuthenticationError err) {
				new ResponseView.Builder().setError(err.message).build().freemarker("register.html")
			}
		])
		
		//api
		new ClientVersion()
		
		//client
		get("/client/welcome") [req,res|
			Files.readAllLines(Paths.get(properties.templateDirectory, "ingameWelcome.html")).join()
		]

		exception(Exception, [ err, req, res |
			err.printStackTrace()
		])

		logger.info("Running")
	}

	def static freemarker(Request req, String file) {
		new ResponseView.Builder().setSession(sessionService.getSession(req)).build().freemarker(file)
	}

	def static freemarker(ResponseView view, String file) {
		val stringWriter = new StringWriter()
		cfg.getTemplate(file).process(view, stringWriter)
		stringWriter.toString
	}

	def static getSession(Map<String, SessionData> sessions, Request req) {
		sessions.getOrDefault(req.session.id, SessionData.unauthenticated)
	}

	def static buildFtlConfig(Properties properties) {
		val cfg = new Configuration(Configuration.VERSION_2_3_32)
		cfg.directoryForTemplateLoading = new File(properties.templateDirectory)
		return cfg
	}

}
