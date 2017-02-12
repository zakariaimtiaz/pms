package actions.pmAdditionalActions

import com.model.ListPmActionsActionServiceModel
import com.model.ListPmAdditionalActionsActionServiceModel
import com.pms.PmAdditionalActions
import com.pms.PmAdditionalActionsIndicator
import com.pms.PmActionsIndicatorDetails
import com.pms.SystemEntity
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class UpdatePmAdditionalActionsActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String UPDATE_SUCCESS_MESSAGE = "Action has been updated successfully"
    private static final String ADDITIONAL_ACTIONS_OBJ = "pmAdditionalAction"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.id && !params.serviceId && !params.goalId && !params.actions) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            PmAdditionalActions oldObject = (PmAdditionalActions) PmAdditionalActions.read(id)
            PmAdditionalActions actions = buildObject(params, oldObject)
            params.put(ADDITIONAL_ACTIONS_OBJ, actions)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmAdditionalActions actions = (PmAdditionalActions) result.get(ADDITIONAL_ACTIONS_OBJ)
            int count = Integer.parseInt(result.indicatorCount.toString())
            int max = Integer.parseInt(result.indicatorMaxId.toString())
            actions.totalIndicator = count
            actions.save()

            String str = result.indicator.toString()
            String deletedIndicatorIds = result.deletedIndicatorIds.toString()
            if(!deletedIndicatorIds.isEmpty()){
                String query1 = """
                DELETE FROM pm_actions_indicator WHERE id IN (${deletedIndicatorIds})
            """
               
                boolean indicatorDel = executeSql(query1)
            }

            Calendar cal = Calendar.getInstance();
            cal.setTime(actions.start);
            int monthNoStart = cal.get(Calendar.MONTH);

            cal = Calendar.getInstance();
            cal.setTime(actions.end);
            int monthEnd = cal.get(Calendar.MONTH);

            if (monthNoStart == monthEnd) {
                String monthStr = result.start.toString()
                Date date = DateUtility.parseDateForDB(monthStr);
                Calendar c = Calendar.getInstance();
                c.setTime(date);
                String monthName = new SimpleDateFormat("MMMM").format(c.getTime())

                for (int i = 0; i < max; i++) {
                    try {
                        long unitId = 0
                        String unitIdStr = ''
                        String tempStr = result.get("unitId" + (i + 1)).toString()
                        if (!tempStr.isEmpty()) {
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
                        if (result.get("indicatorId" + (i + 1)).toString().isEmpty()) {

                            indicator = new PmAdditionalActionsIndicator()
                            indicator.actionsId = actions.id
                            indicator.indicator = result.get("indicator" + (i + 1))
                            indicator.indicatorType = result.get("indType" + (i + 1))
                            indicator.target = Integer.parseInt(result.get("target" + (i + 1)).toString())
                            indicator.unitStr = unitIdStr
                            indicator.unitId = unitId
                            indicator.save()

                        } else {
                            long id = Long.parseLong(result.get("indicatorId" + (i + 1)).toString())
                            indicator = PmAdditionalActionsIndicator.findById(id)
                            indicator.actionsId = actions.id
                            indicator.indicator = result.get("indicator" + (i + 1))
                            indicator.indicatorType = result.get("indType" + (i + 1))
                            indicator.target = Integer.parseInt(result.get("target" + (i + 1)).toString())
                            indicator.unitStr = unitIdStr
                            indicator.unitId = unitId
                            indicator.save()

                            List<PmActionsIndicatorDetails> lstIndDetails = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorId(actions.id,id)
                            for (PmActionsIndicatorDetails pmActionsIndicatorDetails : lstIndDetails) {
                                pmActionsIndicatorDetails.delete()
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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        PmAdditionalActions actions = (PmAdditionalActions) result.get(ADDITIONAL_ACTIONS_OBJ)
        ListPmAdditionalActionsActionServiceModel model = ListPmAdditionalActionsActionServiceModel.read(actions.id)
        result.put(ADDITIONAL_ACTIONS_OBJ, model)
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

    private static PmAdditionalActions buildObject(Map params, PmAdditionalActions oldObject) {
        long resPersonId = Long.parseLong(params.resPersonId.toString())

        String startDateStr = params.start.toString()
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

        Date start = originalFormat.parse(startDateStr);
        Calendar c = Calendar.getInstance();
        c.setTime(start);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
        params.start = DateUtility.getSqlDate(c.getTime())

        Date end = originalFormat.parse(startDateStr);
        c.setTime(end);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
        params.end = DateUtility.getSqlDate(c.getTime())

        PmAdditionalActions actions = new PmAdditionalActions(params)
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
