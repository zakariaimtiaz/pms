package actions.pmSpSummary

import com.pms.PmSpSummary
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class UpdatePmSpSummaryActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Summary has been updated successfully"
    private static final String ALREADY_EXIST = "Summary already exist for this year"
    private static final String PM_SP_SUMMARY = "pmSpSummary"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.id || !params.summary || !params.year) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int year = Integer.parseInt(params.year.toString())
            long id = Long.parseLong(params.id.toString())
            PmSpSummary oldObj = PmSpSummary.read(id)
            int count = PmSpSummary.countByServiceIdAndYearAndIdNotEqual(oldObj.serviceId,year, id)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            PmSpSummary summary = buildObject(params, oldObj)
            params.put(PM_SP_SUMMARY, summary)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmSpSummary summary = (PmSpSummary) result.get(PM_SP_SUMMARY)
            summary.save()
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


    private PmSpSummary buildObject(Map parameterMap, PmSpSummary oldObj) {
        PmSpSummary summary = new PmSpSummary(parameterMap)
        oldObj.summary = summary.summary
        oldObj.year = summary.year
        oldObj.lastUpdateOn = new Date()
        return oldObj
    }
}
