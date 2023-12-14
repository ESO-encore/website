package com.eso_encore.website.page

import com.eso_encore.website.service.SessionService
import org.eclipse.xtend.lib.annotations.Data
import spark.Request
import spark.Spark
import java.nio.file.Paths
import com.eso_encore.website.Main
import java.nio.file.Files

class Download extends Page<Download.PageData> {
	
	
	new(SessionService sessionService) {
		super(sessionService, "/download", "download.html")
		get()
		
		Spark.post(path) [ req, res |
			val path = Paths.get(Main.properties.launcherDownloadLocation)
			res.raw().setHeader("Content-Disposition","attachment; filename="+path.getFileName()+"");
			
			Files.copy(path, res.raw.outputStream)

			return res.raw()
		]
	}
	
	override getData(Request req) {
		return new PageData()
	}
	
	@Data
	static class PageData {
	}
		
}