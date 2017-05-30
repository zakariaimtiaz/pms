package actions.pmSpLog

import com.pms.PmSpLog
import com.pms.PmSpLogDetails
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class SubmitPmSpLogActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String SUCCESS_MESSAGE = "SP Log has been submitted successfully"
    private static final String NOT_FOUND = "Selected log does not exits"
    private static final String SP_LOG_OBJ = "pmSpLog"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id.toString())
        PmSpLog spLog = PmSpLog.read(id)
        if(!spLog){
            return super.setError(params, NOT_FOUND)
        }
        params.put(SP_LOG_OBJ, spLog)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmSpLog spLog = (PmSpLog) result.get(SP_LOG_OBJ)
            spLog.isSubmitted = Boolean.TRUE
            spLog.submissionDate = DateUtility.getSqlDate(new Date())
            spLog.isEditable = Boolean.FALSE
            spLog.save()

            PmSpLogDetails details = PmSpLogDetails.findByLogIdAndIsCurrent(spLog.id,Boolean.TRUE)
            if(details){
                details.submittedOn = spLog.submissionDate
                details.save()
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
        return super.setSuccess(result, SUCCESS_MESSAGE)
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
