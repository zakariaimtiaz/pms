package actions.pmSpLog

import com.model.ListPmSpLogActionServiceModel
import com.pms.SecUser
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class ListPmSpLogActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        return params
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            if (result.containsKey("year")) {
                Closure param = {
                    'eq'('year', Integer.parseInt(result.year.toString()))
                }
                Map resultMap = super.getSearchResult(result, ListPmSpLogActionServiceModel, param)
                result.put(LIST, resultMap.list)
                result.put(COUNT, resultMap.count)
                return result
            } else {
                SecUser user = currentUserObject()
                Closure param = {
                    'eq'('serviceId', user.serviceId)
                }
                Map resultMap = super.getSearchResult(result, ListPmSpLogActionServiceModel, param)
                result.put(LIST, resultMap.list)
                result.put(COUNT, resultMap.count)
                return result
            }
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
