package actions.pmActionsIndicatorDetails

import com.model.ListPmActionsActionServiceModel
import com.pms.PmActions
import com.pms.PmActionsIndicatorDetails
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class CreatePmActionsIndicatorDetailsActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Data has been saved successfully"
    private static final String MODEL_OBJECT = "pmMonthlyIndicator"

    private Logger log = Logger.getLogger(getClass())


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            Long indicatorId = 0

            try {
                /*def maxValue = PmActionsIndicatorDetails.withCriteria {
                    projections {
                        max 'indicatorId'
                    }
                }
                */

               def maxValue = PmActionsIndicatorDetails.executeQuery("select COALESCE(MAX(indicatorId),0) from PmActionsIndicatorDetails")
                indicatorId = maxValue[0] + 1
            }catch (ex){
                indicatorId = 1
            }

            Integer count = Integer.parseInt(result.monthCount)
            (1..count)?.each{ item ->
                def monthName  = 'month'+item
                def targetName = 'tempTr'+item
                //println monthName+' : '+result?."${monthName}"
                //println monthName+' : '+result?.get(monthName)
                PmActionsIndicatorDetails details = new PmActionsIndicatorDetails()
                details.indicatorId               = indicatorId
                details.createBy                  = springSecurityService?.principal?.id
                details.createDate                = DateUtility.getSqlDate(new Date())
                details.monthName                 = result?.get(monthName)
                String target=result?.get(targetName)
                try {
                    details.target = Double?.parseDouble(target)
                }catch (ex) {
                    details.target = 0
                }

                details.save()

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
     * @param result - map received from executePost method
     * @return - map containing success message
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
    public Map buildFailureResultForUI(Map result) {
        return result
    }


}
