package actions.pmAdditionalActions

import com.pms.PmAdditionalActions
import com.pms.PmAdditionalActionsIndicator
import com.pms.PmActionsIndicatorDetails
import com.pms.PmGoals
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class DeletePmAdditionalActionsActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Action has been deleted successfully"
    private static final String ADDITIONAL_ACTION_OBJ = "pmAdditionalAction"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id.toString())
        PmAdditionalActions actions = PmAdditionalActions.read(id)
        if(!actions){
            return super.setError(params, ENTITY_NOT_FOUND_ERROR_MESSAGE)
        }
        params.put(ADDITIONAL_ACTION_OBJ, actions)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmAdditionalActions actions = (PmAdditionalActions) result.get(ADDITIONAL_ACTION_OBJ)

            List<PmAdditionalActions> lstPmAdditionalActions=PmAdditionalActions.findAllByGoalIdAndStartBetween(actions.goalId,actions.start,actions.end)
            PmGoals goals = PmGoals.read(actions.goalId)

            actions.delete()
            List<PmAdditionalActionsIndicator> lstPmAdditionalActionsIndicator=PmAdditionalActionsIndicator.findAllByActionsId(actions.id)
            for(PmAdditionalActionsIndicator pmActionsIndicator:lstPmAdditionalActionsIndicator){
                pmActionsIndicator.delete()
            }

            for(int i=actions.tmpSeq;i<lstPmAdditionalActions.size();i++) {
                PmAdditionalActions obj = lstPmAdditionalActions[i]
                obj.tmpSeq = i
                obj.sequence = goals.sequence + "." + obj.tmpSeq
                obj.save()
            }
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
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
     * 1. put success message
     *
     * @param result - map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, DELETE_SUCCESS_MESSAGE)
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     *
     * @param result - map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
