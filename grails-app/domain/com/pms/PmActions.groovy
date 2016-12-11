package com.pms

class PmActions {

    long id
    long version
    long serviceId
    long goalId
    long resPersonId
    String actions
    String sequence
    int tmpSeq
    String resPerson
    String supportDepartment
    String sourceOfFund
    String remarks
    Date start
    Date end
    Double budget

    static mapping = {
        actions    sqlType: 'text'
        start       sqlType: 'date'
        end         sqlType: 'date'
    }

    static constraints = {
        actions     size: 2..15000
        resPersonId(nullable: true)
        resPerson(nullable: true)
        supportDepartment(nullable: true)
        sourceOfFund(nullable: true)
        remarks(nullable: true)
        budget(nullable: true)
    }
}
