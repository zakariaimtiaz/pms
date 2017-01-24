package com.model

class ListPmMissionsActionServiceModel {
    public static final String MODEL_NAME = 'list_pm_missions_action_service_model'

    public static final String SQL_LIST_MISSION_MODEL = """

        DROP TABLE IF EXISTS `list_pm_missions_action_service_model`;
        DROP VIEW IF EXISTS `list_pm_missions_action_service_model`;

        CREATE OR REPLACE VIEW `pms`.`list_pm_missions_action_service_model` AS
                SELECT
                  `m`.`id`          AS `id`,
                  `m`.`version`     AS `version`,
                  `m`.`mission`     AS `mission`,
                  `sc`.`short_name` AS `service_short_name`,
                  `sc`.`id`         AS `service_id`,
                  `sc`.`name`       AS `service`,
                  `sc`.`sequence`   AS `sequence`,
                  CONCAT(`sc`.`name`,' (',`sc`.`short_name`,')')  AS `display_name`
                FROM (`pms`.`pm_missions` `m`
                   LEFT JOIN `pms`.`pm_service_sector` `sc`
                     ON ((`sc`.`id` = `m`.`service_id`)))
                ORDER BY `sc`.`sequence;
    """

    long id
    long version
    long serviceId
    String service
    String displayName
    String mission
    float sequence

    static constraints = {
    }
}
