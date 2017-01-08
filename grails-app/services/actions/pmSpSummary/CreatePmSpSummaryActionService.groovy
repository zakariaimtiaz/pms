package actions.pmSpSummary

import com.model.ListPmSpSummaryActionServiceModel
import com.pms.PmSpSummary
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

class CreatePmSpSummaryActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Summary has been saved successfully"
    private static final String ALREADY_EXIST = "Summary already exist for this year"
    private static final String PM_SP_SUMMARY = "pmSpSummary"

    private Logger log = Logger.getLogger(getClass())

    /**
     * 1. input validation check
     * 2. duplicate check for role-name
     * @param params - receive role object from controller
     * @return - map.
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.summary && !params.year) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = currentUserObject().serviceId
            int year = Integer.parseInt(params.year.toString())
            int count = PmSpSummary.countByServiceIdAndYear(serviceId,year)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            PmSpSummary summary = buildObject(params,serviceId)
            params.put(PM_SP_SUMMARY, summary)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     * 1. receive role object from pre execute method
     * 2. create new role
     * This method is in transactional block and will roll back in case of any exception
     * @param result - map received from pre execute method
     * @return - map.
     */
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
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
/*        PmSpSummary summary = (PmSpSummary) result.get(PM_SP_SUMMARY)
        ListPmSpSummaryActionServiceModel model = ListPmSpSummaryActionServiceModel.read(summary.id)
        result.put(PM_SP_SUMMARY, model)*/
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

    private PmSpSummary buildObject(Map parameterMap, long serviceId) {
        PmSpSummary summary = new PmSpSummary(parameterMap)
        summary.serviceId = serviceId
        summary.createdOn = new Date()
        return summary
    }
}
