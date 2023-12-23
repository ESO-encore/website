package com.eso_encore.website.api

import com.eso_encore.website.Main
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths
import spark.Service

class ClientVersion {
	
	new(Service it) {
		val downloadFile = new File(Main.properties.clientDownloadLocation)
		
		get("/api/version") [req,res| Main.properties.version]
		get("/api/size") [req,res| downloadFile.length]
		get("/api/download") [req,res| 
			val path = Paths.get(Main.properties.clientDownloadLocation)
			Files.copy(path, res.raw.outputStream)
			return res.raw()
		]
		get("/api/patch") [req,res|
			val installedVersion = req.queryParams("installedVersion") 
			val path = Paths.get(Main.properties.patchDirectory, installedVersion+".7z")
			Files.copy(path, res.raw.outputStream)
			return res.raw()
		]
		get("/api/size-patch") [req,res|
			val installedVersion = req.queryParams("installedVersion") 
			val path = Paths.get(Main.properties.patchDirectory, installedVersion+".7z")
			Files.size(path)
		]
	}
	
}