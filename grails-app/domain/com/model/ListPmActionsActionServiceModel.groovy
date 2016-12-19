package com.model

class ListPmActionsActionServiceModel {
    public static final String MODEL_NAME = 'list_pm_actions_action_service_model'

    public static final String SQL_LIST_ACTIONS_MODEL = """
            DROP TABLE IF EXISTS list_pm_actions_action_service_model;
            CREATE OR REPLACE VIEW list_pm_actions_action_service_model AS
            SELECT d.id, d.version,d.actions, g.id AS goal_id, g.goal,d.res_person_id,d.sequence, sc.id AS service_id,sc.name AS service,
            sc.short_name AS ser_short_name,d.start, d.end, d.res_person,d.strategy_map_ref, d.source_of_fund,d.note,d.support_department,d.total_indicator,
            (SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_service_sector WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',d.support_department,', '))>0 ) support_department_str,
            (SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_projects WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',d.source_of_fund,', '))>0 ) source_of_fund_str
            FROM pm_actions d
            LEFT JOIN pm_goals g ON g.id = d.goal_id
            LEFT JOIN pm_service_sector sc ON sc.id = d.service_id
            ORDER BY sc.sequence,d.id ASC;
    """

    long id
    long version
    long serviceId
    long goalId
    long resPersonId
    int totalIndicator
    String service
    String serShortName
    String goal
    String actions
    String sequence
    String resPerson
    String strategyMapRef
    String supportDepartment
    String supportDepartmentStr
    String sourceOfFund
    String sourceOfFundStr
    String note
    Date start
    Date end

    static constraints = {
    }
}
