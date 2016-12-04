package com.pms

class PmActions {

    long id
    long version
    long serviceId
    long goalId
    String actions
    String sequence
    int tmpSeq
    String meaIndicator
    String target
    String resPerson
    String strategyMapRef
    String supportDepartment
    String sourceOfFund
    String remarks
    Date start
    Date end
    int weight

    static mapping = {
        actions    sqlType: 'text'
        start       sqlType: 'date'
        end         sqlType: 'date'
    }

    static constraints = {
        actions     size: 2..15000
        meaIndicator(nullable: true)
        target(nullable: true)
        resPerson(nullable: true)
        strategyMapRef(nullable: true)
        supportDepartment(nullable: true)
        sourceOfFund(nullable: true)
        remarks(nullable: true)
    }
}
