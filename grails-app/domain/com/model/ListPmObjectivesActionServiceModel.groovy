package com.model

class ListPmObjectivesActionServiceModel {
    public static final String MODEL_NAME = 'list_pm_objectives_action_service_model'

    public static final String SQL_LIST_OBJECTIVES_MODEL = """
        CREATE OR REPLACE VIEW list_pm_objectives_action_service_model AS
        SELECT d.id, d.version, d.objective, g.id AS goal_id, g.goal,d.sequence,
        sc.id AS service_id,sc.name AS service,sc.short_name AS ser_short_name
        FROM pm_objectives d
        LEFT JOIN pm_goals g ON g.id = d.goal_id
        LEFT JOIN pm_service_sector sc ON sc.id = d.service_id
        ORDER BY sc.sequence,d.sequence ASC;
    """

    long id
    long version
    long serviceId
    long goalId
    String service
    String serShortName
    String goal
    String objective
    float sequence

    static constraints = {
    }
}
