package actions.pmActions

import com.pms.SpTimeSchedule
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class ListEditableActionsActionService extends BaseService implements ActionServiceIntf {

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

    @Transactional(readOnly = true)
    public Map execute(Map result) {
        try {
            SpTimeSchedule timeSchedule = SpTimeSchedule.findByIsActive(Boolean.TRUE)
            int year = Integer.parseInt(timeSchedule.activeYear)
            long serviceId = Long.parseLong(result.serviceId.toString())
            List lstVal = buildResultList(serviceId, year)
            result.put(LIST, lstVal)
            result.put(COUNT, lstVal.size())
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

    private List<GroovyRowResult> buildResultList(long serviceId,int year) {

        String query = """
                SELECT a.id id,a.service_id AS service_id,a.goal_id, a.sequence,
                        a.is_editable,a.actions,a.start,a.end,a.note remarks
                FROM pm_actions a
                JOIN pm_service_sector sc ON sc.id = a.service_id
                WHERE a.year = ${year} AND sc.id = ${serviceId}
                ORDER BY sc.id,a.year, a.goal_id, a.tmp_seq;;
        """
        List<GroovyRowResult> lstValue = executeSelectSql(query)
        return lstValue
    }
}
