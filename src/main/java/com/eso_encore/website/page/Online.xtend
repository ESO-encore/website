package com.eso_encore.website.page

import com.eso_encore.website.service.SessionService
import org.eclipse.xtend.lib.annotations.Data
import com.eso_encore.website.service.DatabaseService
import java.util.List
import com.eso_encore.website.model.User
import spark.Request
import com.eso_encore.website.service.OnlineHistoryService
import com.eso_encore.website.service.OnlineHistoryService.HistoryEntry
import spark.Service

class Online extends Page<Online.PageData> {

	val DatabaseService database
	val OnlineHistoryService onlineHistoryService

	new(Service service, SessionService sessionService, DatabaseService database, OnlineHistoryService onlineHistoryService) {
		super(service, sessionService, "/online", "online.html")
		this.database = database
		this.onlineHistoryService = onlineHistoryService
		get()
	}

	override getData(Request req) {
		return new PageData(
			database.onlinePlayers,
			onlineHistoryService.getHistory()
		)
	}

	@Data
	static class PageData {

		val List<User> onlinePlayers
		val List<HistoryEntry> onlinePlayerHistory

	}

}
