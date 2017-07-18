package com.pms

class MeetingLog {

    long id
    long version
    long meetingTypeId
    long meetingCatId
    long serviceId
    String attendees
    String logStr
    String descStr
    String issues
    Date heldOn
    Date endDate
    String fileName

    static mapping = {
        meetingTypeId index: 'meeting_type_id_idx'
        meetingCatId  index: 'meeting_cat_id_idx'
        serviceId     index: 'service_id_idx'
        heldOn        sqlType: 'date'
        endDate        sqlType: 'date'
        descStr       sqlType: 'text'
        logStr        sqlType: 'text'
    }

    static constraints = {
        attendees(nullable: true)
        logStr(nullable: true)
        issues(nullable: true)
        endDate(nullable: true)
        fileName(nullable: true)
    }
}
