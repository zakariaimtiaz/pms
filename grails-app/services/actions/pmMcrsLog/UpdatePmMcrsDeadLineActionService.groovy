package actions.pmMcrsLog

import com.pms.PmMcrsLog
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class UpdatePmMcrsDeadLineActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "MCRS deadline has been updated successfully"
    private static final String UPDATE_FAILED_MSG = "MCRS deadline update failed"
    private static final String NOT_FOUND = "No log found to set deadline"
    private static final String PM_MCRS_LOG_MONTH = "month"
    private static final String PM_MCRS_LOG_YEAR = "year"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.modalMCRSMonth && !params.modalMCRSDeadLine) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            String startDateStr = params.modalMCRSMonth.toString()
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

            Date start = originalFormat.parse(startDateStr);
            Calendar c = Calendar.getInstance();
            c.setTime(start);
            int month = c.get(Calendar.MONTH)+ 1;
            int year = c.get(Calendar.YEAR);

            int count = PmMcrsLog.countByYearAndMonth(year, month)
            if (count == 0) {
                return super.setError(params, NOT_FOUND)
            }
            params.put(PM_MCRS_LOG_MONTH, month)
            params.put(PM_MCRS_LOG_YEAR, year)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            int month = (int) result.get(PM_MCRS_LOG_MONTH)
            int year = (int) result.get(PM_MCRS_LOG_YEAR)
            Date deadLine = DateUtility.getSqlDate(DateUtility.parseMaskedDate(result.modalMCRSDeadLine.toString()))
            int count = updateMcrsDeadLine(month, year, deadLine)
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

    private int updateMcrsDeadLine(int month,int year,Date deadLine) {
        String query = """
        UPDATE pm_mcrs_log SET dead_line = '${deadLine}' WHERE month = ${month} and year = ${year}
        """
        return executeUpdateSql(query)
    }
}
