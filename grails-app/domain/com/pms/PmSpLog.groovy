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
    String editTypeIds
    String editableActionIds

    static mapping = {
        submissionDate sqlType: 'date'
    }

    static constraints = {
        editTypeIds nullable: true
        editableActionIds nullable: true
        submissionDate nullable: true
    }
}
