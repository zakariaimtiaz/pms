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
class CreateSPTimeScheduleActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Data has been saved successfully"
    private static final String ALREADY_EXIST = "Time Schedule already exist"
    private static final String SP_TIME_SCHEDULE = "spTimeSchedule"

    private Logger log = Logger.getLogger(getClass())



    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.from&&!params.to) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            Date fromDate,toDate
            String fromStr = params.from.toString()
            Calendar c = Calendar.getInstance();
            DateFormat originalFormat = new SimpleDateFormat("yyyy", Locale.ENGLISH);
            Date from = originalFormat.parse(fromStr);
            c.setTime(from);

            String toStr = params.to.toString()
            Calendar ce = Calendar.getInstance();
            Date to = originalFormat.parse(toStr);
            ce.setTime(to);
            ce.set(Calendar.MONTH,ce.getActualMaximum(Calendar.MONTH));
            ce.set(Calendar.DAY_OF_MONTH, ce.getActualMaximum(Calendar.DAY_OF_MONTH));

            fromDate = DateUtility.getSqlDate(c.getTime())
            toDate = DateUtility.getSqlDate(ce.getTime())
            int count = SpTimeSchedule.countByFromDateAndToDate(fromDate,toDate)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            params.from=fromDate
            params.to=toDate

            String activeYear = params.activeYear.toString()
            Date year = originalFormat.parse(activeYear);
            Calendar cp = Calendar.getInstance();
            cp.setTime(year);
            String yearStr = new SimpleDateFormat("YYYY").format(cp.getTime())
            params.activeYear = yearStr

            SpTimeSchedule spTimeSchedule = buildObject(params)
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
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        SpTimeSchedule spTimeSchedule = (SpTimeSchedule) result.get(SP_TIME_SCHEDULE)
        ListSpTimeScheduleActionServiceModel model = ListSpTimeScheduleActionServiceModel.read(spTimeSchedule.id)
        result.put(SP_TIME_SCHEDULE, model)
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

    private static SpTimeSchedule buildObject(Map parameterMap) {
        SpTimeSchedule service = new SpTimeSchedule(parameterMap)
        service.fromDate=DateUtility.getSqlDate(parameterMap.from)
        service.toDate=DateUtility.getSqlDate(parameterMap.to)
        return service
    }
}
