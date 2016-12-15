package actions.reports

import com.pms.PmGoals
import com.pms.PmMissions
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

    /**
     * 1. initialize params for pagination of list
     *
     * 2. pull all appUser list from database (if no criteria)
     *
     * 3. pull filtered result from database (if given criteria)
     *
     * @param result - parameter from pre-condition
     * @return - same map of input-parameter containing isError(true/false)
     */
    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            String monthStr = result.month.toString()
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

            Date date = originalFormat.parse(monthStr);
            Calendar c = Calendar.getInstance();
            c.setTime(date);
            String monthName = new SimpleDateFormat("MMMM").format(c.getTime())
            c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
            Date start=DateUtility.getSqlDate(c.getTime())

            c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
            Date end=DateUtility.getSqlDate(c.getTime())
            int year = c.get(Calendar.YEAR)
            long serviceId = Long.parseLong(result.serviceId.toString())
            String type = result.type
            if(type.equals("Mission")){
                List lstVal = buildMissionList(serviceId)
                result.put("mission", lstVal)
            }else if(type.equals("Goals")){
                List<PmGoals> lstGoals = PmGoals.findAllByServiceIdAndYear(serviceId,year)
                result.put(LIST, lstGoals)
            }else if(type.equals("Actions")){
                List<GroovyRowResult> lstAction = buildActionsList(serviceId,start,end)
                result.put(LIST, lstAction)
                return result
            }else if(type.equals("Details")){
                long actionsId = Long.parseLong(result."filter[filters][0][value]")
                List<GroovyRowResult> lstSprint = buildIndicatorDetails(serviceId,actionsId, start, end, monthName)
                result.put(LIST, lstSprint)
                return result
            }
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

    private static List<Map> buildMissionList(long serviceId) {
        List<Map> result = []
        PmMissions mission = PmMissions.findByServiceId(serviceId)
        Map obj = [
                mission: mission?.mission
        ]
        result << obj
        return result
    }

    private List<GroovyRowResult> buildActionsList(long serviceId,Date start, Date end) {
        String query = """
                SELECT a.id,a.sequence,a.start,a.end,a.actions,a.service_id AS serviceId,a.goal_id AS goalId,a.tmp_seq AS tmpSeq,
                        a.res_person AS resPerson, a.note,a.support_department AS supportDepartment,
                        a.strategy_map_ref AS strategyMapRef,a.source_of_fund AS sourceOfFund,
(SELECT GROUP_CONCAT(short_name) FROM pm_service_sector WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.support_department,','))>0 ) support_department_str
                FROM pm_actions a
                LEFT JOIN pm_service_sector sc ON sc.id = a.service_id
                WHERE a.service_id = ${serviceId}
                AND ('${start}' <= a.end AND '${end}' >= a.start)
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
    private List<GroovyRowResult> buildIndicatorDetails(long serviceId,long actionsId, Date start, Date end, String monthStr) {
        String query = """
                SELECT a.id,idd.id AS ind_details_id,i.indicator,i.target,idd.month_name,idd.target monthly_target,
                idd.achievement,idd.remarks,SUM(tmp.achievement) total_achievement
                FROM pm_actions a
                LEFT JOIN pm_actions_indicator i ON i.actions_id = a.id
                LEFT JOIN pm_actions_indicator_details tmp ON tmp.indicator_id = i.id
                LEFT JOIN pm_actions_indicator_details idd ON idd.indicator_id = i.id AND idd.month_name = '${monthStr}'
                WHERE a.id = ${actionsId}
                GROUP BY i.id,idd.id
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
}
