package actions.pmMcrsLog

import com.model.ListPmMcrsLogActionServiceModel
import com.model.ListPmSpLogActionServiceModel
import com.pms.PmMcrsLog
import com.pms.PmSpLog
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class CreatePmMcrsLogActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "MCRS has been saved successfully"
    private static final String ALREADY_EXIST = "CSU/Sector for this year and month already submitted"
    private static final String PM_MCRS_LOG = "pmMcrsLog"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId && !params.month) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())
            String startDateStr = params.month.toString()
            DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

            Date start = originalFormat.parse(startDateStr);
            Calendar c = Calendar.getInstance();
            c.setTime(start);
            //c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
            //Date monthFor = DateUtility.getSqlDate(c.getTime())

            int month = c.get(Calendar.MONTH);
            int year = c.get(Calendar.YEAR);

            int count = PmMcrsLog.countByServiceIdAndYearAndMonthAndIsSubmitted(serviceId, year, month+1,true)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            PmMcrsLog pmMcrsLog = buildObject(params, serviceId, year, month+1)
            params.put(PM_MCRS_LOG, pmMcrsLog)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmMcrsLog pmMcrsLog = (PmMcrsLog) result.get(PM_MCRS_LOG)
            pmMcrsLog.save()
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

    private static PmMcrsLog buildObject(Map parameterMap, long serviceId, int year, int month) {
        PmMcrsLog pmMcrsLog = PmMcrsLog.findByServiceIdAndYearAndMonthAndIsSubmitted(serviceId, year, month,true)
        if(!pmMcrsLog){
            pmMcrsLog = new PmMcrsLog()
            pmMcrsLog.serviceId = serviceId
            pmMcrsLog.year = year
            pmMcrsLog.month = month
            SimpleDateFormat month_date = new SimpleDateFormat("MMMM");
            String month_name = month_date.format(month);
            pmMcrsLog.monthStr = month_name
        }

        pmMcrsLog.isSubmitted = true
        pmMcrsLog.isEditable = false
        pmMcrsLog.submissionDate = DateUtility.getSqlDate(new Date())

        return pmMcrsLog
    }
}
