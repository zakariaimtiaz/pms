package com.pms

class PmMcrsLogDetails {

    long id
    long version
    long logId
    long logTypeId
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
