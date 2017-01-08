package com.pms

class PmSpLog {

    long id
    long version
    int year
    long serviceId
    long spTimeScheduleId
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
