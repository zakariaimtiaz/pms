package actions.pmMcrsLog

import com.model.ListPmMcrsLogActionServiceModel
import com.model.ListPmSpLogActionServiceModel
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class ListPmMcrsLogActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        return params
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            try {

                long serviceId =0
                if(result.serviceId)
                 serviceId = Long.parseLong(result.serviceId.toString())
                Closure param = {
                    'eq'('serviceId', serviceId)
                }
                Map resultMap = super.getSearchResult(result, ListPmMcrsLogActionServiceModel,param)
                result.put(LIST, resultMap.list)
                result.put(COUNT, resultMap.count)
                return result
            }catch (Exception ex){
                Map resultMap = super.getSearchResult(result, ListPmMcrsLogActionServiceModel)
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
