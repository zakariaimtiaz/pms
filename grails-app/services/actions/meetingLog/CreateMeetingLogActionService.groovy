package actions.meetingLog

import com.model.ListMeetingLogActionServiceModel
import com.pms.MeetingLog
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility
import service.MeetingLogService

@Transactional
class CreateMeetingLogActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Log has been saved successfully"
    private static final String ALREADY_EXIST = "Meeting already held for this week"
    private static final String MEETING_LOG = "meetingLog"

    private Logger log = Logger.getLogger(getClass())

    MeetingLogService meetingLogService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())

            boolean isWeeklyMeetingHeld = meetingLogService.isWeeklyMeetingHeld(DateUtility.parseMaskedDate(params.heldOn.toString()),serviceId)

            if (isWeeklyMeetingHeld) {
                return super.setError(params, ALREADY_EXIST)
            }

            MeetingLog meetingLog = buildObject(params,serviceId)
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

    private static MeetingLog buildObject(Map parameterMap,long serviceId) {
        parameterMap.heldOn = DateUtility.getSqlDate(DateUtility.parseMaskedDate(parameterMap.heldOn.toString()))
        MeetingLog meetingLog = new MeetingLog(parameterMap)
        meetingLog.serviceId = serviceId
        return meetingLog
    }
}
