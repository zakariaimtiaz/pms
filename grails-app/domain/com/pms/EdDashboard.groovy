package com.pms

class EdDashboard {
    long id
    long version
    long serviceId
    long issueId
    String description
    String remarks
    String edAdvice
    String resolveNote
    Date monthFor
    Date followupMonthFor
    Date statusChangeDate
    Boolean isFollowup
    Boolean isResolve
    Date createDate
    long createBy

    static mapping = {
        createDate    sqlType: 'date'
        monthFor      sqlType: 'date'
        followupMonthFor      sqlType: 'date'
        statusChangeDate      sqlType: 'date'
        description   sqlType: 'text'
        remarks       sqlType: 'text'
        edAdvice      sqlType: 'text'
    }

    static constraints = {
        description     size: 2..15000
        remarks     size: 2..15000
        edAdvice     size: 2..15000
        description nullable: true
        remarks(nullable: true)
        edAdvice(nullable: true)
        followupMonthFor(nullable: true)
        isFollowup(nullable: true)
        isResolve(nullable: true)
        statusChangeDate(nullable: true)
        resolveNote(nullable: true)
    }
}
