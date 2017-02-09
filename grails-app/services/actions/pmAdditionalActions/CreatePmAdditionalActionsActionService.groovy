package actions.pmAdditionalActions

import com.model.ListPmAdditionalActionsActionServiceModel
import com.pms.*
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class CreatePmAdditionalActionsActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Actions has been saved successfully"
    private static final String ADDITIONAL_ACTIONS_OBJECT = "pmAdditionalAction"

    private Logger log = Logger.getLogger(getClass())


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId && !params.goalId && !params.actions) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())
            long goalId = Long.parseLong(params.goalId.toString())

            PmAdditionalActions actions = buildObject(params, serviceId, goalId)
            params.put(ADDITIONAL_ACTIONS_OBJECT, actions)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmAdditionalActions actions = (PmAdditionalActions) result.get(ADDITIONAL_ACTIONS_OBJECT)
            int count = Integer.parseInt(result.indicatorCount.toString())
            int max = Integer.parseInt(result.indicatorMaxId.toString())
            actions.totalIndicator = count
            actions.save()

                Date date = actions.start
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

                        PmAdditionalActionsIndicator indicator = new PmAdditionalActionsIndicator()
                        indicator.actionsId = actions.id
                        indicator.indicator = result.get("indicator" + (i + 1))
                        indicator.indicatorType = result.get("indType" + (i + 1))
                        indicator.target = Integer.parseInt(result.get("target" + (i + 1)).toString())
                        indicator.unitId = unitId
                        indicator.unitStr = unitIdStr
                        indicator.save()

                    } catch (Exception e) {
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
        PmAdditionalActions actions = (PmAdditionalActions) result.get(ADDITIONAL_ACTIONS_OBJECT)
        ListPmAdditionalActionsActionServiceModel model = ListPmAdditionalActionsActionServiceModel.read(actions.id)
        result.put(ADDITIONAL_ACTIONS_OBJECT, model)
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

    private PmAdditionalActions buildObject(Map parameterMap, long serviceId, long goalId) {
        String startDateStr = parameterMap.start.toString()
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

        Date start = originalFormat.parse(startDateStr);
        Calendar c = Calendar.getInstance();
        c.setTime(start);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
        parameterMap.start = DateUtility.getSqlDate(c.getTime())

        int year = c.get(Calendar.YEAR);

        Date end = originalFormat.parse(startDateStr);
        c.setTime(end);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
        parameterMap.end = DateUtility.getSqlDate(c.getTime())
        String query = """
        SELECT COALESCE(MAX(tmp_seq)+1,1) AS count FROM pm_additional_actions
        WHERE service_id=${serviceId} AND goal_id=${goalId}  AND
        EXTRACT(YEAR FROM start) = ${year} AND EXTRACT(YEAR FROM end)=${year}
        """
        List<GroovyRowResult> max = executeSelectSql(query)
        int con = (int) max[0].count

        PmGoals goals = PmGoals.read(goalId)

        long responsibleId = Long.parseLong(parameterMap.resPersonId.toString())
        String resName = responsiblePersonName(responsibleId)

        PmAdditionalActions actions = new PmAdditionalActions(parameterMap)
        actions.serviceId = serviceId
        actions.goalId = goalId
        actions.resPerson = resName
        actions.sequence = goals.sequence + "." + con
        actions.tmpSeq = con
        return actions
    }
}
