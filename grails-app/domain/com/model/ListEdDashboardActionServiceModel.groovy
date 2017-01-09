package com.model

class ListEdDashboardActionServiceModel {
    public static final String MODEL_NAME = 'list_ed_dashboard_action_service_model'

    public static final String SQL_LIST_MISSION_MODEL = """

            CREATE OR REPLACE VIEW list_ed_dashboard_action_service_model AS
                SELECT
                  ed.*,edi.issue_name,MONTHNAME(month_for) AS month_name,ss.short_name AS service
                  FROM ed_dashboard ed LEFT JOIN ed_dashboard_issues edi ON ed.issue_id=edi.id
                  LEFT JOIN pm_service_sector ss ON ed.service_id=ss.id

    """

    long id
    long version
    long serviceId
    String service
    long issueId
    String issueName
    String description
    String remarks
    String edAdvice
    Date monthFor
    String monthName
    Date createDate
    long createBy

    static constraints = {
    }
}
