package com.eso_encore.website.api

import com.eso_encore.website.Main
import java.io.File
import java.nio.file.Files
import spark.Service

class LauncherVersion {
	
	new(Service it) {
		val downloadFile = new File(Main.properties.launcherDownloadLocation)
		
		get("/api/launcher/version") [req,res| Main.properties.launcherVersion]
		get("/api/launcher/size") [req,res| downloadFile.length]
		get("/api/launcher/download") [req,res| 
			val path = downloadFile.toPath()
			Files.copy(path, res.raw.outputStream)
			return res.raw()
		]
	}
	
}