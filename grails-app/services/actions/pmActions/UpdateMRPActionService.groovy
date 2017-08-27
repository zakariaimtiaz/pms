package actions.pmActions

import com.pms.PmActions
import com.pms.PmActionsExtendHistory
import com.pms.PmActionsIndicator
import com.pms.PmActionsIndicatorDetails
import com.pms.PmMcrsLog
import com.pms.SecUser
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility
import service.PmActionsService

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class UpdateMRPActionService extends BaseService implements ActionServiceIntf {

    PmActionsService pmActionsService
    BaseService baseService
    private static final String COULD_NOT_BE_EMPTY = "Remarks is mandatory for Repeatable% indicator"
    private static final String UPDATE_SUCCESS_MESSAGE = "Achievement has been updated successfully"
    private static final String MRP_LOCKED_MSG = "MRP is locked for this month"
    private static final String MRP_SUBMITTED_MSG = "MRP already submitted"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            String indicatorType = params.get("models[0][indicator_type]")
            String detailsIdStr = params.get("models[0][ind_details_id]")
            String achievementStr = params.get("models[0][achievement]")
            String remarksStr = params.get("models[0][remarks]")

            if ((indicatorType.equals("Repeatable%") || indicatorType.equals("Repeatable%++")) && remarksStr == '') {
                return super.setError(params, COULD_NOT_BE_EMPTY)
            }
            if (!detailsIdStr && !achievementStr) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            if (detailsIdStr) {
                long id = Long.parseLong(detailsIdStr)
                PmActionsIndicatorDetails details = PmActionsIndicatorDetails.read(id)
                PmActionsIndicator pmActionsIndicator = PmActionsIndicator.findById(details.indicatorId)
                PmActions pmActions = PmActions.findById(details.actionsId)
                SecUser user = currentUserObject()
                PmMcrsLog pmMcrsLog = PmMcrsLog.findByServiceIdAndYearAndMonthStrIlike(user.serviceId, pmActions.year,details.monthName)
                if (!pmMcrsLog.isEditable) {
                    return super.setError(params, MRP_LOCKED_MSG)
                }
                if (pmMcrsLog.isSubmitted) {
                    return super.setError(params, MRP_SUBMITTED_MSG)
                }
                details.remarks = remarksStr
                if (!achievementStr.isEmpty())
                    details.achievement = Integer.parseInt(achievementStr)
                else
                    details.achievement = 0

                if (details.target != details.achievement && remarksStr.trim().isEmpty()) {
                    return super.setError(params, "Remarks is mandatory when achievement is not equal target.")
                }
                if (indicatorType.equals("Dividable") || indicatorType.equals("Dividable%")) {
                    Date date= pmActions.end
                    String lastMonth=  baseService.lastMRPSubmissionDate(user.serviceId)
                    PmActionsExtendHistory pmActionsExtendHistory = PmActionsExtendHistory.findByActionsId(pmActions.id, [max: 1, sort: 'id', order: 'desc'])
                    if(pmActionsExtendHistory) {
                        if(DateUtility.parseDateForDB(lastMonth)<pmActionsExtendHistory.end )
                            date=pmActionsExtendHistory.end
                    }
                    Calendar c = Calendar.getInstance();
                    c.setTime(date);
                    String monthName = new SimpleDateFormat("MMMM").format(c.getTime())
                    if (details.monthName == monthName) {
                        List<GroovyRowResult> lst = pmActionsService.findTotalTargetAchievements(details.actionsId, details.indicatorId)
                        if (lst[0].target > lst[0].achievement + details.achievement) {
                            params.put("totalTarget", lst[0].target)
                            params.put("totalAchievement", lst[0].achievement + details.achievement)
                            params.put("indType", indicatorType)
                            params.put("id", details.id)
                            params.put("remarks", remarksStr)
                            params.put("achievement", achievementStr)
                            params.put("isExtend", pmActionsIndicator.isExtended==null?false:pmActionsIndicator.isExtended)
                            if(pmActionsIndicator.isExtended) {
                                    if (DateUtility.parseDateForDB(lastMonth) > pmActionsExtendHistory.end) {
                                        params.put("prevExtendedEnd", pmActions.end)
                                        params.put("extendedEnd", '')
                                    } else {
                                        params.put("prevExtendedEnd", pmActionsExtendHistory.end == null ? '' : pmActionsExtendHistory.end)
                                        params.put("extendedEnd", pmActions.end)
                                        if (pmActionsExtendHistory.end != null && pmActionsExtendHistory.end != '') {
                                            List<PmActionsIndicatorDetails> lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIdNotLessThanEquals(details.actionsId, details.indicatorId, details.id)
                                            params.put("lstExtend", lstExtend)
                                        }
                                    }

                            }else {
                                params.put("prevExtendedEnd", '')
                                params.put("extendedEnd", '')
                            }

                            params.put("closingNote", pmActionsIndicator.closingNote == null ? '' : pmActionsIndicator.closingNote)

                            return super.setError(params, "OpenPopup")
                        }
                        else{
                            Boolean canDelete=true
                            List<PmActionsIndicator> lstIndicator=PmActionsIndicator.findAllByActionsId(details.actionsId)
                            for(PmActionsIndicator pmActionsIndicator1 in lstIndicator) {
                                if (details.indicatorId == pmActionsIndicator1.id) {
                                    pmActionsIndicator1.closingNote = null
                                    pmActionsIndicator1.closingMonth = null
                                    pmActionsIndicator1.isExtended =false
                                    pmActionsIndicator1.save()
                                }
                                if(pmActionsIndicator1.isExtended){
                                    canDelete=false
                                }
                            }
                            if (pmActionsExtendHistory.end) {
                                if (canDelete) {
                                    pmActions.end = pmActionsExtendHistory.end
                                    pmActions.save()
                                    pmActionsExtendHistory.delete()

                                    List<PmActionsIndicatorDetails> lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIdNotLessThanEquals(details.actionsId, details.id)
                                    for (PmActionsIndicatorDetails etDetails in lstExtend) {
                                        if ((etDetails.achievement == 0 || etDetails.achievement == null) && (etDetails.remarks == '' || etDetails.remarks == null))
                                            etDetails.delete()
                                    }
                                } else {
                                    List<PmActionsIndicatorDetails> lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIsExtendedAndIdNotLessThanEquals(details.actionsId, details.indicatorId, true, details.id)
                                    for (PmActionsIndicatorDetails etDetails in lstExtend) {
                                        etDetails.target = 0
                                        etDetails.save()
                                    }
                                }
                            }
                        }
                    }
                }

                details.save()

            }

            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    public Map execute(Map result) {
        return result
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
}
