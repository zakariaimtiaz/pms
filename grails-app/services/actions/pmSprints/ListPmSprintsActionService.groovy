package actions.pmSprints

import com.model.ListPmSprintsActionServiceModel
import com.pms.SecRole
import com.pms.SecUser
import com.pms.SecUserSecRole
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class ListPmSprintsActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    public static final String PMS_ROLE_ACTION_USER = "PMS_ROLE_ACTION_USER"

    public Map executePreCondition(Map params) {
        return params
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            List<Long> lst = currentUserDepartmentList()
            SecUser user = currentUserObject()
            Boolean isActionUser = Boolean.FALSE
            List<SecUserSecRole> lstRole = SecUserSecRole.findAllBySecUser(user)
            SecRole role = SecRole.findByAuthority(PMS_ROLE_ACTION_USER)
            for(int i=0; i<lstRole.size(); i++){
                if(lstRole[i].secRole==role){
                    isActionUser = Boolean.TRUE
                }
            }
            if(isActionUser){
                long empId = currentUserEmployeeId()
                Closure additionalParam = {
                    'in'('serviceId', lst)
                    'eq'('actionResId', empId)
                }
                Map resultMap = super.getSearchResult(result, ListPmSprintsActionServiceModel.class,additionalParam)
                result.put(LIST, resultMap.list)
                result.put(COUNT, resultMap.count)
                return result
            }
            Closure additionalParam = {
                'in'('serviceId', lst)
            }
            Map resultMap = super.getSearchResult(result, ListPmSprintsActionServiceModel.class,additionalParam)
            result.put(LIST, resultMap.list)
            result.put(COUNT, resultMap.count)
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
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
     * Since there is no success message return the same map
     * @param result -map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return result
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     * @param result -map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
