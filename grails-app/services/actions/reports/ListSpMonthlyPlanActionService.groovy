package actions.reports

import com.pms.*
import grails.transaction.Transactional
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
            c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
            Date start=DateUtility.getSqlDate(c.getTime())

            c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
            Date end=DateUtility.getSqlDate(c.getTime())

            long serviceId = Long.parseLong(result.serviceId.toString())
            String type = result.type
            List<Map> lstVal = []
            if(type.equals("Mission")){
                lstVal = buildMissionList(serviceId)
            }else if(type.equals("Goals")){
                lstVal = buildGoalsList(serviceId)
            }else if(type.equals("Objectives")){
                lstVal = buildObjectivesList(serviceId)
            }else if(type.equals("Actions")){
                lstVal = buildActionsList(serviceId,start,end)
            }else if(type.equals("Sprints")){
                lstVal = buildSprintList(serviceId)
            }
            result.put(LIST, lstVal)
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

    private List<Map> buildMissionList(long serviceId) {
        List<Map> result = []
        PmMissions mission = PmMissions.findByServiceId(serviceId)
        Map obj = [
                mission: mission.mission
        ]
        result << obj
        return result
    }
    private List<Map> buildGoalsList(long serviceId) {
        List<Map> result = []
        List<PmGoals> lstGoals = PmGoals.findAllByServiceId(serviceId)
        for (int i = 0; i < lstGoals.size(); i++) {
            Map obj = [
                    sl: lstGoals[i].sequence,
                    goal: lstGoals[i].goal
            ]
            result << obj
        }
        return result
    }
    private List<Map> buildObjectivesList(long serviceId) {
        List<Map> result = []
        List<PmObjectives> lstObj = PmObjectives.findAllByServiceId(serviceId)
        for (int i = 0; i < lstObj.size(); i++) {
            Map obj = [
                    sl: lstObj[i].sequence,
                    objective: lstObj[i].objective,
                    weight: lstObj[i].weight + ' %'
            ]
            result << obj
        }
        return result
    }
    private List<Map> buildActionsList(long serviceId, Date start, Date end) {
        List<Map> result = []
        List<PmActions> lstActions = PmActions.findAllByServiceIdAndStartBetween(serviceId,start,end)

        for (int i = 0; i < lstActions.size(); i++) {
            String startStr = new SimpleDateFormat("MMMMM").format(lstActions[i].start.getTime())
            String endStr = new SimpleDateFormat("MMMMM").format(lstActions[i].end.getTime())

            Map obj = [
                    sl: lstActions[i].sequence,
                    action: lstActions[i].actions,
                    startDate: startStr,
                    endDate: endStr,
                    weight: lstActions[i].weight + ' %',
                    meaIndicator: lstActions[i].meaIndicator?:'',
                    target: lstActions[i].target?:'',
                    supportDepartment: lstActions[i].supportDepartment?:'',
                    resPerson: lstActions[i].resPerson?:''
            ]
            result << obj
        }
        return result
    }
    private List<Map> buildSprintList(long serviceId) {
        List<Map> result = []
        List<PmSprints> lstSprint = PmSprints.list()
        for (int i = 0; i < lstSprint.size(); i++) {
            Map obj = [
                    sl:lstSprint[i].sequence,
                    sprint: lstSprint[i].sprints
            ]
            result << obj
        }
        return result
    }
}
