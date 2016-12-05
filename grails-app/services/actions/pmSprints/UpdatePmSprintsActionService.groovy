package actions.pmSprints

import com.model.ListPmSprintsActionServiceModel
import com.pms.PmSprints
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility
import service.PmActionsService

@Transactional
class UpdatePmSprintsActionService extends BaseService implements ActionServiceIntf {

    PmActionsService pmActionsService
    private static final String UPDATE_SUCCESS_MESSAGE = "Sprints has been updated successfully"
    private static final String WEIGHT_EXCEED = "Exceed weight measurement"
    private static final String SPRINTS_OBJ = "pmSprints"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId && !params.goalId && !params.actionsId && !params.sprints) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            Long actionsId = Long.parseLong(params.actionsId.toString())
            Date startDateStr = DateUtility.parseMaskedDate(params.start)
            Date endDateStr = DateUtility.parseMaskedDate(params.end)
            startDateStr = DateUtility.getSqlDate(startDateStr)
            endDateStr = DateUtility.getSqlDate(endDateStr)
            params.start = startDateStr
            params.end = endDateStr
            boolean isWithin = pmActionsService.taskDateWithinActionsDate(startDateStr,endDateStr,actionsId)
            if (!isWithin) {
                return super.setError(params, "Sorry! Date range exceed action's time duration. ")
            }

            int weight = Long.parseLong(params.weight.toString())
            int totalWeight =0
            List lst = PmSprints.executeQuery("select sum(weight) from PmSprints where actionsId=${actionsId} AND id<>${id}")
            if(lst[0]) totalWeight = (int)lst[0]
            int available = 100-totalWeight
            if(weight>available){
                return super.setError(params, WEIGHT_EXCEED)
            }
            PmSprints oldObject = (PmSprints) PmSprints.read(id)
            PmSprints sprints = buildObject(params, oldObject)
            params.put(SPRINTS_OBJ, sprints)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmSprints sprints = (PmSprints) result.get(SPRINTS_OBJ)
            sprints.save()
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
        PmSprints sprints = (PmSprints) result.get(SPRINTS_OBJ)
        ListPmSprintsActionServiceModel model = ListPmSprintsActionServiceModel.read(sprints.id)
        result.put(SPRINTS_OBJ, model)
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

    private static PmSprints buildObject(Map parameterMap, PmSprints oldObject) {


        PmSprints sprints = new PmSprints(parameterMap)
        oldObject.sprints = sprints.sprints
        oldObject.actionsId = Long.parseLong(parameterMap.actionsId)
        oldObject.weight = sprints.weight
        oldObject.target = sprints.target
        oldObject.resPerson = sprints.resPerson
        oldObject.supportDepartment = sprints.supportDepartment
        oldObject.remarks = sprints.remarks
        oldObject.startDate=DateUtility.getSqlDate(parameterMap.start)
        oldObject.endDate = DateUtility.getSqlDate(parameterMap.end)
        oldObject.resPersonId=sprints.resPersonId

        return oldObject
    }
}
