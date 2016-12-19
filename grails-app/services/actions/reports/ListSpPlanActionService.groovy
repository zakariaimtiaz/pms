package actions.reports

import com.pms.PmGoals
import com.pms.PmMissions
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class ListSpPlanActionService extends BaseService implements ActionServiceIntf {

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
            String yearStr = result.year
            Calendar calendar = Calendar.getInstance();

            int year = Integer.parseInt(yearStr);
            int jan = Calendar.JANUARY;
            int dec = Calendar.DECEMBER;
            int date = 1;
            int maxDay =0;
            calendar.set(year, jan, date);
            Date start=DateUtility.getSqlDate(calendar.getTime())

            maxDay = calendar.getActualMaximum(Calendar.DAY_OF_MONTH);
            calendar.set(year, dec, maxDay);
            Date end=DateUtility.getSqlDate(calendar.getTime())

            long serviceId = Long.parseLong(result.serviceId.toString())
            String type = result.type
            if(type.equals("Mission")){
                List lstVal = buildMissionList(serviceId)
                result.put("mission", lstVal)
            }else if(type.equals("Goals")){
                List<PmGoals> lstGoals = PmGoals.findAllByServiceIdAndYear(serviceId,year)
                result.put(LIST, lstGoals)
                return result
            }else if(type.equals("Actions")){
                List<GroovyRowResult> lstAction = buildActionsList(serviceId,start,end)
                result.put(LIST, lstAction)
                return result
            }else if(type.equals("Details")){
                long actionsId = Long.parseLong(result."filter[filters][0][value]")
                List<GroovyRowResult> lstSprint = buildActionDetails(serviceId,actionsId, start, end)
                result.put(LIST, lstSprint)
                return result
            }else if(type.equals("IndicatorDetails")){
                long actionsId = Long.parseLong(result.actionsId.toString())
                long indicatorId = Long.parseLong(result."filter[filters][0][value]")
                List<GroovyRowResult> lstSprint = buildIndicatorDetails(serviceId,actionsId,indicatorId, start, end)
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
        (SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_service_sector WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.support_department,','))>0 ) supportDepartmentStr,
        (SELECT GROUP_CONCAT(short_name SEPARATOR ', ') FROM pm_projects WHERE LOCATE(CONCAT(',',id,',') ,CONCAT(',',a.source_of_fund,', '))>0 ) sourceOfFundStr

                FROM pm_actions a
                LEFT JOIN pm_service_sector sc ON sc.id = a.service_id
                WHERE a.service_id = ${serviceId}
                AND ('${start}' <= a.end AND '${end}' >= a.start)
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
    private List<GroovyRowResult> buildActionDetails(long serviceId,long actionsId, Date start, Date end) {
        String query = """
                SELECT a.id,i.id AS ind_id,idd.id AS ind_details_id,i.indicator,i.remarks,i.target,
                SUM(idd.achievement) total_achievement
                FROM pm_actions a
                LEFT JOIN pm_actions_indicator i ON i.actions_id = a.id
                LEFT JOIN pm_actions_indicator_details idd ON idd.indicator_id = i.id
                WHERE a.id = ${actionsId}
                GROUP BY i.id
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
    private List<GroovyRowResult> buildIndicatorDetails(long serviceId,long actionsId,long indicatorId, Date start, Date end) {
        String query = """
                SELECT a.id,idd.id AS ind_details_id,i.indicator,i.remarks,i.target,
                SUM(idd.achievement) total_achievement
                FROM pm_actions a
                LEFT JOIN pm_actions_indicator i ON i.actions_id = a.id
                LEFT JOIN pm_actions_indicator_details idd ON idd.indicator_id = i.id
                WHERE a.id = ${actionsId}
                GROUP BY i.id
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
}
