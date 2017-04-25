package actions.meetingLog

import com.pms.MeetingLog
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class DeleteMeetingLogActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Log has been deleted successfully"
    private static final String NOT_FOUND = "Selected log does not exits"
    private static final String MEETING_LOG = "meetingLog"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id.toString())
        MeetingLog meetingLog = MeetingLog.read(id)
        if(!meetingLog){
            return super.setError(params, NOT_FOUND)
        }
        params.put(MEETING_LOG, meetingLog)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            MeetingLog meetingLog = (MeetingLog) result.get(MEETING_LOG)
            meetingLog.delete()
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * There is no postCondition, so return the same map as received
     *
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * 1. put success message
     *
     * @param result - map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, DELETE_SUCCESS_MESSAGE)
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     *
     * @param result - map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
