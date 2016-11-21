package actions.pmObjectives

import com.model.ListPmObjectivesActionServiceModel
import com.pms.PmObjectives
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class UpdatePmObjectivesActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Objective has been updated successfully"
    private static final String OBJECTIVE_OBJ = "pmObjective"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId && !params.goalId && !params.objective) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            PmObjectives oldDepartment = (PmObjectives) PmObjectives.read(id)
            PmObjectives objectives = buildObject(params, oldDepartment)
            params.put(OBJECTIVE_OBJ, objectives)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmObjectives objectives = (PmObjectives) result.get(OBJECTIVE_OBJ)
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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        PmObjectives objectives = (PmObjectives) result.get(OBJECTIVE_OBJ)
        ListPmObjectivesActionServiceModel model = ListPmObjectivesActionServiceModel.read(objectives.id)
        result.put(OBJECTIVE_OBJ, model)
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

    private static PmObjectives buildObject(Map parameterMap, PmObjectives oldDepartment) {
        PmObjectives objectives = new PmObjectives(parameterMap)
        oldDepartment.objective = objectives.objective
        return oldDepartment
    }
}
