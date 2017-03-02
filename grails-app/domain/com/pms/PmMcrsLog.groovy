package com.pms

class PmMcrsLog {
    long id
    long version
    int year
    int month
    String monthStr
    long serviceId
    Date submissionDate
    Date deadLine
    boolean isSubmitted = false
    boolean isEditable = false


    static mapping = {
        submissionDate sqlType: 'date'
        deadLine sqlType: 'date'
    }

    static constraints = {
        submissionDate nullable: true
        deadLine nullable: true
    }
}
