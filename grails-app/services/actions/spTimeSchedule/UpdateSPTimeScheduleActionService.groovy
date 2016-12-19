package actions.spTimeSchedule

import com.model.ListSpTimeScheduleActionServiceModel
import com.pms.SpTimeSchedule
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
            if (!params.id && !params.from && !params.to) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            SpTimeSchedule oldObject = SpTimeSchedule.read(id)
            SpTimeSchedule spTimeSchedule = buildObject(params, oldObject)
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
            SpTimeSchedule spTimeSchedule = (SpTimeSchedule) result.get(SP_TIME_SCHEDULE)
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
        SpTimeSchedule spTimeSchedule = (SpTimeSchedule) result.get(SP_TIME_SCHEDULE)
        ListSpTimeScheduleActionServiceModel model = ListSpTimeScheduleActionServiceModel.read(spTimeSchedule.id)
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

    private static SpTimeSchedule buildObject(Map parameterMap, SpTimeSchedule oldObject) {
        Date fromDate,toDate
        String fromStr = parameterMap.from.toString()
        Calendar c = Calendar.getInstance();
        DateFormat originalFormat = new SimpleDateFormat("yyyy", Locale.ENGLISH);
        Date from = originalFormat.parse(fromStr);
        c.setTime(from);

        String toStr = parameterMap.to.toString()
        Calendar ce = Calendar.getInstance();
        Date to = originalFormat.parse(toStr);
        ce.setTime(to);
        ce.set(Calendar.MONTH,ce.getActualMaximum(Calendar.MONTH));
        ce.set(Calendar.DAY_OF_MONTH, ce.getActualMaximum(Calendar.DAY_OF_MONTH));

        String activeYear = parameterMap.activeYear.toString()
        Date year = originalFormat.parse(activeYear);
        Calendar cp = Calendar.getInstance();
        cp.setTime(year);
        String yearStr = new SimpleDateFormat("YYYY").format(cp.getTime())

        fromDate = DateUtility.getSqlDate(c.getTime())
        toDate = DateUtility.getSqlDate(ce.getTime())

        SpTimeSchedule spTimeSchedule = new SpTimeSchedule(parameterMap)
        oldObject.fromDate=fromDate
        oldObject.toDate=toDate
        oldObject.activeYear = yearStr
        oldObject.isActive = spTimeSchedule.isActive
        oldObject.description=spTimeSchedule.description
        return oldObject
    }
}
