package actions.edDashboard

import com.model.ListEdDashboardActionServiceModel
import com.model.ListPmMissionsActionServiceModel
import com.pms.EdDashboard
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class UpdateEdDashboardActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Mission has been updated successfully"
    private static final String ED_DASHBOARD = "edDashboard"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.serviceId) || (!params.mission)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            EdDashboard oldObject = EdDashboard.read(id)
            EdDashboard edDashboard = buildObject(params, oldObject)
            params.put(ED_DASHBOARD, edDashboard)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            EdDashboard edDashboard = (EdDashboard) result.get(ED_DASHBOARD)
            edDashboard.save()
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
        EdDashboard edDashboard = (EdDashboard) result.get(ED_DASHBOARD)
        ListEdDashboardActionServiceModel model = ListEdDashboardActionServiceModel.read(edDashboard.id)
        result.put(ED_DASHBOARD, model)
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

    private static EdDashboard buildObject(Map parameterMap, EdDashboard oldObject) {
        String startDateStr = parameterMap.month.toString()
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

        Date start = originalFormat.parse(startDateStr);
        Calendar c = Calendar.getInstance();
        c.setTime(start);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));
        parameterMap.month = DateUtility.getSqlDate(c.getTime())

        EdDashboard edDashboard = new EdDashboard(parameterMap)
        oldObject.description = edDashboard.description
        oldObject.edAdvice = edDashboard.edAdvice
        oldObject.issueId = edDashboard.description
        oldObject.description = edDashboard.description
        oldObject.description = edDashboard.description
        oldObject.description = edDashboard.description
        return oldObject
    }
}
