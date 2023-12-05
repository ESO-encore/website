package com.eso_encore.website.service

import com.google.gson.Gson
import com.google.gson.reflect.TypeToken
import java.io.File
import java.nio.file.Files
import java.util.ArrayList
import java.util.Calendar
import java.util.Date
import java.util.List
import java.util.concurrent.Executors
import java.util.concurrent.TimeUnit
import java.util.concurrent.atomic.AtomicReference
import java.util.stream.Collectors
import org.apache.log4j.LogManager
import org.eclipse.xtend.lib.annotations.Data
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor

class OnlineHistoryService {

	static val historyFile = new File("onlinePlayerCount")
	static val logger = LogManager.getLogger(OnlineHistoryService)
	val DatabaseService database
	val Gson gson
	val AtomicReference<List<HistoryEntry>> history

	new(DatabaseService database) {
		this.database = database

		historyFile.createNewFile
		gson = new Gson()
		history = new AtomicReference(readFromFile())

		val calendar = Calendar.getInstance()
		val scheduler = Executors.newSingleThreadScheduledExecutor();
		scheduler.scheduleAtFixedRate(
			new UpdatePlayerHistory(this, 24*7), 
			millisToNextHour(calendar),
			60 * 60 * 1000,
			TimeUnit.MILLISECONDS
		)
	}
	
	def getHistory() {
		return history.get()
	}

	def readFromFile() {
		val content = Files.lines(historyFile.toPath).collect(Collectors.toList).join()
		if (content.isNullOrEmpty) {
			return emptyList
		}
		return gson.fromJson(
			content,
			new TypeToken<List<HistoryEntry>>() {
			}.getType()
		)
	}

	def writeToFile() {
		Files.write(historyFile.toPath, gson.toJson(history.get()).bytes)
	}

	def static long millisToNextHour(Calendar calendar) {
		val minutes = calendar.get(Calendar.MINUTE)
		val seconds = calendar.get(Calendar.SECOND)
		val millis = calendar.get(Calendar.MILLISECOND)
		val minutesToNextHour = 60 - minutes
		val secondsToNextHour = 60 - seconds
		val millisToNextHour = 1000 - millis
		return minutesToNextHour * 60 * 1000 + secondsToNextHour * 1000 + millisToNextHour
	}

	@FinalFieldsConstructor
	static class UpdatePlayerHistory implements Runnable {

		val OnlineHistoryService onlineHistory
		val int maxSize

		override run() {
			logger.info("updating online history")
			try {
			val count = onlineHistory.database.onlinePlayerCount
			val history = new ArrayList(onlineHistory.history.get())
			history.add(new HistoryEntry(new Date(), count))
			if (history.size() > maxSize) {
				val oldest = history.minBy[timestamp]
				history.remove(oldest)
			}
			onlineHistory.history.set(history)
			onlineHistory.writeToFile
			} catch(Exception e) {
				e.printStackTrace
			}
			logger.info("updated online history")
		}

	}

	@Data
	static class HistoryEntry {
		val Date timestamp
		val int count
	}

}
