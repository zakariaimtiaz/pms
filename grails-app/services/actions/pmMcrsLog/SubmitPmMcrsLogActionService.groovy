package actions.pmMcrsLog

import com.model.ListHrUserActionServiceModel
import com.pms.AppMail
import com.pms.PmMcrsLog
import com.pms.PmServiceSector
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class SubmitPmMcrsLogActionService extends BaseService implements ActionServiceIntf {

    def mailService

    private static final String SAVE_SUCCESS_MESSAGE = "MCRS has been submitted successfully"
    private static final String PM_MCRS_LOG = "pmMcrsLog"
    private static final String THANK_YOU_MAIL = "THANK_YOU_MAIL"
    private static final String THANK_YOU_MAIL_AFTER_DEADLINE = "THANK_YOU_MAIL_AFTER_DEADLINE"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            long id = Long.parseLong(params.id.toString())
            PmMcrsLog pmMcrsLog = PmMcrsLog.read(id)
            params.put(PM_MCRS_LOG, pmMcrsLog)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmMcrsLog pmMcrsLog = (PmMcrsLog) result.get(PM_MCRS_LOG)
            pmMcrsLog.isSubmitted = Boolean.TRUE
            pmMcrsLog.submissionDate = DateUtility.getSqlDate(new Date())
            pmMcrsLog.isEditable = Boolean.FALSE
            pmMcrsLog.save()
            /// send thank you mail
            PmServiceSector sc = PmServiceSector.read(pmMcrsLog.serviceId)
            if(pmMcrsLog.deadLine >= pmMcrsLog.submissionDate){
                AppMail appMail = AppMail.findByTransactionCodeAndIsActive(THANK_YOU_MAIL, true)
                if(appMail){
                    sendMail(sc.departmentHead,sc.contactEmail, THANK_YOU_MAIL,sc.departmentHeadGender)
                }
            }else{
                AppMail appMail2 = AppMail.findByTransactionCodeAndIsActive(THANK_YOU_MAIL_AFTER_DEADLINE, true)
                if(appMail2){
                    sendMail(sc.departmentHead,sc.contactEmail, THANK_YOU_MAIL_AFTER_DEADLINE,sc.departmentHeadGender)
                }
            }
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
    private String sendMail(String user,String email,String transactionCode, String genderStr) {
        AppMail appMail = AppMail.findByTransactionCodeAndIsActive(transactionCode, true)
        String subjectStr = """${appMail.subject}"""
        String mailBody = """${appMail.body}"""
        mailBody = mailBody?.replaceAll("__APP_USER__",user+SINGLE_SPACE+genderStr)

        Thread trd = new Thread() {
            public void run() {
                mailService.sendMail {
                    to "${email}"
                    from "sp.notification@friendship-bd.org"
                    subject "${subjectStr}"
                    html (mailBody)
                }
            }
        }.start();
        return null
    }
}
