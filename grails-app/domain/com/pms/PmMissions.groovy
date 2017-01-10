package com.pms

class PmMissions {

    long id
    long version
    long serviceId
    String goal
    int sequence
    Long spYearId

    static mapping = {
        goal     sqlType: 'text'
    }

    static constraints = {
        goal     size: 2..15000
        spYearId(nullable: true)
    }
}
