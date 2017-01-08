package com.model

class ListPmSpSummaryActionServiceModel {

    public static final String MODEL_NAME = 'list_pm_sp_summary_action_service_model'
    public static final String SQL_LIST_SP_SUMMARY_MODEL = """
    CREATE VIEW list_pm_sp_summary_action_service_model AS
          SELECT sm.id, sm.version,s.id AS service_id,s.name AS service, sm.summary, sm.created_on, sm.last_update_on
          FROM pm_sp_summary sm
          LEFT JOIN pm_service_sector s ON s.id = sm.service_id
          ORDER BY s.sequence,sm.id;
    """

    long id
    long version
    long serviceId
    String service
    String summary
    Integer year
    Date createdOn
    Date lastUpdateOn

    static mapping = {
        cache usage: "read-only"
    }
}
