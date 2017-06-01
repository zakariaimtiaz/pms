package com.pms

class PmSpLogDetails {

    long id
    long version
    long logId
    Date editableOn
    Date submittedOn
    Boolean isCurrent

    static mapping = {
        editableOn sqlType: 'date'
        submittedOn sqlType: 'date'
    }

    static constraints = {
        editableOn nullable: true
        submittedOn nullable: true
        isCurrent nullable: true
    }
}
