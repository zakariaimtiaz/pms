package com.pms

class SecUser {

	transient springSecurityService

	String fullName
	String username
	String password
	boolean enabled = true
	boolean accountExpired
	boolean accountLocked
	boolean passwordExpired
	long serviceId

	static transients = ['springSecurityService']

	static constraints = {
		username blank: false, unique: true
		password blank: false
		serviceId blank: true
	}

	static mapping = {
		password column: '`password`'
	}

	Set<SecRole> getAuthorities() {
		SecUserSecRole.findAllBySecUser(this).collect { it.secRole }
	}

	def beforeInsert() {
		encodePassword()
	}

	def beforeUpdate() {
		if (isDirty('password')) {
			encodePassword()
		}
	}

	protected void encodePassword() {
		password = springSecurityService?.passwordEncoder ? springSecurityService.encodePassword(password) : password
	}
}
