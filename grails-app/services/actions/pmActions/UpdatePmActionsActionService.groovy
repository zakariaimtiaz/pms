package actions.pmActions

import com.model.ListPmActionsActionServiceModel
import com.pms.PmActions
import com.pms.PmActionsIndicator
import com.pms.PmActionsIndicatorDetails
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
    private static final String ACTIONS_OBJ = "pmAction"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.id && !params.serviceId && !params.goalId && !params.actions) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
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
            int count = Integer.parseInt(result.indicatorCount.toString())
            int max = Integer.parseInt(result.indicatorMaxId.toString())
            actions.totalIndicator = count
            actions.save()

            String query1 = """
                DELETE FROM pm_actions_indicator where actions_id=${actions.id}
            """
            String query2 = """
                DELETE FROM pm_actions_indicator_details where actions_id=${actions.id}
            """
            boolean indicatorDeleted = executeSql(query1)
            boolean indicatorDetailsDeleted = executeSql(query2)

            String str = result.indicator.toString()
            Calendar cal = Calendar.getInstance();
            cal.setTime(actions.start);
            int monthNoStart = cal.get(Calendar.MONTH);

            cal = Calendar.getInstance();
            cal.setTime(actions.end);
            int monthEnd = cal.get(Calendar.MONTH);

            if (monthNoStart == monthEnd) {
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
                        indicator.indicatorType = result.get("indType" + (i + 1))
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
                    } catch (Exception e) {
                    }
                }
            } else {
                String[] ind = str.split(",");
                int indSplitCount = 0;
                for (int i = 0; i < max; i++) {
                    try {
                        PmActionsIndicator indicator = new PmActionsIndicator()
                        indicator.actionsId = actions.id
                        indicator.indicator = result.get("indicator" + (i + 1))
                        indicator.indicatorType = result.get("indType" + (i + 1))
                        indicator.target = Integer.parseInt(result.get("target" + (i + 1)).toString())
                        indicator.save()
                        if (indicator.indicatorType == "Repeatable") {

                            int tmpCount = (monthEnd - monthNoStart) + 1
                            int monthCount = monthNoStart

                            int t = 5;
                            for (int j = 0; j < tmpCount; j++) {
                                PmActionsIndicatorDetails details = new PmActionsIndicatorDetails()
                                details.actionsId = actions.id
                                details.indicatorId = indicator.id
                                String name = monthCount == 0 ? "January" : monthCount == 1 ? "February" : monthCount == 2 ? "March" : monthCount == 3 ? "April" : monthCount == 4 ? "May" : monthCount == 5 ? "June" : monthCount == 6 ? "July" : monthCount == 7 ? "August" : monthCount == 8 ? "September" : monthCount == 9 ? "October" : monthCount == 10 ? "November" : "December"

                                details.monthName = name
                                details.target = indicator.target
                                details.createBy = 1
                                details.createDate = new Date()
                                details.save()
                                t += 2
                                monthCount++
                            }
                        } else {
                            String[] couple = ind[indSplitCount].split("&");
                            int tmpCount = Integer.parseInt(couple[4].split("=")[1].replaceAll("^\\d.]", ""))

                            int t = 5;
                            for (int j = 0; j < tmpCount; j++) {
                                PmActionsIndicatorDetails details = new PmActionsIndicatorDetails()
                                details.actionsId = actions.id
                                details.indicatorId = indicator.id
                                String name = couple[t].split("=")[1].replaceAll("^\\d.]", "")
                                String target = couple[t + 1].split("=")[1].replaceAll("[^\\d.]", "")
                                int targetInt = 0
                                try {
                                    targetInt = Integer.parseInt(target)
                                } catch (Exception e) {
                                    targetInt = 0
                                }

                                details.monthName = name
                                details.target = targetInt
                                details.createBy = 1
                                details.createDate = new Date()
                                details.save()
                                t += 2
                            }
                            indSplitCount++
                        }
                    } catch (Exception e) {
                        indSplitCount++
                    }
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

        params.start = DateUtility.getSqlDate(c.getTime())
        params.end = DateUtility.getSqlDate(ce.getTime())

        PmActions actions = new PmActions(params)
        oldObject.resPersonId = resPersonId
        oldObject.supportDepartment = actions.supportDepartment
        oldObject.resPerson = actions.resPerson
        oldObject.actions = actions.actions
        oldObject.start = actions.start
        oldObject.end = actions.end
        oldObject.sourceOfFund = actions.sourceOfFund
        oldObject.note = actions.note
        oldObject.indicator = actions.indicator
        return oldObject
    }
}
