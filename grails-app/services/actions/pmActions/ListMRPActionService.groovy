package actions.pmActions

import com.pms.PmGoals
import com.pms.PmMissions
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat
import org.apache.log4j.Logger

@Transactional
class ListMRPActionService extends BaseService implements ActionServiceIntf {

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
            Date currentMonth = DateUtility.getSqlDate(c.getTime());

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
                List<PmGoals> lstGoals = PmGoals.findAllByServiceId(serviceId)
                result.put(LIST, lstGoals)
            }else if(type.equals("Actions")){
                List<GroovyRowResult> lstAction = buildActionsList(serviceId,start,end,currentMonth)
                result.put(LIST, lstAction)
                return result
            }else if(type.equals("Details")){
                long actionsId = Long.parseLong(result."filter[filters][0][value]")
                List<GroovyRowResult> lstSprint = buildIndicatorDetails(actionsId, monthName)
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

    private List<GroovyRowResult> buildActionsList(long serviceId,Date start, Date end, Date currentMonth) {
        String query = """
                SELECT g.goal,a.id,a.sequence,a.start,a.end,COALESCE(a.extended_end,'') extendedEnd,a.actions,a.service_id AS serviceId,a.goal_id AS goalId,a.tmp_seq AS tmpSeq,
                        a.res_person AS resPerson, a.note,a.support_department AS supportDepartment,a.strategy_map_ref AS strategyMapRef,a.source_of_fund AS sourceOfFund,
(SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_service_sector WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.support_department,','))>0 ) supportDepartmentStr,
(SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_projects WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.source_of_fund,', '))>0 ) sourceOfFundStr

                FROM pm_actions a
                LEFT JOIN pm_goals g ON g.id = a.goal_id
                JOIN (SELECT * FROM pm_service_sector WHERE id = ${serviceId}) sc ON sc.id = a.service_id
                WHERE a.service_id = ${serviceId}
                AND ('${start}' <= (CASE WHEN COALESCE(a.extended_end,'')!='' THEN a.extended_end ELSE a.end END) AND '${end}' >= a.start)
                ORDER BY sc.id,EXTRACT(YEAR FROM a.start) , a.goal_id ,a.tmp_seq
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
    private List<GroovyRowResult> buildIndicatorDetails(long actionsId, String monthStr) {
        String query = """
                SELECT a.id,idd.id AS ind_details_id,i.indicator,i.target,i.unit_id,i.unit_str,i.indicator_type,idd.month_name,
                idd.target monthly_target,CASE WHEN idd.achievement>0 THEN idd.achievement ELSE NULL END achievement
                ,CASE WHEN COALESCE(i.closing_month,'')!='' THEN idd.remarks+'\\n Closing note:- '+i.closing_note ELSE idd.remarks END remarks,
SUM(tmp.achievement) total_achievement
                FROM pm_actions a
                LEFT JOIN pm_actions_indicator i ON i.actions_id = a.id
                LEFT JOIN pm_actions_indicator_details tmp ON tmp.indicator_id = i.id
                LEFT JOIN pm_actions_indicator_details idd ON idd.indicator_id = i.id AND idd.month_name = '${monthStr}'
                 --   AND idd.target > 0
                WHERE a.id = ${actionsId}
                GROUP BY i.id,idd.id
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
}

