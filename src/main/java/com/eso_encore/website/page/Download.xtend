package com.eso_encore.website.page

import com.eso_encore.website.Main
import com.eso_encore.website.service.SessionService
import java.nio.file.Files
import java.nio.file.Paths
import org.eclipse.xtend.lib.annotations.Data
import spark.Request
import spark.Service

class Download extends Page<Download.PageData> {
	
	
	new(Service service, SessionService sessionService) {
		super(service, sessionService, "/download", "download.html")
		get()
		
		service.post(path) [ req, res |
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