package com.model

class ListQuartzActionServiceModel {

    public static final String MODEL_NAME = 'list_quartz_action_service_model'
    public static final String SQL_LIST_QUARTZ_MODEL = """
    CREATE OR REPLACE VIEW list_quartz_action_service_model AS
          SELECT id, version,job_name,trigger_name,description,cron_expression,is_active,is_running
          FROM quartz;
    """

    long id
    long version
    String jobName
    String triggerName
    String description
    String cronExpression
    boolean isActive
    boolean isRunning

    static mapping = {
        cache usage: "read-only"
    }
}
