package actions.edDashboard

import com.pms.EdDashboard
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class UpdateEdDashboardActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Advice has been saved successfully"

    private Logger log = Logger.getLogger(getClass())



    @Transactional
    public Map executePreCondition(Map params) {
        try {
            String idStr = params.get("models[0][ID]")
            String adviceStr = params.get("models[0][ADVICE]")
            if (!idStr && !adviceStr) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            EdDashboard dashboard = EdDashboard.read(Long.parseLong(idStr))
            dashboard.edAdvice = adviceStr
            dashboard.save()

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
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
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
}
