package actions.pmMcrsLog

import com.pms.PmMcrsLog
import com.pms.PmServiceSector
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class SubmitPmMcrsLogActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "MCRS has been submitted successfully"
    private static final String PM_MCRS_LOG = "pmMcrsLog"

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
                sendMail(sc.departmentHead,sc.contactEmail)
            }else{
                sendMail2(sc.departmentHead,sc.contactEmail)
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
    private String sendMail(String user,String email) {
        String body = """
        <div>
            <p>
                Dear ${user}, <br/>
                Greetings!
            </p>
            <p>
                Thank you very much for submitting MCRS.
            </p>
            <p>
                Regards,<br/>
                 Friendship SP Team</b>
            </p>
            <i>This is an auto-generated email, which does not need reply.<br/></i>
            </div>
        """
        Thread trd = new Thread() {
            public void run() {
                mailService.sendMail {
                    to "${email}"
                    from "support.mis@friendship-bd.org"
                    subject "MCRS submission"
                    html (body)
                }
            }
        }.start();
        return null
    }
    private String sendMail2(String user,String email) {
        String body = """
        <div>
            <p>
                Dear ${user}, <br/>
                Greetings!
            </p>
            <p>
                Thank you very much for submitting MCRS.</br>
                We will appreciate if you submit your MCRS before deadline.
            </p>
            <p>
                Regards,<br/>
                 Friendship SP Team</b>
            </p>
            <i>This is an auto-generated email, which does not need reply.<br/></i>
            </div>
        """
        Thread trd = new Thread() {
            public void run() {
                mailService.sendMail {
                    to "${email}"
                    from "sp.notification@friendship-bd.org"
                    subject "MCRS submission"
                    html (body)
                }
            }
        }.start();
        return null
    }
}
