package com.pms

class PmSpSummary {

    long id
    long version
    long serviceId
    String summary
    Integer year
    Date createdOn
    Date lastUpdateOn

    static mapping = {
        summary sqlType: 'text'
    }
    static constraints = {
        year nullable: true
        lastUpdateOn nullable: true
    }
}
