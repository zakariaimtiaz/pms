package actions.pmActions

import com.model.ListPmActionsActionServiceModel
import com.pms.PmActions
import com.pms.PmActionsIndicator
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
class UpdatePmActionsActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
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

            String str = result.indicator.toString()
            String deletedIndicatorIds = result.deletedIndicatorIds.toString()
            if(!deletedIndicatorIds.isEmpty()){
                String query1 = """
                DELETE FROM pm_actions_indicator WHERE id IN (${deletedIndicatorIds})
            """
                String query2 = """
                DELETE FROM pm_actions_indicator_details WHERE indicator_id IN (${deletedIndicatorIds})
            """
                boolean indicatorDel = executeSql(query1)
                boolean indicatorDetailsDel = executeSql(query2)
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
                        PmActionsIndicator indicator = new PmActionsIndicator()
                        if (result.get("indicatorId" + (i + 1)).toString().isEmpty()) {

                            indicator = new PmActionsIndicator()
                            indicator.actionsId = actions.id
                            indicator.year = actions.year
                            indicator.indicator = result.get("indicator" + (i + 1))
                            indicator.indicatorType = result.get("indType" + (i + 1))
                            indicator.target = Integer.parseInt(result.get("target" + (i + 1)).toString())
                            indicator.unitStr = unitIdStr
                            indicator.unitId = unitId
                            indicator.save()

                        } else {
                            long id = Long.parseLong(result.get("indicatorId" + (i + 1)).toString())
                            indicator = PmActionsIndicator.findById(id)
                            indicator.actionsId = actions.id
                            indicator.year = actions.year
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

                        PmActionsIndicatorDetails details = new PmActionsIndicatorDetails()
                        details.actionsId = actions.id
                        details.indicatorId = indicator.id
                        details.monthName = monthName
                        details.target = indicator.target
                        details.createBy = springSecurityService.principal.id
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
                        if(result.get("indicatorId" + (i + 1)).toString().isEmpty()){
                            PmActionsIndicator indicator = new PmActionsIndicator()
                            indicator.actionsId = actions.id
                            indicator.year = actions.year
                            indicator.indicator = result.get("indicator" + (i + 1))
                            indicator.indicatorType = result.get("indType" + (i + 1))
                            indicator.target = Integer.parseInt(result.get("target" + (i + 1)).toString())
                            indicator.save()

                            if (indicator.indicatorType == "Repeatable"|| indicator.indicatorType=="Repeatable%") {

                                int tmpCount = (monthEnd - monthNoStart) + 1
                                int monthCount = monthNoStart

                                for (int j = 0; j < tmpCount; j++) {
                                    PmActionsIndicatorDetails details = new PmActionsIndicatorDetails()
                                    details.actionsId = actions.id
                                    details.indicatorId = indicator.id
                                    String name = monthCount == 0 ? "January" : monthCount == 1 ? "February" : monthCount == 2 ? "March" : monthCount == 3 ? "April" : monthCount == 4 ? "May" : monthCount == 5 ? "June" : monthCount == 6 ? "July" : monthCount == 7 ? "August" : monthCount == 8 ? "September" : monthCount == 9 ? "October" : monthCount == 10 ? "November" : "December"

                                    details.monthName = name
                                    details.target = indicator.target
                                    details.createBy = springSecurityService.principal.id
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
                                int tmpCount = Integer.parseInt(couple[4].split("=")[1].replaceAll("^\\d.]", ""))

                                int t = 6;
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
                                    details.createBy = springSecurityService.principal.id
                                    details.createDate = new Date()
                                    details.save()
                                    t += 2
                                }

                            }
                        }else{
                            Long id = Long.parseLong(result.get("indicatorId" + (i + 1)).toString())
                            PmActionsIndicator indicator = PmActionsIndicator.read(id)
                            indicator.actionsId = actions.id
                            indicator.year = actions.year
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
                            if (indicator.indicatorType == "Repeatable"|| indicator.indicatorType=="Repeatable%") {

                                int tmpCount = (monthEnd - monthNoStart) + 1
                                int monthCount = monthNoStart

                                for (int j = 0; j < tmpCount; j++) {
                                    String name = monthCount == 0 ? "January" : monthCount == 1 ? "February" : monthCount == 2 ? "March" : monthCount == 3 ? "April" : monthCount == 4 ? "May" : monthCount == 5 ? "June" : monthCount == 6 ? "July" : monthCount == 7 ? "August" : monthCount == 8 ? "September" : monthCount == 9 ? "October" : monthCount == 10 ? "November" : "December"
                                    PmActionsIndicatorDetails details = new PmActionsIndicatorDetails()

                                    details.actionsId = actions.id
                                    details.indicatorId = indicator.id

                                    details.monthName = name
                                    details.target = indicator.target
                                    details.createBy = springSecurityService.principal.id
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
                                    String name = couple[t].split("=")[1].replaceAll("^\\d.]", "")

                                        PmActionsIndicatorDetails details = new PmActionsIndicatorDetails()
                                        int targetInt = 0
                                        try {
                                            String target = couple[t + 1].split("=")[1].replaceAll("[^\\d.]", "")
                                            targetInt = Integer.parseInt(target)
                                        } catch (Exception e) {
                                            targetInt = 0
                                        }
                                        details.actionsId = actions.id
                                        details.indicatorId = indicator.id
                                        details.monthName = name
                                        details.target = targetInt
                                        details.createBy = springSecurityService.principal.id
                                        details.createDate = new Date()
                                        details.save()

                                    t += 2
                                }
                            }
                        }
                            indSplitCount++
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

    private PmActions buildObject(Map params, PmActions oldObject) {
        long resPersonId = Long.parseLong(params.resPersonId.toString())
        String resName = responsiblePersonName(resPersonId)

        String startDateStr = params.start.toString()
        String endDateStr = params.end.toString()
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

        Date start = originalFormat.parse(startDateStr);
        Calendar c = Calendar.getInstance();
        c.setTime(start);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
        params.start = DateUtility.getSqlDate(c.getTime())

        int year = c.get(Calendar.YEAR);

        Date end = originalFormat.parse(endDateStr);
        c.setTime(end);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
        params.end = DateUtility.getSqlDate(c.getTime())

        PmActions actions = new PmActions(params)
        oldObject.year = year
        oldObject.resPersonId = resPersonId
        oldObject.supportDepartment = actions.supportDepartment
        oldObject.resPerson = resName
        oldObject.actions = actions.actions
        oldObject.start = actions.start
        oldObject.end = actions.end
        oldObject.sourceOfFund = actions.sourceOfFund
        oldObject.note = actions.note
        oldObject.indicator = actions.indicator
        return oldObject
    }
}
