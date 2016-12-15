package actions.pmProjects

import com.model.ListPmProjectsActionServiceModel
import com.pms.PmProjects
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

@Transactional
class CreatePmProjectsActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Project has been saved successfully"
    private static final String PROJECTS_OBJECT = "pmProjects"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if ((!params.typeId)||(!params.name)|| (!params.shortName)|| (!params.code)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            
            PmProjects projects = buildObject(params)
            params.put(PROJECTS_OBJECT, projects)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmProjects projects = (PmProjects) result.get(PROJECTS_OBJECT)
            projects.save()
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
        PmProjects projects = (PmProjects) result.get(PROJECTS_OBJECT)
        ListPmProjectsActionServiceModel model = ListPmProjectsActionServiceModel.read(projects.id)
        result.put(PROJECTS_OBJECT, model)
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

    private PmProjects buildObject(Map parameterMap) {
        parameterMap.startDate=DateUtility.getSqlDate(DateUtility.parseMaskedDate(parameterMap.startDate.toString()))
        parameterMap.endDate=DateUtility.getSqlDate(DateUtility.parseMaskedDate(parameterMap.endDate.toString()))
        PmProjects projects = new PmProjects(parameterMap)
        projects.createDate=DateUtility.getSqlDate(new Date())
        projects.createBy=springSecurityService.principal.id
        projects.isActive=true
        return projects
    }
}
