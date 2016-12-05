package service

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

@Transactional
class PmActionsService extends BaseService{

    public List<GroovyRowResult> lstActionsForDropDown(long goalId) {
        String queryForList = """
            SELECT o.id AS id, CONCAT(o.sequence,'. ',o.actions) AS name
                FROM pm_actions o
                WHERE o.goal_id = ${goalId}
                ORDER BY o.tmp_seq
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        return lst
    }
    public boolean taskDateWithinActionsDate(Date start,Date end,long actionsId) {
        String queryForList = """
            SELECT COUNT(id) as c FROM pm_actions
            WHERE START<='${start}' AND END >='${end}' AND id=${actionsId}
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        int count =(int) lst[0].c
        boolean isWithin=false
        if(count>0){
            isWithin=true
        }

        return isWithin
    }
}
