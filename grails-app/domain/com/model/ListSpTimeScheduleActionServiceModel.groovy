package com.model

class ListSpTimeScheduleActionServiceModel {
    public static final String MODEL_NAME = 'list_sp_time_schedule_action_service_model'

    public static final String SQL_LIST_MISSION_MODEL = """
        CREATE OR REPLACE VIEW list_sp_time_schedule_action_service_model AS
        SELECT id,version,from_date,to_date,active_year,is_active,description FROM sp_time_schedule;
    """

    long id
    long version
    Date fromDate
    Date toDate
    String description
    String activeYear
    boolean isActive

    static mapping = {
        cache usage: "read-only"
    }

}
