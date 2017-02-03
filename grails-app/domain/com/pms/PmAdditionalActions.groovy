package com.pms

class PmAdditionalActions {

    long id
    long version
    long serviceId
    long goalId
    long resPersonId
    String actions
    String sequence
    int tmpSeq
    int totalIndicator
    String resPerson
    String strategyMapRef
    String supportDepartment
    String sourceOfFund
    String note
    String indicator
    Date start
    Date end

    static mapping = {
        actions    sqlType: 'text'
        note       sqlType: 'text'
        indicator  sqlType: 'text'
        start      sqlType: 'date'
        end        sqlType: 'date'
    }

    static constraints = {
        actions     size: 2..15000
        note        size: 2..15000
        indicator   size: 2..15000
        resPersonId(nullable: true)
        resPerson(nullable: true)
        strategyMapRef(nullable: true)
        supportDepartment(nullable: true)
        sourceOfFund(nullable: true)
        note(nullable: true)
        indicator(nullable: true)
    }
}
