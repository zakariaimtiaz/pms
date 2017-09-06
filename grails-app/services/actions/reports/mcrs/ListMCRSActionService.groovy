package actions.reports.mcrs

import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class ListMCRSActionService extends BaseService implements ActionServiceIntf {

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
            int month = c.get(Calendar.MONTH) + 1
            c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
            Date currentMonth = DateUtility.getSqlDate(c.getTime());
            long serviceId = Long.parseLong(result.serviceId.toString())
            String indicatorType = result.indicatorType.toString()
            String filterType = result.filterType.toString()
            String indicatorLight = result.indicatorLight.toString()
            List lstVal = buildResultList(serviceId, year, currentMonth,indicatorType,filterType,indicatorLight)
            List lstValAdditional = buildResultListAdditional(serviceId, year, month)
            result.put(LIST, lstVal)
            result.put("lstAddi", lstValAdditional)
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

    private List<GroovyRowResult> buildResultList(long serviceId,int year, Date currentMonth,String type,String filterType,String indicatorLight) {
        String indicatorLightStr = EMPTY_SPACE
        if(indicatorLight.equals("Red")) {
            indicatorLightStr = "WHERE ROUND(((mon_acv/mon_tar)*100)-100) BETWEEN -100 AND -50"
        }else if(indicatorLight.equals("Amber")){
            indicatorLightStr = "WHERE ROUND(((mon_acv/mon_tar)*100)-100) BETWEEN -49 AND -1 "
        }else if(indicatorLight.equals("Green")){
            indicatorLightStr = "WHERE ROUND(((mon_acv/mon_tar)*100)-100) >= 0 "
        }else{
            indicatorLightStr = EMPTY_SPACE
        }
        String actionIndicatorJoin = "JOIN pm_actions_indicator ai ON ai.actions_id = a.id AND ai.year = ${year}"
        if(type.equals("Action Indicator")) {
            actionIndicatorJoin = "JOIN pm_actions_indicator ai ON a.id = ai.actions_id AND ai.year = ${year} " +
                    " AND ai.id = (SELECT MIN(id) id  FROM pm_actions_indicator WHERE actions_id = a.id GROUP BY actions_id)"
        }else if(type.equals("Preferred Indicator") && filterType.equals("create")){
            actionIndicatorJoin = "JOIN pm_actions_indicator ai ON ai.year = ${year} AND ai.actions_id = a.id AND ai.is_preference = TRUE"
        }

        String query = """
                SELECT * FROM
                (SELECT @rownum := @rownum + 1 AS id,CAST(CONCAT(g.sequence,'. ',g.goal) AS CHAR CHARACTER SET utf8) AS goal,
                 a.service_id AS serviceId,a.goal_id,a.id action_id,a.sequence,a.actions,a.start,a.end,COALESCE(
                (SELECT GROUP_CONCAT(CONCAT('<strike>',CAST(DATE_FORMAT(END,'%M') AS CHAR CHARACTER SET utf8 ) ,'</strike>') SEPARATOR' ')
                FROM pm_actions_extend_history WHERE actions_id=a.id),'')  extendedEnd,
                 ai.id AS indicator_id,ai.indicator,ai.indicator_type,ai.is_preference,

                 SUM(CASE WHEN  cm.sl_index=@curmon THEN COALESCE(idd.target,0) ELSE 0 END) mon_tar,
                 SUM(CASE WHEN  cm.sl_index=@curmon THEN COALESCE(idd.achievement,0) ELSE 0 END) mon_acv,

                 CONCAT(ROUND((SUM(CASE WHEN  cm.sl_index=@curmon THEN COALESCE(idd.achievement,0) ELSE 0 END)/
                 SUM(CASE WHEN  cm.sl_index=@curmon THEN COALESCE(idd.target,0) ELSE 0 END))*100)-100,'%') AS mon_var,

                 CASE
                 WHEN  ai.indicator_type LIKE 'Repeatable%' THEN
                 ROUND((100*SUM(CASE WHEN cm.sl_index<=@curmon THEN COALESCE(idd.target,0) ELSE 0 END))/SUM(COALESCE(idd.target,0)))
                 ELSE
                 SUM(CASE WHEN cm.sl_index<=@curmon THEN CASE WHEN idd.is_extended=TRUE THEN 0 ELSE COALESCE(idd.target,0) END ELSE 0 END)  END cum_tar,

                 CASE
                 WHEN  ai.indicator_type LIKE 'Repeatable%' THEN
                 ROUND((100*SUM(CASE WHEN  cm.sl_index<=@curmon THEN COALESCE(idd.achievement,0) ELSE 0 END))/SUM(COALESCE(idd.target,0)))
                 ELSE
                 SUM(CASE WHEN  cm.sl_index<=@curmon THEN COALESCE(idd.achievement,0) ELSE 0 END)  END cum_acv,

                 CASE
                 WHEN  ai.indicator_type LIKE 'Repeatable%' THEN
                 SUM(CASE WHEN  cm.sl_index=@curmon THEN COALESCE(ai.target,0) ELSE 0 END)
                 ELSE SUM(COALESCE(idd.target,0)) END  tot_tar,

                 a.note remarks,SUBSTRING_INDEX(a.res_person,'(',1) AS responsiblePerson,
                 (SELECT CASE WHEN COALESCE(ai.closing_month,'')=DATE('${currentMonth}') THEN CONCAT(remarks,'</br><b>Closing note: </b>',ai.closing_note) ELSE remarks END
                 FROM pm_actions_indicator_details WHERE indicator_id = ai.id AND month_name=MONTHNAME(DATE('${currentMonth}'))) ind_remarks,
                 (SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_projects WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.source_of_fund,', '))>0 ) project,
                 (SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_service_sector WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.support_department,','))>0 ) supportDepartment

                FROM pm_actions a
                JOIN pm_goals g ON g.id = a.goal_id
                ${actionIndicatorJoin}
                JOIN pm_actions_indicator_details idd ON idd.indicator_id = ai.id
                JOIN custom_month cm ON cm.name=idd.month_name
                JOIN pm_service_sector sc ON sc.id = a.service_id,
                (SELECT @rownum := 0, @curmon := MONTH(DATE('${currentMonth}'))) r
                WHERE a.year = ${year} AND ai.year = ${year} AND sc.id = ${serviceId}
                AND (@curmon <= MONTH(a.end ) AND @curmon >= MONTH(a.start))
                GROUP BY ai.id
                HAVING mon_tar!=0 OR mon_acv !=0
                ORDER BY sc.id,a.year, a.goal_id, a.tmp_seq ) tmp ${indicatorLightStr};
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }

    private List<GroovyRowResult> buildResultListAdditional(long serviceId,int year, int month) {
        String query = """
                SELECT @rownum := @rownum + 1 AS id,CAST(CONCAT(g.sequence,'. ',g.goal) AS CHAR CHARACTER SET utf8) AS goal,
                 a.service_id AS serviceId,a.goal_id,a.id action_id,a.sequence,a.actions,a.start,a.end,
                 ai.id AS indicator_id,ai.indicator,ai.indicator_type,ai.remarks remarks,ai.target,
                 a.note remarks,SUBSTRING_INDEX(a.res_person,'(',1) AS responsiblePerson,

                 (SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_projects WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.source_of_fund,', '))>0 ) project,
                 (SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_service_sector WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.support_department,','))>0 ) supportDepartment

                FROM pm_additional_actions a
                JOIN pm_goals g ON g.id = a.goal_id
                JOIN pm_additional_actions_indicator ai ON ai.actions_id = a.id
                JOIN pm_service_sector sc ON sc.id = a.service_id,
                (SELECT @rownum := 0) r
                WHERE sc.id = ${serviceId} AND YEAR(a.start) = ${year} and MONTH(a.start) = ${month}
                GROUP BY ai.id
                ORDER BY sc.id,a.goal_id, a.tmp_seq;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
}
