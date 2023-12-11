package com.eso_encore.website

import org.eclipse.xtend.lib.annotations.Data

@Data
class Properties {

	val int port
	val String templateDirectory
	val String publicDirectory
	val String clientDownloadLocation
	val String patchDirectory
	val String version
	val Database database
	
}

@Data
class Database {
	
	val int port
	val String host
	val String database
	val String username
	val String password
	
}