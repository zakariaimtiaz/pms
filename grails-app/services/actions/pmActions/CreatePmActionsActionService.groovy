package actions.pmActions

import com.model.ListPmActionsActionServiceModel
import com.pms.PmActions
import com.pms.PmActionsIndicator
import com.pms.PmActionsIndicatorDetails
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
            int count = Integer.parseInt(result.indicatorCount.toString())
            int max = Integer.parseInt(result.indicatorMaxId.toString())
            actions.totalIndicator = count
            actions.save()
            String str = result.indicator.toString()
            if (actions.start==actions.end) {
                String monthStr = result.start.toString()
                DateFormat originalFormat = new SimpleDateFormat("yyyy-mm-dd", Locale.ENGLISH);

                Date date = originalFormat.parse(monthStr);
                Calendar c = Calendar.getInstance();
                c.setTime(date);
                String monthName = new SimpleDateFormat("MMMM").format(c.getTime())
                for (int i = 0; i < max; i++) {
                    try {
                        PmActionsIndicator indicator = new PmActionsIndicator()
                        indicator.actionsId = actions.id
                        indicator.indicator = result.get("indicator" + (i + 1))
                        indicator.target = Integer.parseInt(result.get("target" + (i + 1)).toString())
                        indicator.save()

                        PmActionsIndicatorDetails details = new PmActionsIndicatorDetails()
                        details.actionsId = actions.id
                        details.indicatorId = indicator.id
                        details.monthName = monthName
                        details.target = indicator.target
                        details.createBy = 1
                        details.createDate = new Date()
                        details.save()
                    }catch (Exception e){ }
                }
            } else {
                String[] ind = str.split(",");
                for (int i = 0; i < ind.length; i++) {
                    try {
                        PmActionsIndicator indicator = new PmActionsIndicator()
                        indicator.actionsId = actions.id
                        indicator.indicator = result.get("indicator" + (i+1))
                        indicator.target = Integer.parseInt(result.get("target" + (i+1)).toString())
                        indicator.save()

                        String[] couple = ind[i].split("&");
                        int tmpCount = Integer.parseInt(couple[4].split("=")[1].replaceAll("^\\d.]", ""))

                        int t = 5;
                        for (int j = 0; j < tmpCount; j++) {
                            PmActionsIndicatorDetails details = new PmActionsIndicatorDetails()
                            details.actionsId = actions.id
                            details.indicatorId = indicator.id
                            String name = couple[t].split("=")[1].replaceAll("^\\d.]", "")
                            String target = couple[t+1].split("=")[1].replaceAll("[^\\d.]", "")
                            int targetInt = 0
                            try {
                                targetInt = Integer.parseInt(target)
                            }catch (Exception e){
                                targetInt = 0
                            }

                            details.monthName = name
                            details.target = targetInt
                            details.createBy = 1
                            details.createDate = new Date()
                            details.save()
                            t += 2
                        }
                    }catch(Exception e){}
                }
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

    private PmActions buildObject(Map parameterMap, long serviceId, long goalId) {
        String startDateStr = parameterMap.start.toString()
        String endDateStr = parameterMap.end.toString()
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

        Date start = originalFormat.parse(startDateStr);
        Calendar c = Calendar.getInstance();
        c.setTime(start);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
        parameterMap.start = DateUtility.getSqlDate(c.getTime())

        Date end = originalFormat.parse(endDateStr);
        c.setTime(end);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
        parameterMap.end = DateUtility.getSqlDate(c.getTime())


        List<PmActions> max = PmActions.executeQuery("SELECT COALESCE(MAX(tmpSeq),0) FROM PmActions" +
                " WHERE serviceId=${serviceId} AND goalId=${goalId}")

        int con = (int) max[0] + 1
        PmGoals goals = PmGoals.read(goalId)

        long responsibleId = Long.parseLong(parameterMap.resPersonId.toString())
        String resName = responsiblePersonName(responsibleId)

        PmActions actions = new PmActions(parameterMap)
        actions.serviceId = serviceId
        actions.goalId = goalId
        actions.resPerson = resName
        actions.sequence = goals.sequence + "." + con
        actions.tmpSeq = con
        return actions
    }
}
