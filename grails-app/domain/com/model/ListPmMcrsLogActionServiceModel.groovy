package com.model

class ListPmMcrsLogActionServiceModel {

    public static final String MODEL_NAME = 'list_pm_mcrs_log_action_service_model'

    public static final String SQL_LIST_PM_MCRS_LOG_MODEL = """
         CREATE OR REPLACE VIEW list_pm_mcrs_log_action_service_model AS

        SELECT sml.id,sml.version,sml.is_submitted,sml.is_submitted_db,sml.is_editable,sml.is_editable_db,sml.month,
        sml.month_str,sml.service_id,sml.submission_date,sml.submission_date_db,sml.year,sml.dead_line,sc.short_name,sc.name AS service
        ,COALESCE((SELECT COUNT(id) FROM ed_dashboard WHERE MONTH(month_for)=sml.month AND YEAR(month_for)=sml.year AND service_id=sml.service_id
        GROUP BY  service_id),0) AS issue_count
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
    Date submissionDateDb
    Date deadLine
    String service
    String shortName
    boolean isSubmitted
    boolean isSubmittedDb
    boolean isEditable
    boolean isEditableDb
    int issueCount


    static constraints = {
    }
}
