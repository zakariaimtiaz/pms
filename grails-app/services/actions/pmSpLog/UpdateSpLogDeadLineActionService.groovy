package actions.pmSpLog

import com.pms.PmSpLog
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class UpdateSpLogDeadLineActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "SP deadline has been updated successfully"
    private static final String UPDATE_FAILED_MSG = "SP deadline update failed"
    private static final String NOT_FOUND = "No SP found to set deadline"
    private static final String PM_SP_LOG_YEAR = "year"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.modalSPYear && !params.modalSPDeadLine) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int year = Integer.parseInt(params.modalSPYear.toString())
            int count = PmSpLog.countByYear(year)
            if (count == 0) {
                return super.setError(params, NOT_FOUND)
            }
            params.put(PM_SP_LOG_YEAR, year)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            int year = (int) result.get(PM_SP_LOG_YEAR)
            Date deadLine = DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.modalSPDeadLine.toString()))
            int count = updateSPDeadLine(year, deadLine)
            if(count == 0){
                return super.setError(result, UPDATE_FAILED_MSG)
            }
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     *
     * @param result - map received from execute method
     * @return - map
     */
    public Map executePostCondition(Map result) {
        return result
    }
    /**
     *
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        return super.setSuccess(result, SAVE_SUCCESS_MESSAGE)
    }
    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }

    private int updateSPDeadLine(int year,Date deadLine) {
        String query = """
        UPDATE pm_sp_log SET dead_line = '${deadLine}' WHERE year = ${year}
        """
        return executeUpdateSql(query)
    }
}
