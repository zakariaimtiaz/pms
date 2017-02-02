package actions.pmMcrsLog

import com.model.ListPmMcrsLogActionServiceModel
import com.pms.PmMcrsLog
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

import java.text.DateFormat
import java.text.DateFormatSymbols
import java.text.SimpleDateFormat

@Transactional
class CreatePmMcrsLogActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "MCRS has been saved successfully"
    private static final String ALREADY_EXIST = "Entry already submitted"
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
            int month = c.get(Calendar.MONTH);
            int year = c.get(Calendar.YEAR);

            int count = PmMcrsLog.countByServiceIdAndYearAndMonth(serviceId, year, month + 1)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            PmMcrsLog pmMcrsLog = buildObject(params, serviceId, year, month)
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
        PmMcrsLog log = (PmMcrsLog) result.get(PM_MCRS_LOG)
        ListPmMcrsLogActionServiceModel model = ListPmMcrsLogActionServiceModel.read(log.id)
        result.put(PM_MCRS_LOG, model)
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
        String monthString = new DateFormatSymbols().getMonths()[month]
        parameterMap.year = year
        parameterMap.month = month + 1
        PmMcrsLog pmMcrsLog = new PmMcrsLog(parameterMap)
        pmMcrsLog.serviceId = serviceId
        pmMcrsLog.monthStr = monthString
        pmMcrsLog.isSubmitted = false
        pmMcrsLog.isEditable = true
        return pmMcrsLog
    }
}
