package actions.reports

import com.pms.PmGoals
import com.pms.PmMissions
import com.pms.PmObjectives
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
                List<PmGoals> lstGoals = PmGoals.findAllByServiceId(serviceId)
                result.put(LIST, lstGoals)
                return result
            }else if(type.equals("Objectives")){
                long goalId = Long.parseLong(result."filter[filters][0][value]")
                List<PmObjectives> lstObj = PmObjectives.findAllByServiceIdAndGoalId(serviceId,goalId)
                result.put(LIST, lstObj)
                return result
            }else if(type.equals("Actions")){
                long goalId = Long.parseLong(result.goalId.toString())
                long objId = Long.parseLong(result."filter[filters][0][value]")
                List<GroovyRowResult> lstAction = buildActionsList(serviceId,goalId,objId,start,end)
                result.put(LIST, lstAction)
                return result
            }else if(type.equals("Sprints")){
                long goalId = Long.parseLong(result.goalId.toString())
                long objId = Long.parseLong(result.objectiveId.toString())
                long actionsId = Long.parseLong(result."filter[filters][0][value]")
                List<GroovyRowResult> lstSprint = buildSprintList(serviceId,goalId,objId,actionsId, start, end)
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

    private List<GroovyRowResult> buildActionsList(long serviceId,long goalId,long objId, Date start, Date end) {
        String query = """
                SELECT id,service_id AS serviceId,goal_id AS goalId,objective_id AS objectiveId,start,end,sequence,tmp_seq AS tmpSeq,
                        mea_indicator AS meaIndicator,target,actions,weight,res_person AS resPerson, remarks,
                        support_department AS supportDepartment,strategy_map_ref AS strategyMapRef,source_of_fund AS sourceOfFund
                FROM pm_actions
                WHERE service_id = ${serviceId} AND goal_id = ${goalId} AND objective_id = ${objId}
                AND ('${start}' <= end AND '${end}' >= start)
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
    private List<GroovyRowResult> buildSprintList(long serviceId,long goalId,long objId,long actionsId, Date start, Date end) {
        String query = """
                SELECT id,service_id AS serviceId,goal_id AS goalId,objective_id AS objectiveId,actions_id AS actionsId,
                        start_date AS startDate,end_date AS endDate,sequence,sprints,weight,tmp_seq AS tmpSeq,target,
                        support_department AS supportDepartment,res_person AS resPerson
                FROM pm_sprints
                WHERE service_id = ${serviceId} AND goal_id = ${goalId}
                 AND objective_id = ${objId} AND actions_id = ${actionsId}
                 AND ('${start}' <= end_date AND '${end}' >= start_date)
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
}
