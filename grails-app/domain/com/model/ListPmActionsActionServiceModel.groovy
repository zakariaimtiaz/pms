package com.model

class ListPmActionsActionServiceModel {
    public static final String MODEL_NAME = 'list_pm_actions_action_service_model'

    public static final String SQL_LIST_ACTIONS_MODEL = """
        CREATE OR REPLACE VIEW list_pm_actions_action_service_model AS
        SELECT d.id, d.version, d.actions, g.id AS goal_id, g.goal,d.sequence,
        sc.id AS service_id,sc.name AS service,sc.short_name AS ser_short_name,d.weight,
        d.start, d.end, d.mea_indicator,d.target,d.res_person,d.strategy_map_ref,
        d.support_department,d.source_of_fund,d.remarks
        FROM pm_actions d
        LEFT JOIN pm_goals g ON g.id = d.goal_id
        LEFT JOIN pm_service_sector sc ON sc.id = d.service_id
        ORDER BY sc.sequence,d.id ASC;
    """

    long id
    long version
    long serviceId
    long goalId
    String service
    String serShortName
    String goal
    String actions
    String sequence
    String meaIndicator
    String target
    String resPerson
    String strategyMapRef
    String supportDepartment
    String sourceOfFund
    String remarks
    Date start
    Date end
    int weight

    static constraints = {
    }
}
