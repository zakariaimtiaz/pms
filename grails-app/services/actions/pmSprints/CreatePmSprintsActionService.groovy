package actions.pmSprints

import com.model.ListPmActionsActionServiceModel
import com.pms.PmObjectives
import com.pms.PmSprints
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class CreatePmSprintsActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Sprits has been saved successfully"
    private static final String WEIGHT_EXCEED = "Exceed weight measurement"
    private static final String SPRINTS_OBJECT = "pmSprints"

    private Logger log = Logger.getLogger(getClass())


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId && !params.goalId && !params.objectiveId && !params.actionsId && !params.sprints) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())
            long goalId = Long.parseLong(params.goalId.toString())
            long objectiveId = Long.parseLong(params.objectiveId.toString())
            Long actionsId = Long.parseLong(params.actionsId.toString())
            int weight = Long.parseLong(params.weight.toString())
            Date startDateStr = DateUtility.parseMaskedDate(params.start)
            Date endDateStr = DateUtility.parseMaskedDate(params.end)
            startDateStr = DateUtility.getSqlDate(startDateStr)
            endDateStr = DateUtility.getSqlDate(endDateStr)
            params.start = startDateStr
            params.end = endDateStr
            int c = (int) PmSprints.executeQuery("SELECT count(id) FROM PmActions WHERE startDate<='${startDateStr}' AND endDate >='${endDateStr}' AND id=${actionsId} ")[0]
            if (c < 1) {
                return super.setError(params, "Sorry! Date range exceed action's time duration. ")
            }
            int totalWeight = (int) PmSprints.executeQuery("select sum(weight) from PmSprints where actionsId=${actionsId}")[0]
            int available = 100 - totalWeight
            if (weight > available) {
                return super.setError(params, WEIGHT_EXCEED)
            }
            PmSprints sprints = buildObject(params, serviceId, goalId, objectiveId, actionsId)
            params.put(SPRINTS_OBJECT, sprints)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmSprints sprints = (PmSprints) result.get(SPRINTS_OBJECT)
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
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        PmSprints sprints = (PmSprints) result.get(SPRINTS_OBJECT)
        ListPmActionsActionServiceModel model = ListPmActionsActionServiceModel.read(sprints.id)
        result.put(SPRINTS_OBJECT, model)
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

    private static PmSprints buildObject(Map parameterMap, long serviceId, long goalId, long objectiveId,long actionsId) {

        List<PmSprints> max = PmSprints.executeQuery("SELECT COALESCE(MAX(tmpSeq),0) FROM PmSprints" +
                " WHERE serviceId=${serviceId} AND goalId=${goalId} AND objectiveId=${objectiveId} AND actionsId=${actionsId}")

        int con =(int) max[0]+1
        PmObjectives objectives = PmObjectives.read(objectiveId)
        PmSprints sprints = new PmSprints(parameterMap)
        sprints.serviceId = serviceId
        sprints.goalId = goalId
        sprints.objectiveId = objectiveId
        sprints.sequence = objectives.sequence+"."+con
        sprints.tmpSeq = con
        sprints.startDate=DateUtility.getSqlDate(parameterMap.start)
        sprints.endDate = DateUtility.getSqlDate(parameterMap.end)
        return sprints
    }
}
