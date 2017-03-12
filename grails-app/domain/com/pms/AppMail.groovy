package com.pms

class AppMail {

    long id
    long version
    String subject
    String body
    String transactionCode
    boolean isManualSend
    String controllerName
    String actionName
    boolean isRequiredRoleIds
    String roleIds
    boolean isRequiredRecipients
    String recipients
    boolean isActive

    static mapping = {
        body    sqlType: 'text'
    }

    static constraints = {
        body     size: 2..15000
        controllerName(nullable: true)
        actionName(nullable: true)
        roleIds(nullable: true)
        recipients(nullable: true)
    }

}
