package com.model

class ListPmSpLogActionServiceModel {

    public static final String MODEL_NAME = 'list_pm_sp_log_action_service_model'

    public static final String SQL_LIST_PM_SP_LOG_MODEL = """
        DROP TABLE IF EXISTS list_pm_sp_log_action_service_model;
        CREATE OR REPLACE VIEW list_pm_sp_log_action_service_model AS
        SELECT spl.id,spl.version,spl.year,sc.id as service_id,sc.short_name as service,spl.sp_time_schedule_id,
        spl.is_submitted,spl.is_editable,spl.edit_type_ids,spl.editable_action_ids,spl.submission_date,
        (SELECT GROUP_CONCAT(NAME SEPARATOR ', ') FROM system_entity se WHERE se.type_id = 3
        AND LOCATE(CONCAT(',',id,',') ,CONCAT(',',spl.edit_type_ids,', '))>0 ) edit_type_id_str
        FROM pm_sp_log spl
        LEFT JOIN pm_service_sector sc ON sc.id = spl.service_id
        ORDER BY sc.sequence,spl.id ASC;
    """

    long id
    long version
    int year
    long serviceId
    long spTimeScheduleId
    Date submissionDate
    String service
    boolean isSubmitted
    boolean isEditable
    String editTypeIds
    String editTypeIdStr
    String editableActionIds

    static constraints = {
    }
}
