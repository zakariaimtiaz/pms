package actions.pmSpLog

import com.model.ListPmSpLogActionServiceModel
import com.pms.PmSpLog
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class CreatePmSpLogActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "SP Log has been saved successfully"
    private static final String ALREADY_EXIST = "CSU/Sector for this year already exist"
    private static final String PM_SP_LOG = "pmSpLog"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId&&!params.year) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())
            int year = Integer.parseInt(params.year.toString())
            int count = PmSpLog.countByServiceIdAndYear(serviceId,year)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            PmSpLog spLog = buildObject(params,serviceId,year)
            params.put(PM_SP_LOG, spLog)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmSpLog spLog = (PmSpLog) result.get(PM_SP_LOG)
            spLog.save()
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
        PmSpLog spLog = (PmSpLog) result.get(PM_SP_LOG)
        ListPmSpLogActionServiceModel model = ListPmSpLogActionServiceModel.read(spLog.id)
        result.put(PM_SP_LOG, model)
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

    private static PmSpLog buildObject(Map parameterMap,long serviceId,int year) {
        PmSpLog spLog = new PmSpLog(parameterMap)
        if(spLog.isSubmitted){
            spLog.submissionDate = DateUtility.getSqlDate(new Date())
        }
        spLog.serviceId = serviceId
        spLog.year = year
        return spLog
    }
}
