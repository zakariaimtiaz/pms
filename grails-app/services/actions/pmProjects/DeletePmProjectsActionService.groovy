package actions.pmProjects

import com.model.ListPmProjectsActionServiceModel
import com.pms.PmActions
import com.pms.PmProjects
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class DeletePmProjectsActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Project has been inactive successfully"
    private static final String PROJECTS_OBJ = "pmProjects"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id.toString())
        PmProjects projects = PmProjects.findById(id)
        if (!projects) {
            return super.setError(params, ENTITY_NOT_FOUND_ERROR_MESSAGE)
        }

        params.put(PROJECTS_OBJ, projects)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmProjects projects = (PmProjects) result.get(PROJECTS_OBJ)
            projects.inActive = true
            projects.save()
            return result
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    /**
     * There is no postCondition, so return the same map as received
     *
     * @param result - resulting map from execute
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map executePostCondition(Map result) {
        return result
    }

    /**
     * 1. put success message
     *
     * @param result - map from execute/executePost method
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildSuccessResultForUI(Map result) {
        PmProjects projects = (PmProjects) result.get(PROJECTS_OBJ)
        ListPmProjectsActionServiceModel model = ListPmProjectsActionServiceModel.read(projects.id)
        result.put(PROJECTS_OBJ, model)
        return super.setSuccess(result, DELETE_SUCCESS_MESSAGE)
    }

    /**
     * The input-parameter Map must have "isError:true" with corresponding message
     *
     * @param result - map returned from previous methods
     * @return - same map of input-parameter containing isError(true/false)
     */
    public Map buildFailureResultForUI(Map result) {
        return result
    }
}
