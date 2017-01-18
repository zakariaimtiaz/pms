package com.pms

class PmMcrsLog {
    long id
    long version
    int year
    int month
    String monthStr
    long serviceId
    Date submissionDate
    boolean isSubmitted = false
    boolean isEditable = false


    static mapping = {
        submissionDate sqlType: 'date'
    }

    static constraints = {
        submissionDate nullable: true
    }
}
