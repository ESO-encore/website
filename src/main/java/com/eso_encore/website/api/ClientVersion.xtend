package com.eso_encore.website.api

import spark.Spark
import com.twmacinta.util.MD5
import java.io.File
import com.eso_encore.website.Main
import java.nio.file.Paths
import java.nio.file.Files

class ClientVersion {
	
	new() {
		val downloadFile = new File(Main.properties.clientDownloadLocation)
		println("calcuting checksum")
		val checksum = MD5.asHex(MD5.getHash(downloadFile))
		println("checksum: "+checksum)
		
		Spark.get("/api/version") [req,res| "0.0.1"]
		Spark.get("/api/checksum") [req,res| checksum]
		Spark.get("/api/size") [req,res| downloadFile.length]
		Spark.get("/api/download") [req,res| 
			val path = Paths.get(Main.properties.clientDownloadLocation)
			Files.copy(path, res.raw.outputStream)
			return res.raw()
		]
	}
	
}