package com.model

class ListPmSprintsActionServiceModel {
    public static final String MODEL_NAME = 'list_pm_sprints_action_service_model'

    public static final String SQL_LIST_SPRINTS_MODEL = """
         CREATE OR REPLACE VIEW list_pm_sprints_action_service_model AS
        SELECT s.id, s.version, s.sprints,d.id AS actions_id,d.actions, g.id AS goal_id, g.goal,s.sequence,
        sc.id AS service_id,sc.name AS service,sc.short_name AS ser_short_name,s.weight,
        s.start_date, s.end_date, s.target,s.res_person,s.support_department,s.remarks
        FROM pm_sprints s LEFT JOIN
        pm_actions d ON s.actions_id=d.id
        LEFT JOIN pm_goals g ON g.id = d.goal_id
        LEFT JOIN pm_service_sector sc ON sc.id = d.service_id
        ORDER BY sc.sequence,s.sequence ASC;
    """

    long id
    long version
    long serviceId
    long goalId
    long actionsId
    String service
    String serShortName
    String goal
    String actions
    String sprints
    String sequence
    String target
    String resPerson
    String supportDepartment
    String remarks
    Date startDate
    Date endDate
    int weight

    static constraints = {
    }
}
