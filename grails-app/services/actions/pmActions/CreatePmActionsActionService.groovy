package actions.pmActions

import com.model.ListPmActionsActionServiceModel
import com.pms.PmActions
import com.pms.PmActionsIndicator
import com.pms.PmActionsIndicatorDetails
import com.pms.PmGoals
import com.pms.SystemEntity
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
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
                        long unitId = 0
                        String unitIdStr = ''
                        String tempStr = result.get("unitId" + (i + 1)).toString()
                        if(!tempStr.isEmpty()){
                            try {
                                unitId = Long.parseLong(tempStr)
                                SystemEntity se = SystemEntity.read(unitId)
                                unitIdStr = se.name
                            } catch (Exception ex) {
                                SystemEntity unit = SystemEntity.findByNameIlikeAndTypeId(tempStr, 2L)
                                if (unit) {
                                    unitId = unit.id
                                    unitIdStr = unit.name
                                } else {
                                    SystemEntity unitx = new SystemEntity()
                                    unitx.typeId = 2
                                    unitx.name = tempStr
                                    unitx.save()
                                    unitId = unitx.id
                                    unitIdStr = unitx.name
                                }
                            }
                        }

                        PmActionsIndicator indicator = new PmActionsIndicator()
                        indicator.actionsId = actions.id
                        indicator.indicator = result.get("indicator" + (i + 1))
                        indicator.indicatorType = result.get("indType" + (i + 1))
                        indicator.target = Integer.parseInt(result.get("target" + (i + 1)).toString())
                        indicator.unitId = unitId
                        indicator.unitStr = unitIdStr
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
                for (int i = 0; i < max; i++) {
                    try {
                        long unitId = 0
                        String unitIdStr = ''
                        String tempStr = result.get("unitId" + (i + 1)).toString()
                        if(!tempStr.isEmpty()) {
                            try {
                                unitId = Long.parseLong(tempStr)
                                SystemEntity se = SystemEntity.read(unitId)
                                unitIdStr = se.name
                            } catch (Exception ex) {
                                SystemEntity unit = SystemEntity.findByNameIlikeAndTypeId(tempStr, 2L)
                                if (unit) {
                                    unitId = unit.id
                                    unitIdStr = unit.name
                                } else {
                                    SystemEntity unitx = new SystemEntity()
                                    unitx.typeId = 2
                                    unitx.name = tempStr
                                    unitx.save()
                                    unitId = unitx.id
                                    unitIdStr = unitx.name
                                }
                            }
                        }
                        PmActionsIndicator indicator = new PmActionsIndicator()
                        indicator.actionsId = actions.id
                        indicator.indicator = result.get("indicator" + (i + 1))
                        indicator.indicatorType = result.get("indType" + (i + 1))
                        indicator.target = Integer.parseInt(result.get("target" + (i + 1)).toString())
                        indicator.unitId = unitId
                        indicator.unitStr = unitIdStr
                        indicator.save()
                        if (indicator.indicatorType == "Repeatable") {

                            int tmpCount = (monthEnd - monthNoStart) + 1
                            int monthCount = monthNoStart

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
                                monthCount++
                            }
                        } else {
                            String[] couple = ""
                            for (int k = 0; k < max; k++) {
                                couple = ind[k].split("&");
                                if (couple[0].split("=")[1].replaceAll("^\\d.]", "") == ("indicator" + (i + 1))) {
                                    break;
                                }
                            }
                            int tmpCount = Integer.parseInt(couple[5].split("=")[1].replaceAll("^\\d.]", ""))

                            int t = 6;
                            for (int j = 0; j < tmpCount; j++) {
                                PmActionsIndicatorDetails details = new PmActionsIndicatorDetails()
                                details.actionsId = actions.id
                                details.indicatorId = indicator.id
                                String name = couple[t].split("=")[1].replaceAll("^\\d.]", "")
                                int targetInt = 0
                                try {
                                    String target = couple[t + 1].split("=")[1].replaceAll("[^\\d.]", "")
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
                        }
                    } catch (Exception e) {

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

        int year = c.get(Calendar.YEAR);

        Date end = originalFormat.parse(endDateStr);
        c.setTime(end);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
        parameterMap.end = DateUtility.getSqlDate(c.getTime())

        String query = """
        SELECT COALESCE(MAX(tmp_seq)+1,1) AS count FROM pm_actions
        WHERE service_id=${serviceId} AND goal_id=${goalId}  AND
        EXTRACT(YEAR FROM start) = ${year} AND EXTRACT(YEAR FROM end)=${year}
        """
        List<GroovyRowResult> max = executeSelectSql(query)
        int con = (int) max[0].count
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
