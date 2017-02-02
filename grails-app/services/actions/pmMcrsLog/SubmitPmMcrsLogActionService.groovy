package actions.pmMcrsLog

import com.pms.PmMcrsLog
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

}
