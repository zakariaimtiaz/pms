package actions.reports.monthly

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class ListSpMonthlyPlanActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    /**
     * No pre conditions required for searching project domains
     *
     * @param params - Request parameters
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePreCondition(Map params) {
        return params
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            String monthStr = result.month.toString()
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

            Date date = originalFormat.parse(monthStr);
            Calendar c = Calendar.getInstance();
            c.setTime(date);
            int year = c.get(Calendar.YEAR)

            Date currentMonth = DateUtility.getSqlDate(c.getTime());

            long serviceId = Long.parseLong(result.serviceId.toString())
            List lstVal = buildResultList(serviceId, year, currentMonth,result.indicatorType.toString())
            result.put(LIST, lstVal)
            result.put(COUNT, lstVal.size())
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    /**
     * There is no postCondition, so return the same map as received
     *
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * Since there is no success message return the same map
     * @param result -map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return result
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     * @param result -map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private List<GroovyRowResult> buildResultList(long serviceId,int year, Date currentMonth,String type) {
        String actionIndicatorJoin = "JOIN pm_actions_indicator ai ON ai.actions_id = a.id"
        if(type.equals("Action Indicator")){
            actionIndicatorJoin = "JOIN (SELECT pai.* FROM pm_actions_indicator pai " +
            "JOIN (SELECT MIN(id) id  FROM pm_actions_indicator GROUP BY actions_id ) tmp ON pai.id=tmp.id) ai ON ai.actions_id = a.id"
        }

        String query = """
                SELECT * FROM (SELECT @rownum := @rownum + 1 AS id,CONCAT(g.sequence,'. ',g.goal) goal,

                 a.service_id AS serviceId,a.goal_id,a.id action_id,a.sequence,a.actions,a.start,a.end,
                 ai.indicator,ai.indicator_type,ai.remarks ind_remarks,

                 SUM(CASE WHEN  cm.sl_index=MONTH(DATE('${currentMonth}')) THEN COALESCE(idd.target,0) ELSE 0 END) mon_tar,
                 SUM(CASE WHEN  cm.sl_index=MONTH(DATE('${currentMonth}')) THEN COALESCE(idd.achievement,0) ELSE 0 END) mon_acv,
                 CASE WHEN  ai.indicator_type LIKE 'Repeatable%' THEN
                 FLOOR(SUM(CASE WHEN  cm.sl_index<=MONTH(DATE('${currentMonth}')) THEN COALESCE(idd.target,0) ELSE 0 END)/SUM(CASE WHEN  cm.sl_index<=MONTH(DATE('${currentMonth}')) THEN 1 ELSE 0 END))
                 ELSE
                 SUM(CASE WHEN  cm.sl_index<=MONTH(DATE('${currentMonth}')) THEN COALESCE(idd.target,0) ELSE 0 END)  END cum_tar,
                 CASE WHEN  ai.indicator_type LIKE 'Repeatable%' THEN
                 FLOOR(SUM(CASE WHEN  cm.sl_index<=MONTH(DATE('${currentMonth}')) THEN COALESCE(idd.achievement,0) ELSE 0 END)/SUM(CASE WHEN  cm.sl_index<=MONTH(DATE('${currentMonth}')) THEN 1 ELSE 0 END))
                 ELSE
                 SUM(CASE WHEN  cm.sl_index<=MONTH(DATE('${currentMonth}')) THEN COALESCE(idd.achievement,0) ELSE 0 END)  END cum_acv,
                 CASE WHEN  ai.indicator_type LIKE 'Repeatable%' THEN
                 SUM(CASE WHEN  cm.sl_index=MONTH(DATE('${currentMonth}')) THEN COALESCE(idd.target,0) ELSE 0 END)
                 ELSE SUM(COALESCE(idd.target,0)) END  tot_tar,

                 a.note remarks,SUBSTRING_INDEX(a.res_person,'(',1) AS responsiblePerson,
                 (SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_projects WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.source_of_fund,', '))>0 ) project,
                 (SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_service_sector WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.support_department,','))>0 ) supportDepartment

                FROM (SELECT * FROM pm_actions  WHERE  YEAR(DATE(`start`))=${year}) a
                JOIN pm_goals g ON g.id = a.goal_id
                ${actionIndicatorJoin}
                JOIN pm_actions_indicator_details idd ON idd.indicator_id = ai.id
                JOIN custom_month cm ON cm.name=idd.month_name
                JOIN (SELECT * FROM pm_service_sector WHERE id = ${serviceId}) sc ON sc.id = a.service_id,
                (SELECT @rownum := 0) r
                GROUP BY ai.id
                ORDER BY sc.id,EXTRACT(YEAR FROM a.start) , a.goal_id ,a.tmp_seq) tmp WHERE tmp.mon_tar!=0;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }}
