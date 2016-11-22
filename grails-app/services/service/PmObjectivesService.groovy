package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class PmObjectivesService extends BaseService{

    public List<GroovyRowResult> lstObjectivesForDropDown(long goalId) {
        String queryForList = """
            SELECT o.id AS id, CONCAT(o.sequence,'. ',o.objective) AS name
                FROM pm_objectives o
                WHERE o.goal_id = ${goalId}
                ORDER BY o.sequence
        """
        List<GroovyRowResult> lstObjectives = executeSelectSql(queryForList)
        return lstObjectives
    }
}
