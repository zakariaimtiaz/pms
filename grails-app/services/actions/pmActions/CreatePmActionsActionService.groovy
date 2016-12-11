package actions.pmActions

import com.model.ListPmActionsActionServiceModel
import com.pms.PmActions
import com.pms.PmActionsIndicator
import com.pms.PmGoals
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
    private static final String ACTIONS_OBJECT = "pmAction"

    private Logger log = Logger.getLogger(getClass())


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId && !params.goalId && !params.actions) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())
            long goalId = Long.parseLong(params.goalId.toString())
            PmActions actions = buildObject(params, serviceId, goalId)
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
            Integer count=Integer.parseInt(result.rowCount)
            (0..count)?.each { item ->
                def indicatorName  = 'indicator'+item
                def targetName = 'target'+item
                def monthlyIndId='monthlyIndicatorId'+item
                PmActionsIndicator pmActionsIndicator=new PmActionsIndicator()
                pmActionsIndicator.indicator=result?.get(indicatorName)
                String target=result?.get(targetName)
                try {
                    pmActionsIndicator.target = Double?.parseDouble(target)
                }catch (ex) {
                    pmActionsIndicator.target = 0
                }
                String mIndId=result?.get(monthlyIndId)
                try {
                    pmActionsIndicator.monthlyIndicatorId = Double?.parseDouble(mIndId)
                }catch (ex) {
                    pmActionsIndicator.monthlyIndicatorId = 0
                }
                pmActionsIndicator.actionsId=actions.id
                pmActionsIndicator.save();
            }
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

    private static PmActions buildObject(Map parameterMap, long serviceId, long goalId) {
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
                " WHERE serviceId=${serviceId} AND goalId=${goalId}")

        int con =(int) max[0]+1
        PmGoals goals = PmGoals.read(goalId)

        parameterMap.start=DateUtility.getSqlDate(c.getTime())
        parameterMap.end=DateUtility.getSqlDate(ce.getTime())

        PmActions actions = new PmActions(parameterMap)
        actions.serviceId = serviceId
        actions.goalId = goalId
        actions.sequence = goals.sequence+"."+con
        actions.tmpSeq = con
        return actions
    }
}
