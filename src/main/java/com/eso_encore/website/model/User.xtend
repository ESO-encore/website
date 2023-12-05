package com.eso_encore.website.model

import org.eclipse.xtend.lib.annotations.Data
import java.time.LocalDateTime

@Data
class User {
	val int ID
	val String name
	val String prompt
	val String answer
	val String truename
	val String idnumber
	val String email
	val String mobilenumber
	val String province
	val String city
	val String phonenumber
	val String address
	val String postalcode
	val int gender
	val LocalDateTime birthday
	val LocalDateTime creatime
	val String qq
}