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

    BaseService baseService
    PmActionsService pmActionsService
    private static final String UPDATE_SUCCESS_MESSAGE = "Achievement has been updated successfully"
    private static final String MRP_LOCKED_MSG = "MRP is locked for this month"
    private static final String MRP_SUBMITTED_MSG = "MRP already submitted"
    boolean canDelete = true

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.hfIndicatorDetailsId && !params.hfIndicatorDetailsAcv) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            if (params.selection == "CloseWithRemain" && !params.IndicatorClosingNote) {
                return super.setError(params, INVALID_INPUT_MSG)
            } else if (params.selection == "ExtendMonth" && !params.extendedEndMonth) {
                return super.setError(params, "Invalid extended end month")
            }
            long id = Long.parseLong(params.hfIndicatorDetailsId)
            PmActionsIndicatorDetails details = PmActionsIndicatorDetails.read(id)
            PmActions pmActions = PmActions.findById(details.actionsId)
            /* if(params.selection == "ExtendMonth"){
                 DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

                 Date start = originalFormat.parse(params.extendedEndMonth.toString());
                 Calendar c = Calendar.getInstance();
                 c.setTime(start);
                 c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                 Date extendDate = DateUtility.getSqlDate(c.getTime())
                 boolean canMinimize=true
                 if (extendDate < pmActions.end) {
                     List<PmActionsIndicator> lstIndicator=PmActionsIndicator.findAllByActionsIdNotEqual(details.actionsId)
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
             }*/

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
            String lastMRPSubDate = baseService.lastMRPSubmissionDate(pmActions.serviceId)
            PmActionsExtendHistory pmActionsExtendHistory = PmActionsExtendHistory.findByActionsId(pmActions.id, [max: 1, sort: 'id', order: 'desc'])
            c = Calendar.getInstance();
            c.setTime(DateUtility.parseDateForDB(lastMRPSubDate));
            c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
            Date subDate = DateUtility.getSqlDate(c.getTime())

            if (params.selection == "CloseWithRemain") {
                canDelete = pmActionsService.canDeleteActionDetails(details.actionsId, details.indicatorId, details.id, subDate)

                PmActionsIndicator pmActionsIndicator = PmActionsIndicator.findByActionsIdAndId(details.actionsId, details.indicatorId)
                pmActionsIndicator.closingNote = params.IndicatorClosingNote
                pmActionsIndicator.closingMonth = mrpEntryMonth
                // pmActionsIndicator.isExtended = mrpEntryMonth == DateUtility.getSqlDate(pmActions.end) ? false : pmActionsIndicator.isExtended
                boolean isExtended = false
                List<PmActionsIndicatorDetails> lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIdLessThanEquals(details.actionsId, pmActionsIndicator.id, details.id)
                for (PmActionsIndicatorDetails etDetails in lstExtend) {
                    if (etDetails.isExtended) {
                        isExtended = true
                        break
                    }
                }
                pmActionsIndicator.isExtended = isExtended
                pmActionsIndicator.save()

                if (pmActionsExtendHistory) {
                    if (canDelete) {
                        pmActions.end = pmActionsExtendHistory.end
                        pmActions.save()
                        pmActionsExtendHistory.delete()

                        lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIdNotLessThanEqualsAndCreateDateGreaterThanEquals(details.actionsId, details.id, DateUtility.parseDateForDB(lastMRPSubDate))
                        for (PmActionsIndicatorDetails etDetails in lstExtend) {
                            if (details.monthName != etDetails.monthName)
                                etDetails.delete()
                        }
                    } else {
                        lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIdGreaterThanAndIsExtended(details.actionsId, details.indicatorId, details.id, true)
                        for (PmActionsIndicatorDetails etDetails in lstExtend) {
                            etDetails.target = 0
                            etDetails.isExtended = false
                            etDetails.save()
                        }
                    }
                }
            } else {
                Date start = originalFormat.parse(params.extendedEndMonth.toString());
                c = Calendar.getInstance();
                c.setTime(start);
                c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                Date extendDate = DateUtility.getSqlDate(c.getTime())
                Boolean newEntry = false
                if (!pmActionsExtendHistory) {
                    newEntry = true
                } else if (pmActionsExtendHistory.end == null || subDate > DateUtility.getSqlDate(pmActionsExtendHistory.end)) {
                    newEntry = true
                }
                PmActionsIndicator pmActionsIndicator = PmActionsIndicator.findById(details.indicatorId)
                if (details.indicatorId == pmActionsIndicator.id) {
                    pmActionsIndicator.closingNote = null
                    pmActionsIndicator.closingMonth = null
                    pmActionsIndicator.isExtended = true
                    pmActionsIndicator.save()
                }
                if (newEntry) {
                    EntryForNewEntry(params, details)

                    pmActionsExtendHistory = new PmActionsExtendHistory()
                    pmActionsExtendHistory.end = pmActions.end
                    pmActionsExtendHistory.actionsId = pmActions.id
                    pmActionsExtendHistory.save()

                    pmActions.end = extendDate
                    pmActions.save()

                } else if (extendDate < pmActions.end) {
                    entryForMinimizeExtendDate(params, details, pmActions)
                } else if (extendDate > pmActions.end) {
                    entryForGreaterExtendedDate(params, details)

                    pmActions.end = extendDate
                    pmActions.save()
                } else {
                    entryForUpdateTargetInExtendedMonth(details, params)
                }
            }

            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    private void entryForUpdateTargetInExtendedMonth(PmActionsIndicatorDetails details, Map params) {
        List<PmActionsIndicator> lstIndicator = PmActionsIndicator.findAllByActionsId(details.actionsId)
        for (PmActionsIndicator pmActionsIndicator in lstIndicator) {
            if (pmActionsIndicator.id == details.indicatorId) {
                List<PmActionsIndicatorDetails> lstExtendDetails = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIdNotLessThanEquals(pmActionsIndicator.actionsId, pmActionsIndicator.id, details.id)
                for (PmActionsIndicatorDetails pmActionsIndicatorDetails in lstExtendDetails) {
                    for (int i = 0; i < Integer.parseInt(params.hfExtendDateCount); i++) {
                        if (pmActionsIndicatorDetails.monthName == params.get("month" + (i + 1))) {
                            pmActionsIndicatorDetails.actionsId = details.actionsId
                            pmActionsIndicatorDetails.indicatorId = pmActionsIndicator.id
                            pmActionsIndicatorDetails.monthName = params.get("month" + (i + 1))
                            pmActionsIndicatorDetails.target = details.indicatorId == pmActionsIndicator.id ? params.get("target" + (i + 1)).toString().trim() != '' ? Integer.parseInt(params.get("target" + (i + 1)).toString()) : 0 : pmActionsIndicatorDetails.target
                            pmActionsIndicatorDetails.createBy = springSecurityService.principal.id
                            pmActionsIndicatorDetails.createDate = DateUtility.getSqlDate(new Date())
                            pmActionsIndicatorDetails.isExtended = details.indicatorId == pmActionsIndicator.id ? true : pmActionsIndicatorDetails.isExtended

                            pmActionsIndicatorDetails.save()
                        }
                    }
                }
            }
            break;
        }
    }

    private void EntryForNewEntry(Map params, PmActionsIndicatorDetails details) {
        List<PmActionsIndicator> lstIndicator = PmActionsIndicator.findAllByActionsId(details.actionsId)
        for (PmActionsIndicator pmActionsIndicator in lstIndicator) {
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

    }

    private void entryForGreaterExtendedDate(Map params, PmActionsIndicatorDetails details) {
        List<PmActionsIndicator> lstIndicator = PmActionsIndicator.findAllByActionsId(details.actionsId)
        for (PmActionsIndicator pmActionsIndicator in lstIndicator) {
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
                    pmActionsIndicatorDetails.isExtended = details.indicatorId == pmActionsIndicator.id ? true : false
                    pmActionsIndicatorDetails.save()
                }
            }
        }
    }

    private void entryForMinimizeExtendDate( Map params, PmActionsIndicatorDetails details, PmActions pmActions) {
        boolean isDelete=false
            List<PmActionsIndicatorDetails> lstExtendDetails = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIdNotLessThanEquals(details.actionsId, details.indicatorId, details.id)
            for (PmActionsIndicatorDetails pmActionsIndicatorDetails in lstExtendDetails) {
                int count=0
                for (int i = 0; i < Integer.parseInt(params.hfExtendDateCount); i++) {
                    if (pmActionsIndicatorDetails.monthName == params.get("month" + (i + 1))) {
                        pmActionsIndicatorDetails.target = params.get("target" + (i + 1)).toString().trim() != '' ? Integer.parseInt(params.get("target" + (i + 1)).toString()) : 0
                        pmActionsIndicatorDetails.createBy = springSecurityService.principal.id
                        pmActionsIndicatorDetails.createDate = DateUtility.getSqlDate(new Date())
                        pmActionsIndicatorDetails.isExtended = true
                        pmActionsIndicatorDetails.save()
                        count++
                        break
                    }
                }
                if(count==0){
                    List<PmActionsIndicatorDetails> lstIndDetails = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdNotEqualAndMonthNameAndIsExtended(pmActionsIndicatorDetails.actionsId,pmActionsIndicatorDetails.indicatorId, pmActionsIndicatorDetails.monthName, true)
                    if (lstIndDetails.size() <= 0) {
                        List<PmActionsIndicatorDetails> lstDetails=PmActionsIndicatorDetails.findAllByActionsIdAndMonthName(pmActionsIndicatorDetails.actionsId,pmActionsIndicatorDetails.monthName)
                        for(PmActionsIndicatorDetails pmActionsIndicatorDetails1 in lstDetails) {
                            pmActionsIndicatorDetails1.delete()
                            isDelete=true
                        }
                    }
                    else{
                        pmActionsIndicatorDetails.target = 0
                        pmActionsIndicatorDetails.isExtended = false
                        pmActionsIndicatorDetails.save()
                    }
                }
            }
        if(isDelete){
            PmActionsIndicatorDetails pmActionsIndicatorDetails=PmActionsIndicatorDetails.findByActionsIdAndIsExtended(details.actionsId,true, [max: 1, sort: 'id', order: 'desc'])
            Date en =new Date().parse("MMMM", pmActionsIndicatorDetails.monthName)

            Calendar c = Calendar.getInstance();
            c.setTime(en);
            c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
            c.set(Calendar.YEAR,pmActions.year)
            Date extendDate = DateUtility.getSqlDate(c.getTime())

            pmActions.end = extendDate
            pmActions.save()
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
