package actions.pmMcrsLog

import com.model.ListPmMcrsLogActionServiceModel
import com.pms.PmMcrsLog
import com.pms.PmMcrsLog
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class UpdatePmMcrsLogActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "MCRS has been updated successfully"
    private static final String MCRS_LOG_OBJ = "pmMcrsLog"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.id)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            
            PmMcrsLog oldObject = PmMcrsLog.read(id)
            PmMcrsLog pmMcrsLog = buildObject(params,oldObject)
            params.put(MCRS_LOG_OBJ, pmMcrsLog)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmMcrsLog pmMcrsLog = (PmMcrsLog) result.get(MCRS_LOG_OBJ)
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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        PmMcrsLog pmMcrsLog = (PmMcrsLog) result.get(MCRS_LOG_OBJ)
        ListPmMcrsLogActionServiceModel model = ListPmMcrsLogActionServiceModel.read(pmMcrsLog.id)
        result.put(MCRS_LOG_OBJ, model)
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

    private static PmMcrsLog buildObject(Map parameterMap,PmMcrsLog oldObject) {
        PmMcrsLog pmMcrsLog = new PmMcrsLog()

        oldObject.isSubmitted = false
        oldObject.isEditable = true
        return oldObject
    }
}
