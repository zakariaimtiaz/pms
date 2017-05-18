package actions.pmMcrsLog

import com.model.ListPmMcrsLogActionServiceModel
import com.pms.PmMcrsLog
import com.pms.PmMcrsLogDetails
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.DateFormatSymbols
import java.text.SimpleDateFormat

@Transactional
class UpdatePmMcrsLogActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "MCRS Log has been updated successfully"
    private static final String MCRS_LOG_OBJ = "pmMcrsLog"
    private static final String OLD_OBJ = "oldObject"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.id) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            PmMcrsLog oldObject = PmMcrsLog.read(id)

            PmMcrsLog referred = new PmMcrsLog()
            referred.isEditable = oldObject.isEditable
            referred.isEditableDb = oldObject.isEditableDb
            params.put(OLD_OBJ, referred)

            PmMcrsLog pmMcrsLog = buildObject(params, oldObject)
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
            PmMcrsLog oldObject = (PmMcrsLog) result.get(OLD_OBJ)
            PmMcrsLog pmMcrsLog = (PmMcrsLog) result.get(MCRS_LOG_OBJ)

            if (pmMcrsLog.isEditable && pmMcrsLog.isEditable != oldObject.isEditable) {
                PmMcrsLogDetails previousObject = PmMcrsLogDetails.findByLogIdAndLogTypeIdAndIsCurrent(pmMcrsLog.id, 1L, Boolean.TRUE)
                if(previousObject){
                    previousObject.isCurrent = Boolean.FALSE
                    previousObject.save()
                }

                PmMcrsLogDetails details = new PmMcrsLogDetails()
                details.logId = pmMcrsLog.id
                details.logTypeId = 1L
                details.editableOn = DateUtility.getSqlDate(new Date())
                details.isCurrent = Boolean.TRUE
                details.save()

                pmMcrsLog.isSubmitted = Boolean.FALSE
                pmMcrsLog.submissionDate = null
            }
            if (pmMcrsLog.isEditableDb && pmMcrsLog.isEditableDb != oldObject.isEditableDb) {
                PmMcrsLogDetails previousObject = PmMcrsLogDetails.findByLogIdAndLogTypeIdAndIsCurrent(pmMcrsLog.id, 2L, Boolean.TRUE)
                if(previousObject){
                    previousObject.isCurrent = Boolean.FALSE
                    previousObject.save()
                }

                PmMcrsLogDetails details = new PmMcrsLogDetails()
                details.logId = pmMcrsLog.id
                details.logTypeId = 2L
                details.editableOn = DateUtility.getSqlDate(new Date())
                details.isCurrent = Boolean.TRUE
                details.save()

                pmMcrsLog.isSubmittedDb = Boolean.FALSE
                pmMcrsLog.submissionDateDb = null
            }

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

    private PmMcrsLog buildObject(Map params, PmMcrsLog oldObject) {
        PmMcrsLog pmMcrsLog = new PmMcrsLog(params)
        oldObject.isEditable = pmMcrsLog.isEditable
        oldObject.isEditableDb = pmMcrsLog.isEditableDb
        return oldObject
    }
}
