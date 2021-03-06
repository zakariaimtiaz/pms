package actions.secuser

import com.pms.SecUser
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import service.SecUserService

@Transactional
class DeleteSecUserActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "User has been deleted successfully"
    private static final String NOT_FOUND = "Selected user does not exits"
    private static final String ASSOCIATION_EXISTS = "Selected user is associated with roles"
    private static final String SEC_USER = "user"


    SecUserService secUserService

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long userId = Long.parseLong(params.id)
        SecUser user = secUserService.read(userId)
        if(!user){
            return super.setError(params, NOT_FOUND)
        }
        int count = secUserService.countByUsernameIlike(user)
        if(count > 0){
            return super.setError(params, ASSOCIATION_EXISTS)
        }
        params.put(SEC_USER, user)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SecUser user = (SecUser) result.get(SEC_USER)
            secUserService.delete(user)
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
