package com.model

class ListPmMcrsLogActionServiceModel {

    public static final String MODEL_NAME = 'list_pm_mcrs_log_action_service_model'

    public static final String SQL_LIST_PM_MCRS_LOG_MODEL = """
        CREATE OR REPLACE VIEW list_pm_mcrs_log_action_service_model AS

        SELECT sml.id,sml.version,sml.is_submitted,sml.is_editable,sml.month,sml.month_str,sml.service_id,
        sml.submission_date,sml.year,sml.dead_line,sc.short_name,sc.name AS service
        FROM pm_mcrs_log sml
        LEFT JOIN pm_service_sector sc ON sc.id = sml.service_id
        ORDER BY sc.id,sml.month ASC;
    """

    long id
    long version
    String year
    int month
    String monthStr
    long serviceId
    Date submissionDate
    Date deadLine
    String service
    String shortName
    boolean isSubmitted
    boolean isEditable


    static constraints = {
    }
}
