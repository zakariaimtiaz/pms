package actions.pmActions

import com.pms.PmActionsIndicatorDetails
import com.pms.PmMcrsLog
import com.pms.SecUser
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class UpdateMRPActionService extends BaseService implements ActionServiceIntf {

    private static final String COULD_NOT_BE_EMPTY = "Remarks is mandatory for Repeatable% indicator"
    private static final String UPDATE_SUCCESS_MESSAGE = "Achievement has been updated successfully"
    private static final String MRP_LOCKED_MSG = "MRP is locked for this month"
    private static final String MRP_SUBMITTED_MSG = "MRP already submitted"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            String indicatorType = params.get("models[0][indicator_type]")
            String detailsIdStr = params.get("models[0][ind_details_id]")
            String achievementStr = params.get("models[0][achievement]")
            String remarksStr = params.get("models[0][remarks]")

            if((indicatorType.equals("Repeatable%")||indicatorType.equals("Repeatable%++")) && remarksStr==''){
                return super.setError(params, COULD_NOT_BE_EMPTY)
            }

            if (!detailsIdStr && !achievementStr) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            if(detailsIdStr) {
                long id = Long.parseLong(detailsIdStr)
                PmActionsIndicatorDetails details = PmActionsIndicatorDetails.read(id)
                SecUser user = currentUserObject()
                PmMcrsLog pmMcrsLog = PmMcrsLog.findByServiceIdAndMonthStrIlike(user.serviceId, details.monthName)
                if(!pmMcrsLog.isEditable){
                    return super.setError(params, MRP_LOCKED_MSG)
                }
                if(pmMcrsLog.isSubmitted){
                    return super.setError(params, MRP_SUBMITTED_MSG)
                }
                details.remarks = remarksStr
                if (!achievementStr.isEmpty())
                    details.achievement = Integer.parseInt(achievementStr)
                else
                    details.achievement = 0
                details.save()
            }
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    public Map execute(Map result) {
        return result
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
}
