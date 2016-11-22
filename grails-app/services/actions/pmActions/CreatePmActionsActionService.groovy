package actions.pmActions

import com.model.ListPmActionsActionServiceModel
import com.pms.PmActions
import com.pms.PmGoals
import com.pms.PmObjectives
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class CreatePmActionsActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Actions has been saved successfully"
    private static final String WEIGHT_EXCEED = "Exceed weight measurement"
    private static final String ACTIONS_OBJECT = "pmAction"

    private Logger log = Logger.getLogger(getClass())


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId && !params.goalId &&!params.objectiveId && !params.actions) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())
            long goalId = Long.parseLong(params.goalId.toString())
            long objectiveId = Long.parseLong(params.objectiveId.toString())
            int weight = Long.parseLong(params.weight.toString())
            int totalWeight =(int) PmActions.executeQuery("select sum(weight) from PmActions where objectiveId=${objectiveId}")[0]
            int available = 100-totalWeight
            if(weight>available){
                return super.setError(params, WEIGHT_EXCEED)
            }
            PmActions actions = buildObject(params, serviceId, goalId, objectiveId)
            params.put(ACTIONS_OBJECT, actions)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmActions actions = (PmActions) result.get(ACTIONS_OBJECT)
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
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        PmActions actions = (PmActions) result.get(ACTIONS_OBJECT)
        ListPmActionsActionServiceModel model = ListPmActionsActionServiceModel.read(actions.id)
        result.put(ACTIONS_OBJECT, model)
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

    private static PmActions buildObject(Map parameterMap, long serviceId, long goalId, long objectiveId) {
        String startDateStr = parameterMap.start.toString()
        String endDateStr = parameterMap.end.toString()
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
                " WHERE serviceId=${serviceId} AND goalId=${goalId} AND objectiveId=${objectiveId}")

        int con =(int) max[0]+1
        PmObjectives objectives = PmObjectives.read(objectiveId)

        parameterMap.start=DateUtility.getSqlDate(c.getTime())
        parameterMap.end=DateUtility.getSqlDate(ce.getTime())

        PmActions actions = new PmActions(parameterMap)
        actions.serviceId = serviceId
        actions.goalId = goalId
        actions.objectiveId = objectiveId
        actions.sequence = objectives.sequence+"."+con
        actions.tmpSeq = con
        return actions
    }
}
