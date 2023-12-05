package com.eso_encore.website.service

import com.eso_encore.website.model.User
import java.sql.Connection
import java.sql.DriverManager
import java.sql.Types
import java.util.ArrayList
import java.util.Optional

import static com.eso_encore.website.Main.properties

class DatabaseService {

	val Connection connection

	new() {
		connection = DriverManager.getConnection(
			'''jdbc:mariadb://«properties.database.host»:«properties.database.port»/«properties.database.database»''',
			properties.database.username,
			properties.database.password
		)
	}

	def isHealthy() {
		!connection.closed
	}

	def doesUserExist(String username) {
		try(val statement = connection.prepareStatement('''
			SELECT COUNT(*)
			FROM users
			WHERE name=?
		''')) {
			statement.setString(1, username)
			val rs = statement.executeQuery()
			rs.next()
			rs.getInt(1) == 1
		}
	}

	def register(String username, String hashedPassword, String email) {
		try(val statement = connection.prepareStatement('''
			call adduser(
				?, 
				UNHEX(?), 
				'0', 
				'0', 
				'0', 
				'0', 
				?, 
				'0', 
				'0', 
				'0', 
				'0', 
				'0', 
				'0', 
				'0', 
				'', 
				'', 
				UNHEX(?)
			)
		''')) {
			statement.setString(1, username)
			statement.setString(2, hashedPassword)
			statement.setString(3, email)
			statement.setString(4, hashedPassword)
			statement.executeUpdate()
		}
	}

	def doesCredentialsExist(String username, String hashedPassword) {
		try(val statement = connection.prepareCall('''
			{ call acquireuserpasswd(?, ?, ?) }
		''')) {
			statement.setString(1, username)
			statement.registerOutParameter(2, Types.INTEGER)
			statement.registerOutParameter(3, Types.VARCHAR)
			statement.execute()
			val passwd = statement.getString(3)
			if (passwd === null) {
				return false
			}
			return passwd.substring(2).equalsIgnoreCase(hashedPassword)
		}
	}

	def getOnlinePlayerCount() {
		try(val statement = connection.prepareStatement('''
			SELECT COUNT(*)
			FROM point
			WHERE zoneid IS NOT NULL
		''')) {
			val rs = statement.executeQuery()
			rs.next()
			rs.getInt(1)
		}
	}

	def getUser(String name) {
		try(val statement = connection.prepareStatement('''
			SELECT *
			FROM users
			WHERE users.name = ?
		''')) {
			statement.setString(1, name)
			val rs = statement.executeQuery()
			if (rs.next()) {
				Optional.of(new User(
					rs.getInt("ID"),
					rs.getString("name"),
					rs.getString("Prompt"),
					rs.getString("answer"),
					rs.getString("truename"),
					rs.getString("idnumber"),
					rs.getString("email"),
					rs.getString("mobilenumber"),
					rs.getString("province"),
					rs.getString("city"),
					rs.getString("phonenumber"),
					rs.getString("address"),
					rs.getString("postalcode"),
					rs.getInt("gender"),
					Optional.ofNullable(rs.getTimestamp("birthday")).map[toLocalDateTime()].orElse(null),
					Optional.ofNullable(rs.getTimestamp("creatime")).map[toLocalDateTime()].orElse(null),
					rs.getString("qq")
				))
			} else {
				Optional.empty
			}
		}
	}

	def getOnlinePlayers() {
		try(val statement = connection.prepareStatement('''
			SELECT *
			FROM users
			WHERE users.id IN (
				SELECT uid
				FROM point
				WHERE zoneid=1
			)
		''')) {
			val rs = statement.executeQuery()
			val users = new ArrayList()
			while (rs.next()) {
				users.add(
					new User(
						rs.getInt("ID"),
						rs.getString("name"),
						rs.getString("Prompt"),
						rs.getString("answer"),
						rs.getString("truename"),
						rs.getString("idnumber"),
						rs.getString("email"),
						rs.getString("mobilenumber"),
						rs.getString("province"),
						rs.getString("city"),
						rs.getString("phonenumber"),
						rs.getString("address"),
						rs.getString("postalcode"),
						rs.getInt("gender"),
						Optional.ofNullable(rs.getTimestamp("birthday")).map[toLocalDateTime()].orElse(null),
						Optional.ofNullable(rs.getTimestamp("creatime")).map[toLocalDateTime()].orElse(null),
						rs.getString("qq")
					)
				)
			}
			users
		}
	}

	def isUserAdmin(int userId) {
		try(val statement = connection.prepareStatement('''
			SELECT *
			FROM auth
			WHERE userid = ?
			LIMIT 1
		''')) {
			statement.setInt(1, userId)
			val rs = statement.executeQuery()
			return rs.next()
		}
	}

}
