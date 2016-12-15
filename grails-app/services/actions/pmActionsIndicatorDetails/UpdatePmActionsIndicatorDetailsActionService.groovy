package actions.pmActionsIndicatorDetails

import com.model.ListPmActionsActionServiceModel
import com.pms.PmActionsIndicatorDetails
import com.pms.PmActionsIndicatorDetails
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class UpdatePmActionsIndicatorDetailsActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Action has been updated successfully"
    private static final String MODEL_OBJ = "pmMonthlyIndicator"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.indicatorIdModal) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            Long indicatorId = Long.parseLong(result.indicatorIdModal)
            List<PmActionsIndicatorDetails> details = PmActionsIndicatorDetails.findAllByIndicatorId(indicatorId)
            Integer count = Integer.parseInt(result.monthCount)
            for(int i=0;i<details.size();i++) {
                (1..count)?.each { item ->
                    def monthName = 'month' + item
                    def targetName = 'tempTr' + item
                    String mName = result?.get(monthName)
                    if (details[i].monthName == mName) {
                        String target = result?.get(targetName)
                        try {
                            details[i].target = Double?.parseDouble(target)
                        } catch (ex) {
                            details[i].target = 0
                        }

                        details[i].save()
                    }
                }
            }
            result.indicatorIdModal=indicatorId
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
        result.put("indicatorId", result.indicatorIdModal)
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
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
