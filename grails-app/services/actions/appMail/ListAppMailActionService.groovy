package actions.appMail

import com.model.ListAppMailActionServiceModel
import org.apache.log4j.Logger
import org.springframework.transaction.annotation.Transactional
import pms.ActionServiceIntf
import pms.BaseService

class ListAppMailActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    /**
     * @param params -serialized parameters from UI
     */
    public Map executePreCondition(Map params) {
        return params
    }

    /**
     * get list and count of AppMail
     * @param params -serialized parameters from UI
     * @return -a map containing necessary objects
     */
    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            Map resultMap = super.getSearchResult(result, ListAppMailActionServiceModel.class)
            result.put(LIST, resultMap.list)
            result.put(COUNT, resultMap.count)
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * There is no postCondition, so return the same map as received
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * Since there is no success message return the same map
     * @param result - map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        return result
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     * @param result - map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}