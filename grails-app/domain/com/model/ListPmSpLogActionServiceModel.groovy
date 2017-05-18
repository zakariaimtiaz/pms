package com.model

class ListPmSpLogActionServiceModel {

    public static final String MODEL_NAME = 'list_pm_sp_log_action_service_model'

    public static final String SQL_LIST_PM_SP_LOG_MODEL = """
        CREATE OR REPLACE VIEW list_pm_sp_log_action_service_model AS
        SELECT spl.id,spl.version,spl.year,sc.id AS service_id,sc.short_name AS service,spl.sp_time_schedule_id,
        spl.is_submitted,spl.is_editable,spl.submission_date,spl.dead_line

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
    Date deadLine
    String service
    boolean isSubmitted
    boolean isEditable


    static constraints = {
    }
}
