package actions.pmGoals

import com.model.ListPmGoalsActionServiceModel
import com.pms.PmGoals
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class UpdatePmGoalsActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Goal has been updated successfully"
    private static final String ALREADY_EXIST = "Sequence already exist"
    private static final String GOAL_OBJ = "pmGoal"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.serviceId) || (!params.goal)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            long serviceId = Long.parseLong(params.serviceId.toString())
            int count = PmGoals.countByServiceIdAndSequenceAndIdNotEqual(serviceId,params.sequence,id)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            PmGoals oldObject = PmGoals.read(id)
            PmGoals goals = buildObject(params,oldObject)
            params.put(GOAL_OBJ, goals)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmGoals goals = (PmGoals) result.get(GOAL_OBJ)
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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        PmGoals goals = (PmGoals) result.get(GOAL_OBJ)
        ListPmGoalsActionServiceModel model = ListPmGoalsActionServiceModel.read(goals.id)
        result.put(GOAL_OBJ, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static PmGoals buildObject(Map parameterMap,PmGoals oldObject) {
        PmGoals goals = new PmGoals(parameterMap)
        oldObject.goal = goals.goal
        return oldObject
    }
}
