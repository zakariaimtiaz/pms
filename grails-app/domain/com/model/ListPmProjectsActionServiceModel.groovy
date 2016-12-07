package com.model

class ListPmProjectsActionServiceModel {
    public static final String MODEL_NAME = 'list_pm_projects_action_service_model'

    public static final String SQL_LIST_GOALS_MODEL = """
        DROP TABLE IF EXISTS list_pm_projects_action_service_model;
            CREATE OR REPLACE VIEW list_pm_projects_action_service_model AS

        SELECT m.id, m.version, sc.short_name AS service, sc.id AS service_id,m.code,m.description,m.donor,m.end_date,
        m.name,m.short_name,m.start_date,m.type_id,se.name AS type_name,m.create_date,m.create_by,m.in_active
        FROM pm_projects m
        LEFT JOIN pm_service_sector sc ON sc.id = m.service_id
        LEFT JOIN system_entity se ON se.id=m.type_id
        ORDER BY id ASC;
    """

    long id
    long version
    String name
    String shortName
    String typeName
    Long typeId
    String code
    Long serviceId
    String service
    String donor
    String description
    Date startDate
    Date endDate
    Date createDate
    long createBy
    Boolean inActive

    static constraints = {
    }
}
