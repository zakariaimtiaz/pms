package actions.pmObjectives

import com.model.ListPmObjectivesActionServiceModel
import com.pms.PmActions
import com.pms.PmGoals
import com.pms.PmObjectives
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class CreatePmObjectivesActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Objectives has been saved successfully"
    private static final String WEIGHT_EXCEED = "Exceed weight measurement"
    private static final String OBJECTIVES_OBJECT = "pmObjective"

    private Logger log = Logger.getLogger(getClass())


    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId && !params.goalId && !params.objective) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())
            long goalId = Long.parseLong(params.goalId.toString())
            int weight = Long.parseLong(params.weight.toString())
            int totalWeight = 0
            List tmp = PmGoals.executeQuery("select sum(weight) from PmObjectives where goalId=${goalId}")
            if(tmp[0]) totalWeight =(int) tmp[0]
            int available = 100-totalWeight
            if(weight>available){
                return super.setError(params, WEIGHT_EXCEED)
            }
            PmObjectives objectives = buildObject(params, serviceId, goalId)
            params.put(OBJECTIVES_OBJECT, objectives)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmObjectives objectives = (PmObjectives) result.get(OBJECTIVES_OBJECT)
            objectives.save()
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
        PmObjectives objectives = (PmObjectives) result.get(OBJECTIVES_OBJECT)
        ListPmObjectivesActionServiceModel model = ListPmObjectivesActionServiceModel.read(objectives.id)
        result.put(OBJECTIVES_OBJECT, model)
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

    private static PmObjectives buildObject(Map parameterMap, long serviceId, long goalId) {
        List<PmObjectives> max = PmObjectives.executeQuery("SELECT COALESCE(MAX(tmpSeq),0) FROM PmObjectives" +
                " WHERE serviceId=${serviceId} AND goalId=${goalId}")

        int con =(int) max[0]+1
        PmGoals goals = PmGoals.read(goalId)
        float sequence = Float.parseFloat("" +goals.sequence+"."+con)

        PmObjectives objectives = new PmObjectives(parameterMap)
        objectives.serviceId = serviceId
        objectives.goalId = goalId
        objectives.sequence = sequence
        objectives.tmpSeq = con
        return objectives
    }
}
