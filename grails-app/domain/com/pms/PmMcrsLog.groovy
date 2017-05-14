package com.pms

class PmMcrsLog {
    long id
    long version
    int year
    int month
    String monthStr
    long serviceId
    Date submissionDate
    Date submissionDateDb
    Date deadLine
    boolean isSubmitted = false
    boolean isSubmittedDb = false
    boolean isEditable = false
    boolean isEditableDb = false


    static mapping = {
        submissionDate sqlType: 'date'
        submissionDateDb sqlType: 'date'
        deadLine sqlType: 'date'
    }

    static constraints = {
        submissionDate nullable: true
        submissionDateDb nullable: true
        deadLine nullable: true
    }
}
