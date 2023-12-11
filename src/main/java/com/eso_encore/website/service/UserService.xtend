package com.eso_encore.website.service

import com.eso_encore.website.SessionData
import java.math.BigInteger
import java.security.MessageDigest
import java.util.regex.Pattern
import org.eclipse.xtend.lib.annotations.FinalFieldsConstructor

@FinalFieldsConstructor
class UserService {

	static val disallowedCharacters = Pattern.compile("[^0-9a-zA-Z_-]")
	static val emailPattern = Pattern.compile("[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}");

	val DatabaseService database
	
	def login(String username, String password) {
		val md = MessageDigest.getInstance("MD5")
		val digested = md.digest((username+password).bytes)
		
		if(database.doesCredentialsExist(username, digested.toHex())) {
			val user = database.getUser(username).orElseThrow[ new RuntimeException('''Could not find user «username»''') ]
			val isAdmin = database.isUserAdmin(user.ID)
			new SessionData(user, isAdmin)
		} else {
			throw new AuthenticationError("Invalid credentials")
		}
	}

	def register(String username, String password, String password2, String email) {
		registerInternal(
			username.toLowerCase().trim(),
			password.toLowerCase().trim(),
			password2.toLowerCase().trim(),
			email.toLowerCase().trim()
		)
	}

	def private registerInternal(String username, String password, String password2, String email) {
		if (username.isNullOrEmpty || password.isNullOrEmpty || password2.isNullOrEmpty || email.nullOrEmpty) {
			throw new AuthenticationError("Missing required fields")
		}

		if (!password.equals(password2)) {
			throw new AuthenticationError("Passwords don't match")
		}

		if (disallowedCharacters.matcher(username).find) {
			throw new AuthenticationError("Invalid characters in username")
		}
		if (disallowedCharacters.matcher(password).find) {
			throw new AuthenticationError("Invalid characters in password")
		}
		if (!emailPattern.matcher(email).matches) {
			throw new AuthenticationError("Invalid email")
		}

		if (username.length < 4) {
			throw new AuthenticationError("Username is too short, needs at least 4 characters")
		}
		if (password.length < 4) {
			throw new AuthenticationError("Password is too short, needs at least 4 characters")
		}
		if (email.length < 4) {
			throw new AuthenticationError("Email is too short, needs at least 4 characters")
		}

		if (username.length > 10) {
			throw new AuthenticationError("Username is too long, can't exceed 10 characters")
		}
		if (password.length > 10) {
			throw new AuthenticationError("Password is too long, can't exceed 10 characters")
		}
		if (email.length > 25) {
			throw new AuthenticationError("Email is too long, can't exceed 25 characters")
		}

		if (database.doesUserExist(username)) {
			throw new AuthenticationError("Username already taken")
		}

		val md = MessageDigest.getInstance("MD5")
		val digested = md.digest((username+password).bytes)
		database.register(
			username,
			digested.toHex(),
			email
		)

		return database.getUser(username).orElseThrow[ new RuntimeException('''Failed to register «username»''') ]
	}

	def static String toHex(byte[] bytes) {
		val bi = new BigInteger(1, bytes)
		return String.format("%0" + (bytes.length << 1) + "X", bi)
	}

	static class AuthenticationError extends Exception {

		new(String reason) {
			super(reason)
		}

	}

}
