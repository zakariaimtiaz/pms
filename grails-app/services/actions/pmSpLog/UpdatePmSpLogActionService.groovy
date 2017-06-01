package actions.pmSpLog

import com.model.ListPmSpLogActionServiceModel
import com.pms.PmMcrsLog
import com.pms.PmMcrsLogDetails
import com.pms.PmSpLog
import com.pms.PmSpLogDetails
import com.pms.SpTimeSchedule
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility
import service.PmActionsService

@Transactional
class UpdatePmSpLogActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "SP Log has been updated successfully"
    private static final String ALREADY_EXIST = "CSU/Sector for this year already exist"
    private static final String SP_LOG_OBJ = "pmSpLog"
    private static final String OLD_OBJ = "oldObject"

    PmActionsService pmActionsService

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.serviceId) || (!params.year)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            long serviceId = Long.parseLong(params.serviceId.toString())
            int year = Integer.parseInt(params.year.toString())
            int count = PmSpLog.countByServiceIdAndYearAndIdNotEqual(serviceId, year, id)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }

            PmSpLog oldObject = PmSpLog.read(id)
            PmSpLog referred = new PmSpLog()
            referred.isEditable = oldObject.isEditable
            referred.isSubmitted = oldObject.isSubmitted
            params.put(OLD_OBJ, referred)

            PmSpLog spLog = buildObject(params, oldObject)
            params.put(SP_LOG_OBJ, spLog)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmSpLog oldObject = (PmSpLog) result.get(OLD_OBJ)
            PmSpLog spLog = (PmSpLog) result.get(SP_LOG_OBJ)

            if (spLog.isEditable && spLog.isEditable != oldObject.isEditable) {
                /// set backup actions code here
                pmActionsService.sapDetailsBackup(spLog.serviceId, spLog.year)

                String query = """
                 UPDATE pm_actions SET is_editable = TRUE WHERE service_id = ${spLog.serviceId} AND year = ${spLog.year}
                """
                boolean executed = executeUpdateSql(query)

                PmSpLogDetails previousObject = PmSpLogDetails.findByLogIdAndIsCurrent(spLog.id, Boolean.TRUE)
                if (previousObject) {
                    previousObject.isCurrent = Boolean.FALSE
                    previousObject.save()
                }

                PmSpLogDetails details = new PmSpLogDetails()
                details.logId = spLog.id
                details.editableOn = DateUtility.getSqlDate(new Date())
                details.isCurrent = Boolean.TRUE
                details.save()

                spLog.isSubmitted = Boolean.FALSE
                spLog.submissionDate = null
            }
            if (spLog.isSubmitted && spLog.isSubmitted != oldObject.isSubmitted) {
                PmSpLogDetails details = PmSpLogDetails.findByLogIdAndIsCurrent(spLog.id, Boolean.TRUE)
                details.submittedOn = DateUtility.getSqlDate(new Date())
                details.save()

                String query = """
                 UPDATE pm_actions SET is_editable = FALSE WHERE service_id = ${spLog.serviceId} AND year = ${spLog.year}
                """
                boolean executed = executeUpdateSql(query)
            }

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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        PmSpLog spLog = (PmSpLog) result.get(SP_LOG_OBJ)
        ListPmSpLogActionServiceModel model = ListPmSpLogActionServiceModel.read(spLog.id)
        result.put(SP_LOG_OBJ, model)
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

    private static PmSpLog buildObject(Map parameterMap, PmSpLog oldObject) {
        PmSpLog spLog = new PmSpLog(parameterMap)
        oldObject.serviceId = spLog.serviceId
        oldObject.year = spLog.year
        if (!oldObject.isSubmitted && spLog.isSubmitted) {
            oldObject.submissionDate = DateUtility.getSqlDate(new Date())
        }
        oldObject.isSubmitted = spLog.isSubmitted
        oldObject.isEditable = spLog.isEditable
        return oldObject
    }
}
