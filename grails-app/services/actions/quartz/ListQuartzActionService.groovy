package actions.quartz

import com.model.ListQuartzActionServiceModel
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class ListQuartzActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        return params
    }

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            Map resultMap = super.getSearchResult(result, ListQuartzActionServiceModel.class)
            result.put(LIST, resultMap.list)
            result.put(COUNT, resultMap.count)
            return result
        } catch (Exception e) {
            log.error(e.getMessage())
            throw new RuntimeException(e)
        }
    }

    public Map executePostCondition(Map result) {
        return result
    }

    public Map buildSuccessResultForUI(Map result) {
        return result
    }


    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
