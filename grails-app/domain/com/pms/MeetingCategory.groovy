package com.pms

class MeetingCategory {

    long id
    long version
    long meetingTypeId
    long serviceCatId
    String name

    static mapping = {
        meetingTypeId index: 'meeting_type_id_idx'
    }

    static constraints = {
    }
}
