package actions.secRole

import com.model.ListSecRoleActionServiceModel
import com.pms.SecUser
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class ListSecRoleActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    /**
     * No pre conditions required for searching project domains
     *
     * @param params - Request parameters
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePreCondition(Map params) {
        return params
    }

    /**
     * 1. initialize params for pagination of list
     *
     * 2. pull all appUser list from database (if no criteria)
     *
     * 3. pull filtered result from database (if given criteria)
     *
     * @param result - parameter from pre-condition
     * @return - same map of input-parameter containing isError(true/false)
     */
    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            SecUser user = currentUserObject()
            boolean isHOD = isUserHOD(user.id)
            if(isHOD){
                List lstVal = buildResultList(user.serviceId)
                result.put(LIST, lstVal)
                result.put(COUNT, lstVal.size())
                return result
            }
            Closure param = {
                'eq'('appsId', 1L)
            }
            Map resultMap = super.getSearchResult(result, ListSecRoleActionServiceModel.class,param)
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

    private List<GroovyRowResult> buildResultList(long serviceId) {
        String query = """
            SELECT role.id, role.version, role.name,role.authority, COUNT(au.id) AS count
                FROM sec_role AS role
                    LEFT JOIN sec_user_sec_role ur ON ur.sec_role_id = role.id
                    LEFT JOIN sec_user au ON au.id = ur.sec_user_id AND au.enabled = TRUE
                              AND au.service_id = ${serviceId}
                WHERE role.id IN (3,5)
                    GROUP BY role.id,role.name,role.authority,role.version;
        """
        List<GroovyRowResult> lstValue = groovySql_comn.rows(query)
        return lstValue
    }
}
