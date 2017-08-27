package actions.pmActions

import com.pms.PmActions
import com.pms.PmActionsExtendHistory
import com.pms.PmActionsIndicator
import com.pms.PmActionsIndicatorDetails
import com.pms.PmMcrsLog
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility
import service.PmActionsService

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class UpdateMRPActionExtendedTimeService extends BaseService implements ActionServiceIntf {

    PmActionsService pmActionsService
    private static final String UPDATE_SUCCESS_MESSAGE = "Achievement has been updated successfully"
    private static final String MRP_LOCKED_MSG = "MRP is locked for this month"
    private static final String MRP_SUBMITTED_MSG = "MRP already submitted"
    boolean canDelete=true

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.hfIndicatorDetailsId && !params.hfIndicatorDetailsAcv) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            if (params.selection == "CloseWithRemain" && !params.IndicatorClosingNote) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            else if(params.selection == "ExtendMonth" && !params.extendedEndMonth){
                    return super.setError(params, "Invalid extended end month")
            }
            long id = Long.parseLong(params.hfIndicatorDetailsId)
            PmActionsIndicatorDetails details = PmActionsIndicatorDetails.read(id)
            PmActions pmActions=PmActions.findById(details.actionsId)
            List<PmActionsIndicator> lstIndicator=PmActionsIndicator.findAllByActionsId(details.actionsId)
            if(params.selection == "ExtendMonth"){
                DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

                Date start = originalFormat.parse(params.extendedEndMonth.toString());
                Calendar c = Calendar.getInstance();
                c.setTime(start);
                c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
                Date extendDate = DateUtility.getSqlDate(c.getTime())
                boolean canMinimize=true
                if (extendDate < pmActions.end) {
                    for (PmActionsIndicator pmActionsIndicator in lstIndicator) {
                        if (pmActionsIndicator.isExtended && details.indicatorId != pmActionsIndicator.id) {
                            List<PmActionsIndicatorDetails> lstExtendDetails = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIsExtended(pmActionsIndicator.actionsId, pmActionsIndicator.id, true)
                            for (PmActionsIndicatorDetails pmActionsIndicatorDetails in lstExtendDetails) {
                                int count = 0
                                for (int i = 0; i < Integer.parseInt(params.hfExtendDateCount); i++) {
                                    if (pmActionsIndicatorDetails.monthName == params.get("month" + (i + 1)))
                                        count++
                                }
                                if (count == 0 && pmActionsIndicatorDetails.target > 0) {
                                    canMinimize = false
                                    break
                                }
                            }
                        }
                        if (!canMinimize)
                            break
                    }
                }
                if (!canMinimize){
                    return super.setError(params, "Can't minimize end month other indicator have plan.")
                }
            }

            details.remarks = params.hfIndicatorDetailsRemarks
            if (!params.hfIndicatorDetailsAcv.isEmpty())
                details.achievement = Integer.parseInt(params.hfIndicatorDetailsAcv)
            else
                details.achievement = 0

            details.save()

            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
            Date end = originalFormat.parse(params.hfIndicatorDetailsMonth.toString());
            Calendar c = Calendar.getInstance();
            c.setTime(end);
            c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
            Date mrpEntryMonth = DateUtility.getSqlDate(c.getTime())

            if (params.selection == "CloseWithRemain") {
                canDelete = true

                for (PmActionsIndicator pmActionsIndicator in lstIndicator) {
                    if (details.indicatorId == pmActionsIndicator.id) {
                        pmActionsIndicator.closingNote = params.IndicatorClosingNote
                        pmActionsIndicator.closingMonth = mrpEntryMonth
                        pmActionsIndicator.isExtended = mrpEntryMonth == DateUtility.getSqlDate(pmActions.end) ? false : pmActionsIndicator.isExtended
                        pmActionsIndicator.save()
                    }
                    if (pmActionsIndicator.isExtended) {
                        canDelete = false
                    }
                }
                PmActionsExtendHistory pmActionsExtendHistory = PmActionsExtendHistory.findByActionsId(pmActions.id, [max: 1, sort: 'id', order: 'desc'])
                if (pmActionsExtendHistory) {
                    if (canDelete) {
                        pmActions.end = pmActionsExtendHistory.end
                        pmActions.save()
                        pmActionsExtendHistory.delete()

                        List<PmActionsIndicatorDetails> lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIdNotLessThanEquals(details.actionsId,  id)
                        for (PmActionsIndicatorDetails etDetails in lstExtend) {
                            if ((etDetails.achievement == 0 || etDetails.achievement == null) && (etDetails.remarks == '' || etDetails.remarks == null))
                                etDetails.delete()
                        }
                    } else {
                        List<PmActionsIndicatorDetails> lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIsExtended(details.actionsId, details.indicatorId, true)
                        for (PmActionsIndicatorDetails etDetails in lstExtend) {
                            etDetails.target = 0
                            etDetails.save()
                        }
                    }
                }
            }
            else {
                Date start = originalFormat.parse(params.extendedEndMonth.toString());
                c = Calendar.getInstance();
                c.setTime(start);
                c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                Date extendDate = DateUtility.getSqlDate(c.getTime())
                Boolean newEntry=false

                PmActionsExtendHistory pmActionsExtendHistory = PmActionsExtendHistory.findByActionsId(pmActions.id, [max: 1, sort: 'id', order: 'desc'])
                if (pmActionsExtendHistory==null) {
                    newEntry=true
                }
                /*else if(extendDate.month!=pmActions.end.month) {
                    canDelete = true
                    for (PmActionsIndicator pmActionsIndicator in lstIndicator) {
                        if (pmActionsIndicator.isExtended && details.indicatorId != pmActionsIndicator.id) {
                            canDelete = false
                            break
                        }
                    }
                    if (canDelete) {
                        newEntry=true
                        List<PmActionsIndicatorDetails> lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIdNotLessThanEquals(pmActionsIndicator.actionsId, pmActionsIndicator.id, id)
                        for (PmActionsIndicatorDetails etDetails in lstExtend) {
                            if ((etDetails.achievement==0||etDetails.achievement==null)&&(etDetails.remarks==''||etDetails.remarks==null))
                                etDetails.delete()
                        }
                    }
                }*/
                for (PmActionsIndicator pmActionsIndicator in lstIndicator) {
                    if (details.indicatorId == pmActionsIndicator.id) {
                        pmActionsIndicator.closingNote = null
                        pmActionsIndicator.closingMonth = null
                        pmActionsIndicator.isExtended = true
                        pmActionsIndicator.save()
                    }
                    if (newEntry) {
                        EntryForNewEntry( params, details, pmActionsIndicator)
                    }
                    else if (extendDate < pmActions.end) {
                        entryForMinimizeExtendDate(pmActionsIndicator, id, params, details)

                    }
                    else if (extendDate > pmActions.end) {
                        entryForGreaterExtendedDate(params, pmActionsIndicator, details)
                    } else {
                        if (pmActionsIndicator.id == details.indicatorId ) {
                            List<PmActionsIndicatorDetails> lstExtendDetails = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIdNotLessThanEquals(pmActionsIndicator.actionsId, pmActionsIndicator.id, id)
                            for (PmActionsIndicatorDetails pmActionsIndicatorDetails in lstExtendDetails) {
                                for (int i = 0; i < Integer.parseInt(params.hfExtendDateCount); i++) {
                                    if (pmActionsIndicatorDetails.monthName == params.get("month" + (i + 1))) {
                                        pmActionsIndicatorDetails.actionsId = details.actionsId
                                        pmActionsIndicatorDetails.indicatorId = pmActionsIndicator.id
                                        pmActionsIndicatorDetails.monthName = params.get("month" + (i + 1))
                                        pmActionsIndicatorDetails.target = details.indicatorId == pmActionsIndicator.id ? params.get("target" + (i + 1)).toString().trim()!=''?Integer.parseInt(params.get("target" + (i + 1)).toString()):0 : pmActionsIndicatorDetails.target
                                        pmActionsIndicatorDetails.createBy = springSecurityService.principal.id
                                        pmActionsIndicatorDetails.createDate = DateUtility.getSqlDate(new Date())
                                        pmActionsIndicatorDetails.isExtended = details.indicatorId == pmActionsIndicator.id ? true : pmActionsIndicatorDetails.isExtended

                                        pmActionsIndicatorDetails.save()
                                    }
                                }
                            }
                            break;
                        }
                    }
                }
                if(pmActionsExtendHistory) {
                    PmMcrsLog pmMcrsLog = PmMcrsLog.findByServiceIdAndYearAndMonth(pmActions.serviceId, pmActions.year, pmActionsExtendHistory.end.month+1)
                if(!pmMcrsLog.isSubmitted)
                    newEntry = false
                }
                if(newEntry){

                    pmActionsExtendHistory = new PmActionsExtendHistory()
                    pmActionsExtendHistory.end = pmActions.end
                    pmActionsExtendHistory.actionsId = pmActions.id
                    pmActionsExtendHistory.save()
                }

                pmActions.end = extendDate
                pmActions.save()
            }

            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    private void EntryForNewEntry( Map params, PmActionsIndicatorDetails details, PmActionsIndicator pmActionsIndicator) {

        for (int i = 0; i < Integer.parseInt(params.hfExtendDateCount); i++) {
            PmActionsIndicatorDetails pmActionsIndicatorDetails = new PmActionsIndicatorDetails()
            pmActionsIndicatorDetails.actionsId = details.actionsId
            pmActionsIndicatorDetails.indicatorId = pmActionsIndicator.id
            pmActionsIndicatorDetails.monthName = params.get("month" + (i + 1))
            pmActionsIndicatorDetails.target = details.indicatorId == pmActionsIndicator.id ? params.get("target" + (i + 1)).toString().trim() != '' ? Integer.parseInt(params.get("target" + (i + 1)).toString()) : 0 : 0
            pmActionsIndicatorDetails.createBy = springSecurityService.principal.id
            pmActionsIndicatorDetails.createDate = DateUtility.getSqlDate(new Date())
            pmActionsIndicatorDetails.isExtended = details.indicatorId == pmActionsIndicator.id ? true : pmActionsIndicatorDetails.isExtended

            pmActionsIndicatorDetails.save()
        }
    }

    private void entryForGreaterExtendedDate(Map params, PmActionsIndicator pmActionsIndicator, PmActionsIndicatorDetails details) {
        for (int i = 0; i < Integer.parseInt(params.hfExtendDateCount); i++) {
            PmActionsIndicatorDetails pmActionsIndicatorDetails = PmActionsIndicatorDetails.findByActionsIdAndIndicatorIdAndMonthName(pmActionsIndicator.actionsId, pmActionsIndicator.id, params.get("month" + (i + 1)))
            if (pmActionsIndicatorDetails) {
                if (details.indicatorId == pmActionsIndicator.id) {
                    pmActionsIndicatorDetails.target = params.get("target" + (i + 1)).toString().trim() != '' ? Integer.parseInt(params.get("target" + (i + 1)).toString()) : 0
                    pmActionsIndicatorDetails.createBy = springSecurityService.principal.id
                    pmActionsIndicatorDetails.createDate = DateUtility.getSqlDate(new Date())
                    pmActionsIndicatorDetails.isExtended = true
                    pmActionsIndicatorDetails.save()
                }
            } else {
                pmActionsIndicatorDetails = new PmActionsIndicatorDetails()
                pmActionsIndicatorDetails.actionsId = details.actionsId
                pmActionsIndicatorDetails.indicatorId = pmActionsIndicator.id
                pmActionsIndicatorDetails.monthName = params.get("month" + (i + 1))
                pmActionsIndicatorDetails.target = details.indicatorId == pmActionsIndicator.id ? params.get("target" + (i + 1)).toString() != '' ? Integer.parseInt(params.get("target" + (i + 1)).toString()) : 0 : 0
                pmActionsIndicatorDetails.createBy = springSecurityService.principal.id
                pmActionsIndicatorDetails.createDate = DateUtility.getSqlDate(new Date())
                pmActionsIndicatorDetails.isExtended = details.indicatorId == pmActionsIndicator.id ? true : pmActionsIndicator.isExtended
                pmActionsIndicatorDetails.save()
            }
        }
    }

    private void entryForMinimizeExtendDate(PmActionsIndicator pmActionsIndicator, long id, Map params, PmActionsIndicatorDetails details) {
        List<PmActionsIndicatorDetails> lstExtendDetails = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIdNotLessThanEquals(pmActionsIndicator.actionsId, pmActionsIndicator.id, id)
        for (PmActionsIndicatorDetails pmActionsIndicatorDetails in lstExtendDetails) {
            int count = 0
            for (int i = 0; i < Integer.parseInt(params.hfExtendDateCount); i++) {
                if (pmActionsIndicatorDetails.monthName == params.get("month" + (i + 1))) {
                    pmActionsIndicatorDetails.target = details.indicatorId == pmActionsIndicator.id ? params.get("target" + (i + 1)).toString().trim() != '' ? Integer.parseInt(params.get("target" + (i + 1)).toString()) : 0 : pmActionsIndicatorDetails.target
                    pmActionsIndicatorDetails.createBy = springSecurityService.principal.id
                    pmActionsIndicatorDetails.createDate = DateUtility.getSqlDate(new Date())
                    pmActionsIndicatorDetails.isExtended = details.indicatorId == pmActionsIndicator.id ? true : pmActionsIndicatorDetails.isExtended

                    pmActionsIndicatorDetails.save()
                    count++
                    break
                }
            }
            if (count == 0)
                pmActionsIndicatorDetails.delete()
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
