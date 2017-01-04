package com.pms

class PmActionsIndicatorDetails {
    long id
    long version
    long actionsId
    Long indicatorId
    String monthName
    String remarks
    int target
    Integer achievement
    Date createDate
    long createBy

    static mapping = {
        remarks        size: 2..15000
        remarks    sqlType: 'text'
    }
    static constraints = {
        remarks nullable: true
        achievement nullable: true
    }
}
