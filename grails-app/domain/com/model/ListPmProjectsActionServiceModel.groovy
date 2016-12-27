package com.model

class ListPmProjectsActionServiceModel {
    public static final String MODEL_NAME = 'list_pm_projects_action_service_model'

    public static final String SQL_LIST_PROJECTS_MODEL = """
        DROP TABLE IF EXISTS list_pm_projects_action_service_model;
        CREATE OR REPLACE VIEW list_pm_projects_action_service_model AS

        SELECT m.id, m.version,m.name,m.short_name,m.code,m.description,m.donor,m.end_date,
        m.start_date,m.type_id,se.name AS type_name,m.create_date,m.create_by,m.is_active
        FROM pm_projects m
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
    String donor
    String description
    Date startDate
    Date endDate
    Date createDate
    long createBy
    Boolean isActive

    static constraints = {
    }
}
