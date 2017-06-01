package actions.edDashboard

import com.pms.EdDashboard
import com.pms.EdDashboard
import com.pms.EdDashboardIssues
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class DeleteEdDashboardIssueActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Data has been deleted successfully"
    private static final String NOT_FOUND = "Issue does not exits"
    private static final String EDDASHBOARD_OBJ = "pmEdDashboard"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id.toString())
        EdDashboard edDashboard = EdDashboard.findById(id)
        if(!edDashboard){
            return super.setError(params, NOT_FOUND)
        }
        params.put(EDDASHBOARD_OBJ, edDashboard)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            EdDashboard edDashboard = (EdDashboard) result.get(EDDASHBOARD_OBJ)
            edDashboard.delete()
            EdDashboardIssues edDashboardIssues=EdDashboardIssues.findById(edDashboard.issueId)
            if(edDashboardIssues.isAdditional) {
                List<EdDashboard> lstEdDashboard = EdDashboard.findAllByServiceIdAndMonthForAndIssueIdGreaterThan(edDashboard.serviceId, edDashboard.monthFor,edDashboard.issueId, [ sort: "issueId", order: "asc"])
                for (EdDashboard obj : lstEdDashboard) {
                    obj.issueId = obj.issueId - 1
                    obj.save()
                }
            }
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
