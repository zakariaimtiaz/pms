package com.pms

class PmSpLog {

    long id
    long version
    int year
    long serviceId
    long spTimeScheduleId
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
