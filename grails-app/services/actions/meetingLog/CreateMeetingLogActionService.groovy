package actions.meetingLog

import com.model.ListMeetingLogActionServiceModel
import com.pms.MeetingCategory
import com.pms.MeetingLog
import com.pms.SystemEntity
import com.pms.SystemEntityType
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility
import service.MeetingLogService

@Transactional
class CreateMeetingLogActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Log has been saved successfully"
    private static final String ALREADY_EXIST_WEEK = "Meeting already held for this week"
    private static final String ALREADY_EXIST_MONTH = "Meeting already held for this month"
    private static final String MEETING_LOG = "meetingLog"
    private static final String WEEKLY = "Weekly"
    private static final String MONTHLY = "Monthly"
    private static final String CATEGORY = "Meeting Category"
    private static final String INTERNAL = "Inter Department"

    private Logger log = Logger.getLogger(getClass())

    MeetingLogService meetingLogService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())
            long meetingTypeId = Long.parseLong(params.meetingTypeId.toString())
            SystemEntity meetingType = SystemEntity.read(meetingTypeId)
            Date date = DateUtility.parseMaskedDate(params.heldOn.toString())
            long catId = 0L

            if(meetingType.name.equals(WEEKLY)){
                catId = MeetingCategory.findByMeetingTypeIdAndName(meetingType.id, INTERNAL).id
                boolean isWeeklyMeetingHeld = meetingLogService.isWeeklyMeetingHeld(date,serviceId,meetingTypeId)
                if (isWeeklyMeetingHeld) {
                    return super.setError(params, ALREADY_EXIST_WEEK)
                }
            }else if(meetingType.name.equals(MONTHLY)){
                catId = Long.parseLong(params.meetingCatId.toString())
                boolean isMonthlyMeetingHeld = meetingLogService.isMonthlyMeetingHeld(date,serviceId,meetingTypeId,catId)
                if (isMonthlyMeetingHeld) {
                    return super.setError(params, ALREADY_EXIST_MONTH)
                }
            }

            MeetingLog meetingLog = buildObject(params,serviceId, catId)
            params.put(MEETING_LOG, meetingLog)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            MeetingLog meetingLog = (MeetingLog) result.get(MEETING_LOG)
            meetingLog.save()
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
        MeetingLog meetingLog = (MeetingLog) result.get(MEETING_LOG)
        ListMeetingLogActionServiceModel model = ListMeetingLogActionServiceModel.read(meetingLog.id)
        result.put(MEETING_LOG, model)
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

    private static MeetingLog buildObject(Map parameterMap,long serviceId, long catId) {
        parameterMap.heldOn = DateUtility.getSqlDate(DateUtility.parseMaskedDate(parameterMap.heldOn.toString()))
        MeetingLog meetingLog = new MeetingLog(parameterMap)
        meetingLog.serviceId = serviceId
        meetingLog.meetingCatId = catId
        return meetingLog
    }
}
