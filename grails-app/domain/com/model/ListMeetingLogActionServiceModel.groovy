package com.model

class ListMeetingLogActionServiceModel {

    public static final String MODEL_NAME = 'list_meeting_log_action_service_model'
    public static final String SQL_LIST_MEETING_LOG_MODEL = """
    CREATE OR REPLACE VIEW list_meeting_log_action_service_model AS
          SELECT ml.id, ml.version, mt.id meeting_type_id,mt.name meeting_type,s.id service_id,
              s.name service,ml.held_on,ml.log_str,ml.issues,ml.attendees,
              (SELECT GROUP_CONCAT(NAME SEPARATOR ', ') FROM mis.employee
          WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',ml.attendees,', '))>0 ) attendees_str
          FROM meeting_log ml
          LEFT JOIN login_auth.sec_user u ON u.employee_id = ml.attendees
          LEFT JOIN system_entity mt ON mt.id = ml.meeting_type_id
          LEFT JOIN pm_service_sector s ON s.id = ml.service_id;
    """

    long id
    long version
    long meetingTypeId
    long serviceId
    String service
    String meetingType
    String attendees
    String attendeesStr
    String issues
    String logStr
    Date heldOn

    static mapping = {
        cache usage: "read-only"
    }
}
