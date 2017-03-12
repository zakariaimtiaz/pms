package actions.appMail

import com.pms.AppMail
import org.springframework.transaction.annotation.Transactional
import pms.ActionServiceIntf
import pms.BaseService

class DeleteAppMailActionService extends BaseService implements ActionServiceIntf {

    private static final String DELETE_SUCCESS_MESSAGE = "Template has been deleted successfully"
    private static final String NOT_FOUND = "Template does not exits"
    private static final String APP_MAIL = "appMail"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long userId = Long.parseLong(params.id)
        AppMail appMail = AppMail.read(userId)
        if(!appMail){
            return super.setError(params, NOT_FOUND)
        }
        params.put(APP_MAIL, appMail)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            AppMail appMail = (AppMail) result.get(APP_MAIL)
            appMail.delete()
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
