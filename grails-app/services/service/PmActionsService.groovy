package service

import com.pms.SecUser
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class PmActionsService extends BaseService{

    public List<GroovyRowResult> lstActionsByServiceIdAndYear(long serviceId, String year) {
        String queryForList = """
            SELECT o.id,o.sequence AS name FROM pm_actions o
                WHERE o.service_id = ${serviceId}
                AND YEAR(start)<='${year}' AND YEAR(end) >='${year}'
                ORDER BY o.goal_id,o.tmp_seq
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        return lst
    }
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
    public List<GroovyRowResult> lstDepartmentSpStatus() {
        String query = """
            SELECT ss.name,LEFT(ss.short_name,6) short_name,COUNT(DISTINCT(a.id)) AS count,l.is_submitted,
                        CASE WHEN l.is_submitted IS TRUE THEN '#00FF00' ELSE '#FF6666' END col_color
                            FROM pm_service_sector ss
                            LEFT JOIN pm_actions a ON ss.id=a.service_id
                            LEFT JOIN pm_sp_log l ON l.service_id = ss.id AND l.year = YEAR(NOW())
                            WHERE ss.is_in_sp = TRUE
                            GROUP BY ss.id
            ORDER BY ss.name;
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    public List<GroovyRowResult> lstGoalWiseActionStatus() {
        SecUser user = currentUserObject();
        Date date = DateUtility.getSqlDate(new Date());
        String query = """
            SELECT cat_axe,ac_count,ac_count-a_col t_col,a_col,a_color,t_color,goal
            FROM
            (SELECT CONCAT('Goal ',g.sequence) cat_axe,COUNT(a.id) ac_count,
            ROUND(SUM(FLOOR(((COALESCE(aid.achievement,0)/aid.target)*100)))/COUNT(ai.id)*COUNT(a.id)/100,2) a_col,
            '#FF6666' t_color, '#00FF00' a_color,g.goal
            FROM pm_goals g
            LEFT JOIN pm_actions a ON a.goal_id = g.id
            LEFT JOIN pm_actions_indicator ai ON a.id = ai.actions_id
            LEFT JOIN pm_actions_indicator_details aid ON ai.id=aid.indicator_id
            JOIN custom_month cm ON cm.name=aid.month_name,
            (SELECT @curmon := MONTH(DATE('${date}'))) r
            WHERE g.service_id = ${user.serviceId} AND a.year = YEAR(DATE('${date}')) AND cm.sl_index=@curmon AND aid.target > 0
            GROUP BY g.id
            ORDER BY g.sequence,a.id,ai.id,aid.id) tmp;
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    public List<GroovyRowResult> findAllDetailsByActionsIdAndIndicatorId(long actionsId, long indicatorId) {
        String query = """
            SELECT aid.*,ai.indicator_type
                FROM pm_actions_indicator_details aid
                LEFT JOIN pm_actions_indicator ai ON ai.id=aid.indicator_id
                WHERE aid.actions_id = ${actionsId} AND aid.indicator_id = ${indicatorId}
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
}
