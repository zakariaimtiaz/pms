package actions.pmActions

import com.pms.PmActions
import com.pms.PmActionsIndicator
import com.pms.PmActionsIndicatorDetails
import com.pms.PmGoals
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class DeletePmActionsActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Action has been deleted successfully"
    private static final String ACTIONS_OBJ = "pmAction"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id.toString())
        PmActions actions = PmActions.read(id)
        if(!actions){
            return super.setError(params, ENTITY_NOT_FOUND_ERROR_MESSAGE)
        }
        params.put(ACTIONS_OBJ, actions)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmActions actions = (PmActions) result.get(ACTIONS_OBJ)

            List<PmActions> lstPmActions=PmActions.findAllByGoalId(actions.goalId)
            PmGoals goals = PmGoals.read(actions.goalId)

            actions.delete()
            List<PmActionsIndicator> lstPmActionsIndicator=PmActionsIndicator.findAllByActionsId(actions.id)
            for(PmActionsIndicator pmActionsIndicator:lstPmActionsIndicator){
                pmActionsIndicator.delete()
            }
            List<PmActionsIndicatorDetails> lst=PmActionsIndicatorDetails.findAllByActionsId(actions.id)
            for(PmActionsIndicatorDetails pmActionsIndicatorDetails:lst){
                pmActionsIndicatorDetails.delete()
            }

            for(int i=actions.tmpSeq;i<lstPmActions.size();i++) {
                PmActions obj = lstPmActions[i]
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
