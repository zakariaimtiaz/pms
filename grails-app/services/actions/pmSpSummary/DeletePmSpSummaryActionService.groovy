package actions.pmSpSummary

import com.pms.PmSpLog
import com.pms.PmSpSummary
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class DeletePmSpSummaryActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Summary has been deleted successfully"
    private static final String NOT_FOUND = "Selected summary does not exits"
    private static final String NOT_POSSIBLE = "Selected summary could not be deleted"
    private static final String PM_SP_SUMMARY = "pmSpSummary"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id.toString())
        PmSpSummary summary = PmSpSummary.read(id)
        if(!summary){
            return super.setError(params, NOT_FOUND)
        }
        PmSpLog log = PmSpLog.findByServiceIdAndYear(summary.serviceId,summary.year)
        if(!log.isEditable){
            return super.setError(params, NOT_POSSIBLE)
        }
        params.put(PM_SP_SUMMARY, summary)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmSpSummary summary = (PmSpSummary) result.get(PM_SP_SUMMARY)
            summary.delete()
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
