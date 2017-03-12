package actions.appMail

import com.pms.AppMail
import org.apache.log4j.Logger
import org.springframework.transaction.annotation.Transactional
import pms.ActionServiceIntf
import pms.BaseService

class TestAppMailActionService extends BaseService implements ActionServiceIntf {
    def mailService

    private Logger log = Logger.getLogger(getClass())

    private static final String UNABLE_TO_SEND = "Unable to sent mail"
    private static final String MAIL_TEMPLATE_NOT_FOUND = "Mail template not found"
    private static final String MAIL_SENDING_SUCCESS = "Mail sent successfully"

    public Map executePreCondition(Map params) {
        try {
            if (!params.transactionCode) {
                return super.setError(params, UNABLE_TO_SEND)
            }
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            AppMail appMail = AppMail.findByTransactionCodeAndIsActive(result.transactionCode.toString(), true)
            if (!appMail) {
                return super.setError(result, MAIL_TEMPLATE_NOT_FOUND)
            }
            if (appMail.subject == null && appMail.body == null) {
                return super.setError(result, UNABLE_TO_SEND)
            }
            if (appMail.isManualSend && appMail.isRequiredRecipients) {
                if (appMail.recipients == null) {
                    return super.setError(result, UNABLE_TO_SEND)
                }
                String recipients = appMail.recipients
                String[] recipientList = recipients.split(",");
                String subjectStr = """${appMail.subject}"""
                String mailBody = """${appMail.body}"""

                Thread trd = new Thread() {
                    public void run() {
                        for (String recipient : recipientList) {
                            mailService.sendMail {
                                to "${recipient}"
                                from "sp.notification@friendship-bd.org"
                                subject "${subjectStr}"
                                html(mailBody)
                            }
                        }
                    }
                }.start();
            }
            if(appMail.isManualSend && appMail.isRequiredRoleIds){
                if (appMail.roleIds == null) {
                    return super.setError(result, UNABLE_TO_SEND)
                }
                String roleIds = appMail.roleIds
                String[] roleList = roleIds.split(",");
                for (String role : roleList) {

                }
            }
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
            return super.setSuccess(result, MAIL_SENDING_SUCCESS)
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     *
     * @param result - receive from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
