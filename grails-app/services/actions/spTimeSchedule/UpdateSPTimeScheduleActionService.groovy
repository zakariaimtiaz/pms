package actions.spTimeSchedule

import com.model.ListSPTimeScheduleActionServiceModel
import com.pms.SPTimeSchedule
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class UpdateSPTimeScheduleActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String SP_TIME_SCHEDULE = "spTimeSchedule"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.from) || (!params.to)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            SPTimeSchedule oldObject = SPTimeSchedule.read(id)
            SPTimeSchedule spTimeSchedule = buildObject(params, oldObject)
            params.put(SP_TIME_SCHEDULE, spTimeSchedule)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SPTimeSchedule spTimeSchedule = (SPTimeSchedule) result.get(SP_TIME_SCHEDULE)
            spTimeSchedule.save()
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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        SPTimeSchedule spTimeSchedule = (SPTimeSchedule) result.get(SP_TIME_SCHEDULE)
        ListSPTimeScheduleActionServiceModel model = ListSPTimeScheduleActionServiceModel.read(spTimeSchedule.id)
        result.put(SP_TIME_SCHEDULE, model)
        return super.setSuccess(result, UPDATE_SUCCESS_MESSAGE)
    }

    /**
     *
     * @param result - map received from previous method
     * @return - map
     */
    public Map buildFailureResultForUI(Map params) {
        return params
    }

    private static SPTimeSchedule buildObject(Map parameterMap, SPTimeSchedule oldObject) {
        SPTimeSchedule spTimeSchedule = new SPTimeSchedule(parameterMap)
        Date fromDate,toDate
        String fromStr = parameterMap.from.toString()
        Calendar c = Calendar.getInstance();
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
        Date from = originalFormat.parse(fromStr);
        c.setTime(from);

        String toStr = parameterMap.to.toString()
        Calendar ce = Calendar.getInstance();
        Date to = originalFormat.parse(toStr);
        ce.setTime(to);
        ce.set(Calendar.DAY_OF_MONTH, ce.getActualMaximum(Calendar.DAY_OF_MONTH));

        fromDate = DateUtility.getSqlDate(c.getTime())
        toDate = DateUtility.getSqlDate(ce.getTime())

        oldObject.fromDate=fromDate
        oldObject.toDate=toDate
        oldObject.description=spTimeSchedule.description
        return oldObject
    }
}
