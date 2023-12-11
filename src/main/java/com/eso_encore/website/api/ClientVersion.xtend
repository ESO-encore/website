package com.eso_encore.website.api

import com.eso_encore.website.Main
import java.io.File
import java.nio.file.Files
import java.nio.file.Paths
import spark.Spark

class ClientVersion {
	
	new() {
		val downloadFile = new File(Main.properties.clientDownloadLocation)
		
		Spark.get("/api/version") [req,res| Main.properties.version]
		Spark.get("/api/size") [req,res| downloadFile.length]
		Spark.get("/api/download") [req,res| 
			val path = Paths.get(Main.properties.clientDownloadLocation)
			Files.copy(path, res.raw.outputStream)
			return res.raw()
		]
		Spark.get("/api/patch") [req,res|
			val installedVersion = req.queryParams("installedVersion") 
			val path = Paths.get(Main.properties.patchDirectory, installedVersion+".7z")
			Files.copy(path, res.raw.outputStream)
			return res.raw()
		]
		Spark.get("/api/size-patch") [req,res|
			val installedVersion = req.queryParams("installedVersion") 
			val path = Paths.get(Main.properties.patchDirectory, installedVersion+".7z")
			Files.size(path)
		]
	}
	
}