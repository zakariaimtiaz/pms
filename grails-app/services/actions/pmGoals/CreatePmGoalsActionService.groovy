package actions.pmGoals

import com.model.ListPmGoalsActionServiceModel
import com.pms.PmGoals
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class CreatePmGoalsActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Goal has been saved successfully"
    private static final String ALREADY_EXIST = "Sequence already exist"
    private static final String GOAL_OBJECT = "pmGoal"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId&&!params.goal) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())
            int count = PmGoals.countByServiceIdAndSequence(serviceId,params.sequence)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            PmGoals goals = buildObject(params,serviceId)
            params.put(GOAL_OBJECT, goals)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmGoals goals = (PmGoals) result.get(GOAL_OBJECT)
            goals.save()
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     *
     * @param result - map received from execute method
     * @return - map
     */
    public Map executePostCondition(Map result) {
        return result
    }
    /**
     *
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        PmGoals goals = (PmGoals) result.get(GOAL_OBJECT)
        ListPmGoalsActionServiceModel model = ListPmGoalsActionServiceModel.read(goals.id)
        result.put(GOAL_OBJECT, model)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }
    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private static PmGoals buildObject(Map parameterMap,long serviceId) {
        List<PmGoals> max = PmGoals.executeQuery("SELECT COALESCE(MAX(sequence),0) FROM PmGoals WHERE serviceId=${serviceId}")
        PmGoals goals = new PmGoals(parameterMap)
        goals.serviceId = serviceId
        goals.sequence = max[0]+1
        goals.year = 2017
        return goals
    }
}
