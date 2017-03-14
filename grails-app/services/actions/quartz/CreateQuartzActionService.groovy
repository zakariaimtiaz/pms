package actions.quartz

import com.model.ListQuartzActionServiceModel
import com.pms.Quartz
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class CreateQuartzActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Trigger has been saved successfully"
    private static final String ALREADY_EXIST = "Same trigger already exist"
    private static final String QUARTZ = "quartz"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.jobName &&!params.triggerName && !params.cronExpression) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int count = Quartz.countByTriggerNameIlike(params.triggerName.toString())
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            Quartz quartz = buildObject(params)
            params.put(QUARTZ, quartz)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            Quartz quartz = (Quartz) result.get(QUARTZ)
            quartz.save()
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
        Quartz quartz = (Quartz) result.get(QUARTZ)
        ListQuartzActionServiceModel model = ListQuartzActionServiceModel.read(quartz.id)
        result.put(QUARTZ, model)
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

    private Quartz buildObject(Map parameterMap) {
        Quartz quartz = new Quartz(parameterMap)
        return quartz
    }
}
