package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class PmGoalsService extends BaseService{

    public List<GroovyRowResult> lstGoalsForDropDown(long serviceId) {
        String queryForList = """
            SELECT g.id AS id, CONCAT(g.sequence,'. ',g.goal) AS name
                FROM pm_goals g
                WHERE g.service_id = ${serviceId}
                ORDER BY g.sequence
        """
        List<GroovyRowResult> lstGoals = executeSelectSql(queryForList)
        return lstGoals
    }
}
