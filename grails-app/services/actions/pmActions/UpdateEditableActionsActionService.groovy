package actions.pmActions

import com.pms.PmActions
import com.pms.PmActionsChangeHistory
import com.pms.PmSpLog
import com.pms.PmSpLogDetails
import com.pms.SpTimeSchedule
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class UpdateEditableActionsActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Action state change successfully"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            boolean state = Boolean.parseBoolean(params.state.toString())
            SpTimeSchedule timeSchedule = SpTimeSchedule.findByIsActive(Boolean.TRUE)
            int year = Integer.parseInt(timeSchedule.activeYear)
            if (params.containsKey("actionId")) {
                long id = Long.parseLong(params.actionId.toString())
                PmActions actions = PmActions.get(id)
                actions.isEditable = state
                actions.save()

                if (actions.isEditable) {
                    PmSpLog log = PmSpLog.findByServiceIdAndYear(actions.serviceId, year)
                    PmSpLogDetails details = PmSpLogDetails.findByLogId(log.id)
                    PmActionsChangeHistory history = new PmActionsChangeHistory()
                    history.serviceId = actions.serviceId
                    history.actionsId = actions.id
                    history.actionSequence = actions.sequence
                    history.spLogDetailsId = details.id
                    history.save()
                }
            } else {
                long serviceId = Long.parseLong(params.serviceId.toString())
                String query = """
                 UPDATE pm_actions SET is_editable = ${state} WHERE service_id = ${serviceId} AND year = ${year}
                """
                boolean executed = executeUpdateSql(query)
            }
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    public Map execute(Map result) {
        return result
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
}
