package com.pms

class MeetingLog {

    long id
    long version
    long meetingTypeId
    long serviceId
    String attendees
    String logStr
    String issues
    Date heldOn

    static mapping = {
        meetingTypeId index: 'meeting_type_id_idx'
        serviceId index: 'service_id_idx'
        heldOn sqlType: 'date'
        issues sqlType: 'text'
        logStr sqlType: 'text'
    }

    static constraints = {
    }
}
