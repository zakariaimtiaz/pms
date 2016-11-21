package com.model

class ListPmServiceSectorActionServiceModel {
    public static final String MODEL_NAME = 'list_pm_service_sector_action_service_model'

    public static final String SQL_LIST_SERVICE_MODEL = """
        CREATE OR REPLACE VIEW list_pm_service_sector_action_service_model AS
        SELECT d.id, d.version, d.name, d.short_name, d.category_id , sc.name AS category_name,d.sequence,
        d.department_head
        FROM pm_service_sector d
        LEFT JOIN service_category sc ON sc.id = d.category_id
        ORDER BY d.sequence ASC;
    """

    long id
    long version
    long categoryId
    String categoryName
    String name
    String shortName
    String departmentHead
    float sequence

    static constraints = {
    }
}
