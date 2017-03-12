package actions.appMail

import com.pms.AppMail
import org.apache.log4j.Logger
import org.springframework.transaction.annotation.Transactional
import pms.ActionServiceIntf
import pms.BaseService

/**
 * Send mail
 * For details go through Use-Case doc named 'SendAppMailActionService'
 */
class SendAppMailActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String SUCCESS_MSG = "Mail has been sent successfully"
    private static final String APP_MAIL = "appMail"

    /**
     * 1. check validation
     * @param params - serialize parameters from UI
     * @return - same map of input-parameter containing isError(true/false)
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            // check validation
            String errMsg = checkValidation(params)
            if (errMsg) {
                return super.setError(params, errMsg)
            }
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * 1. send mail
     * 2. update mail object
     * This method is in transactional block and will roll back in case of any exception
     * @param result - parameter from pre-condition
     * @return - same map of input-parameter containing isError(true/false)
     */
    @Transactional
    public Map execute(Map result) {
        try {
            AppMail appMail = (AppMail) result.get(APP_MAIL)
            sendMail(appMail)
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * There is no postCondition, so return the same map as received
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * set success message
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        try {
            return super.setSuccess(result, SUCCESS_MSG)
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     * @param result - map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    /**
     * 1. check required parameter
     * 2. check mail object existence
     * @param params - serialized parameters from UI
     * @return - error message or null value
     */
    private String checkValidation(Map params) {
        // check required parameter
        if (!params.id) {
            return ERROR_FOR_INVALID_INPUT
        }
        long mailId = Long.parseLong(params.id.toString())
        AppMail mail = appMailService.read(mailId)
        // check mail object existence
        if (!mail) {
            return ENTITY_NOT_FOUND_ERROR_MESSAGE
        }
        params.put(APP_MAIL, mail)
        return null
    }

    /**
     * Send mail
     * @param appMail - object of AppMail
     */
    private void sendMail(AppMail appMail) {
/*        Company company = companyService.read(appMail.companyId)
        appMail.setSmtpConfig(company)
        appMail.emailFrom = appMail.displayName
        List<GroovyRowResult> lstUser = getUserNameAndEmailAddress(appMail.roleIds)
        String body = appMail.body
        if (lstUser.size() > 0) {
            for (int i = 0; i < lstUser.size(); i++) {
                appMail.body = body
                appMail.recipients = lstUser[i][0].toString()
                Map paramsBody = [
                        userName: lstUser[i][1].toString()
                ]
                appMail.evaluateMailBody(paramsBody)
                appMailService.sendMail(appMail)
            }
        }*/
    }
}
