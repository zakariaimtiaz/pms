package actions.pmActions

import com.model.ListPmActionsActionServiceModel
import com.pms.PmActions
import com.pms.PmGoals
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class UpdatePmActionsActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Action has been updated successfully"
    private static final String WEIGHT_EXCEED = "Exceed weight measurement"
    private static final String ACTIONS_OBJ = "pmAction"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.id &&!params.serviceId && !params.goalId && !params.actions) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            long goalId = Long.parseLong(params.goalId.toString())
            int weight = Long.parseLong(params.weight.toString())
            int totalWeight = 0
            List tmp = PmActions.executeQuery("SELECT SUM(weight) FROM PmActions WHERE goalId=${goalId} AND id<>${id}")
            if(tmp[0]) totalWeight =(int) tmp[0]
            int available = 100-totalWeight
            if(weight>available){
                return super.setError(params, WEIGHT_EXCEED)
            }
            PmActions oldObject = (PmActions) PmActions.read(id)
            PmActions actions = buildObject(params, oldObject)
            params.put(ACTIONS_OBJ, actions)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmActions actions = (PmActions) result.get(ACTIONS_OBJ)
            actions.save()
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
        PmActions actions = (PmActions) result.get(ACTIONS_OBJ)
        ListPmActionsActionServiceModel model = ListPmActionsActionServiceModel.read(actions.id)
        result.put(ACTIONS_OBJ, model)
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

    private static PmActions buildObject(Map params, PmActions oldObject) {
        long serviceId = Long.parseLong(params.serviceId.toString())
        long goalId = Long.parseLong(params.goalId.toString())
        long resPersonId = Long.parseLong(params.resPersonId.toString())

        String startDateStr = params.start.toString()
        String endDateStr = params.end.toString()
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

        Date start = originalFormat.parse(startDateStr);
        Calendar c = Calendar.getInstance();
        c.setTime(start);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));

        Date end = originalFormat.parse(endDateStr);
        Calendar ce = Calendar.getInstance();
        ce.setTime(end);
        ce.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));

        List<PmActions> max = PmActions.executeQuery("SELECT COALESCE(MAX(tmpSeq),0) FROM PmActions" +
                " WHERE serviceId=${serviceId} AND goalId=${goalId}")

        int con =(int) max[0]+1
        PmGoals goals = PmGoals.read(goalId)

        params.start=DateUtility.getSqlDate(c.getTime())
        params.end=DateUtility.getSqlDate(ce.getTime())

        PmActions actions = new PmActions(params)
        oldObject.serviceId = serviceId
        oldObject.goalId = goalId
        oldObject.resPersonId = resPersonId
        oldObject.supportDepartment = actions.supportDepartment
        oldObject.resPerson = actions.resPerson
        oldObject.sequence = goals.sequence+"."+con
        oldObject.actions = actions.actions
        oldObject.weight = actions.weight
        oldObject.start = actions.start
        oldObject.end = actions.end
        oldObject.sourceOfFund = actions.sourceOfFund
        oldObject.target = actions.target
        oldObject.meaIndicator = actions.meaIndicator
        return oldObject
    }
}
