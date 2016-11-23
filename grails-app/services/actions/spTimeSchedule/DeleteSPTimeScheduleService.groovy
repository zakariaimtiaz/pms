package actions.spTimeSchedule

import com.pms.SpTimeSchedule
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class DeleteSPTimeScheduleService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Data has been deleted successfully"
    private static final String NOT_FOUND = "Selected data does not exits"
    private static final String SP_TIME_SCHEDULE = "spTimeSchedule"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id.toString())
        SpTimeSchedule spTimeSchedule = SpTimeSchedule.read(id)
        if(!spTimeSchedule){
            return super.setError(params, NOT_FOUND)
        }
        params.put(SP_TIME_SCHEDULE, spTimeSchedule)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SpTimeSchedule spTimeSchedule = (SpTimeSchedule) result.get(SP_TIME_SCHEDULE)
            spTimeSchedule.delete()
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
