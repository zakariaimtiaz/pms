package com.model

class ListPmGoalsActionServiceModel {
    public static final String MODEL_NAME = 'list_pm_goals_action_service_model'

    public static final String SQL_LIST_GOALS_MODEL = """
        CREATE OR REPLACE VIEW list_pm_goals_action_service_model AS
        SELECT m.id, m.version, m.goal, sc.short_name AS ser_short_name, sc.id AS service_id,
         sc.name AS service,m.sequence
        FROM pm_goals m
        LEFT JOIN pm_service_sector sc ON sc.id = m.service_id
        ORDER BY sc.sequence,m.sequence ASC;
    """

    long id
    long version
    long serviceId
    String service
    String serShortName
    String goal
    int sequence

    static constraints = {
    }
}
