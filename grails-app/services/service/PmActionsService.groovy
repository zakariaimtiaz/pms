package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class PmActionsService extends BaseService{

    public List<GroovyRowResult> lstActionsForDropDown(long objectiveId) {
        String queryForList = """
            SELECT o.id AS id, CONCAT(o.sequence,'. ',o.actions) AS NAME
                FROM pm_actions o
                WHERE o.objective_id = ${objectiveId}
                ORDER BY o.sequence
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        return lst
    }
}
