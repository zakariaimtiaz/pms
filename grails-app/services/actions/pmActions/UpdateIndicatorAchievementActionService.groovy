package actions.pmActions

import com.pms.PmActionsIndicatorDetails
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class UpdateIndicatorAchievementActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Achievement has been updated successfully"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            String detailsIdStr = params.get("models[0][ind_details_id]")
            String achievementStr = params.get("models[0][achievement]")
            String remarksStr = params.get("models[0][remarks]")

            if (!detailsIdStr && !achievementStr) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            if(detailsIdStr){
                long id = Long.parseLong(detailsIdStr)
                PmActionsIndicatorDetails details = PmActionsIndicatorDetails.read(id)
                details.remarks = remarksStr
                details.achievement = Integer.parseInt(achievementStr)
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
