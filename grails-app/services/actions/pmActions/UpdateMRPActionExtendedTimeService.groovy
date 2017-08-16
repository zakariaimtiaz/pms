package actions.pmActions

import com.pms.PmActions
import com.pms.PmActionsIndicator
import com.pms.PmActionsIndicatorDetails
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
                if (extendDate < pmActions.extendedEnd) {
                    for (PmActionsIndicator pmActionsIndicator in lstIndicator) {
                        if (pmActionsIndicator.isExtend && details.indicatorId != pmActionsIndicator.id) {
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

            if (params.selection == "CloseWithRemain") {
                canDelete=true
                DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

                Date end = originalFormat.parse(params.hfIndicatorDetailsMonth.toString());
                Calendar c = Calendar.getInstance();
                c.setTime(end);
                c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
                Date date = DateUtility.getSqlDate(c.getTime())
                for(PmActionsIndicator pmActionsIndicator in lstIndicator) {
                    if (details.indicatorId == pmActionsIndicator.id) {
                        pmActionsIndicator.closingNote = params.IndicatorClosingNote
                        pmActionsIndicator.closingMonth = date
                        pmActionsIndicator.isExtend = date == DateUtility.getSqlDate(pmActions.end) ? false : pmActionsIndicator.isExtend
                        pmActionsIndicator.save()
                    }
                    if(pmActionsIndicator.isExtend){
                        canDelete=false
                    }
                }
                if(canDelete) {
                    pmActions.extendedEnd = null
                    pmActions.save()
                    List<PmActionsIndicatorDetails> lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIsExtended(details.actionsId, true)
                    for (PmActionsIndicatorDetails etDetails in lstExtend) {
                        if ((etDetails.achievement==0||etDetails.achievement==null)&&(etDetails.remarks==''||etDetails.remarks==null))
                            etDetails.delete()
                    }
                }
                else{
                    List<PmActionsIndicatorDetails> lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIsExtended(details.actionsId,details.indicatorId, true)
                    for (PmActionsIndicatorDetails etDetails in lstExtend) {
                        etDetails.target=0
                        etDetails.save()
                    }
                }
            }
            else {
                DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

                Date start = originalFormat.parse(params.extendedEndMonth.toString());
                Calendar c = Calendar.getInstance();
                c.setTime(start);
                c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
                Date extendDate = DateUtility.getSqlDate(c.getTime())
                Boolean newEntry=false

                if (pmActions.extendedEnd == null || pmActions.extendedEnd == '') {
                    newEntry=true
                }
                else if(extendDate!=pmActions.extendedEnd) {
                    canDelete = true
                    for (PmActionsIndicator pmActionsIndicator in lstIndicator) {
                        if (pmActionsIndicator.isExtend && details.indicatorId != pmActionsIndicator.id) {
                            canDelete = false
                            break
                        }
                    }
                    if (canDelete) {
                        newEntry=true
                        List<PmActionsIndicatorDetails> lstExtend = PmActionsIndicatorDetails.findAllByActionsIdAndIsExtended(details.actionsId, true)
                        for (PmActionsIndicatorDetails etDetails in lstExtend) {
                            if ((etDetails.achievement==0||etDetails.achievement==null)&&(etDetails.remarks==''||etDetails.remarks==null))
                                etDetails.delete()
                        }
                    }
                }
                for (PmActionsIndicator pmActionsIndicator in lstIndicator) {
                    if (details.indicatorId == pmActionsIndicator.id) {
                        pmActionsIndicator.closingNote = null
                        pmActionsIndicator.closingMonth = null
                        pmActionsIndicator.isExtend = true
                        pmActionsIndicator.save()
                    }
                    if (newEntry) {
                        for (int i = 0; i < Integer.parseInt(params.hfExtendDateCount); i++) {
                            PmActionsIndicatorDetails pmActionsIndicatorDetails = new PmActionsIndicatorDetails()
                            pmActionsIndicatorDetails.actionsId = details.actionsId
                            pmActionsIndicatorDetails.indicatorId = pmActionsIndicator.id
                            pmActionsIndicatorDetails.monthName = params.get("month" + (i + 1))
                            pmActionsIndicatorDetails.target = details.indicatorId == pmActionsIndicator.id ? params.get("target" + (i + 1)).toString().trim()!=''? Integer.parseInt(params.get("target" + (i + 1)).toString()):0 : 0
                            pmActionsIndicatorDetails.createBy = springSecurityService.principal.id
                            pmActionsIndicatorDetails.createDate = DateUtility.getSqlDate(new Date())
                            pmActionsIndicatorDetails.isExtended = details.indicatorId == pmActionsIndicator.id ? true : pmActionsIndicatorDetails.isExtended

                            pmActionsIndicatorDetails.save()
                        }
                    }
                    else if (extendDate < pmActions.extendedEnd) {
                        List<PmActionsIndicatorDetails> lstExtendDetails = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIsExtended(pmActionsIndicator.actionsId, pmActionsIndicator.id, true)
                        for (PmActionsIndicatorDetails pmActionsIndicatorDetails in lstExtendDetails) {
                            int count = 0
                            for (int i = 0; i < Integer.parseInt(params.hfExtendDateCount); i++) {
                                if (pmActionsIndicatorDetails.monthName == params.get("month" + (i + 1))) {
                                    count++
                                    break
                                }
                            }
                            if (count == 0)
                                pmActionsIndicatorDetails.delete()
                        }

                    }
                    else if (extendDate > pmActions.extendedEnd) {
                        for (int i = 0; i < Integer.parseInt(params.hfExtendDateCount); i++) {
                        PmActionsIndicatorDetails pmActionsIndicatorDetails=PmActionsIndicatorDetails.findByActionsIdAndIndicatorIdAndMonthNameAndIsExtended(pmActionsIndicator.actionsId,pmActionsIndicator.id,params.get("month" + (i + 1)),true)
                                    if(pmActionsIndicatorDetails){
                                        if(details.indicatorId == pmActionsIndicator.id) {
                                            pmActionsIndicatorDetails.target = params.get("target" + (i + 1)).toString().trim()!=''?Integer.parseInt(params.get("target" + (i + 1)).toString()):0
                                            pmActionsIndicatorDetails.createBy = springSecurityService.principal.id
                                            pmActionsIndicatorDetails.createDate = DateUtility.getSqlDate(new Date())
                                            pmActionsIndicatorDetails.isExtended = true
                                            pmActionsIndicatorDetails.save()
                                        }
                                    }else {
                                        pmActionsIndicatorDetails=new PmActionsIndicatorDetails()
                                        pmActionsIndicatorDetails.actionsId = details.actionsId
                                        pmActionsIndicatorDetails.indicatorId = pmActionsIndicator.id
                                        pmActionsIndicatorDetails.monthName = params.get("month" + (i + 1))
                                        pmActionsIndicatorDetails.target = details.indicatorId == pmActionsIndicator.id ? params.get("target" + (i + 1)).toString()!=''?Integer.parseInt(params.get("target" + (i + 1)).toString()) : 0:0
                                        pmActionsIndicatorDetails.createBy = springSecurityService.principal.id
                                        pmActionsIndicatorDetails.createDate = DateUtility.getSqlDate(new Date())
                                        pmActionsIndicatorDetails.isExtended = details.indicatorId == pmActionsIndicator.id ? true : false
                                        pmActionsIndicatorDetails.save()
                                    }
                        }
                    } else {
                        if (pmActionsIndicator.id == details.indicatorId ) {
                            List<PmActionsIndicatorDetails> lstExtendDetails = PmActionsIndicatorDetails.findAllByActionsIdAndIndicatorIdAndIsExtended(pmActionsIndicator.actionsId, pmActionsIndicator.id, true)
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
                pmActions.extendedEnd = extendDate
                pmActions.save()
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
