package actions.pmSprints

import com.model.ListPmSprintsActionServiceModel
import com.pms.PmActions
import com.pms.PmObjectives
import com.pms.PmSprints
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility
import service.PmActionsService

@Transactional
class CreatePmSprintsActionService extends BaseService implements ActionServiceIntf {

    PmActionsService pmActionsService
    SpringSecurityService springSecurityService
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

            boolean isWithin = pmActionsService.taskDateWithinActionsDate(startDateStr,endDateStr,actionsId)
            if (!isWithin) {
                return super.setError(params, "Sorry! Date range exceed action's time duration. ")
            }
            int totalWeight =0
                    List lst= PmSprints.executeQuery("select sum(weight) from PmSprints where actionsId=${actionsId}")
            if(lst[0]) totalWeight = (int)lst[0]
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
        ListPmSprintsActionServiceModel model = ListPmSprintsActionServiceModel.read(sprints.id)
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
        PmActions pmActions = PmActions.read(actionsId)
        PmSprints sprints = new PmSprints(parameterMap)
        sprints.serviceId = serviceId
        sprints.goalId = goalId
        sprints.objectiveId = objectiveId
        sprints.actionsId=actionsId
        sprints.sequence = pmActions.sequence+"."+con
        sprints.tmpSeq = con
        sprints.startDate=DateUtility.getSqlDate(parameterMap.start)
        sprints.endDate = DateUtility.getSqlDate(parameterMap.end)
        sprints.createDate = DateUtility.getSqlDate(new Date())
        sprints.createBy = 1

        return sprints
    }
}
