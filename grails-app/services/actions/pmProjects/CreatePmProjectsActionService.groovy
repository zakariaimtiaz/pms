package actions.pmProjects

import com.model.ListPmGoalsActionServiceModel
import com.model.ListPmProjectsActionServiceModel
import com.pms.PmProjects
import grails.plugin.springsecurity.SpringSecurityService
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService
import pms.utility.DateUtility

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class CreatePmProjectsActionService extends BaseService implements ActionServiceIntf {

    SpringSecurityService springSecurityService
    private static final String SAVE_SUCCESS_MESSAGE = "Project has been saved successfully"
    private static final String ALREADY_EXIST = "Sequence already exist"
    private static final String WEIGHT_EXCEED = "Exceed weight measurement"
    private static final String PROJECTS_OBJECT = "pmProjects"

    private Logger log = Logger.getLogger(getClass())

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if ((!params.serviceId) || (!params.typeId)||(!params.name)|| (!params.shortName)|| (!params.code)) {
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

        String startDateStr = parameterMap.startDate.toString()
        String endDateStr = parameterMap.endDate.toString()
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);

        Date start = originalFormat.parse(startDateStr);
        Calendar c = Calendar.getInstance();
        c.setTime(start);
        c.set(Calendar.DAY_OF_MONTH, c.getActualMinimum(Calendar.DAY_OF_MONTH));

        Date end = originalFormat.parse(endDateStr);
        Calendar ce = Calendar.getInstance();
        ce.setTime(end);
        ce.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));

        parameterMap.startDate=DateUtility.getSqlDate(c.getTime())
        parameterMap.endDate=DateUtility.getSqlDate(ce.getTime())

        PmProjects projects = new PmProjects(parameterMap)
        projects.createDate=DateUtility.getSqlDate(new Date())
        projects.createBy=springSecurityService.principal.id
        projects.inActive=false

        return projects
    }
}
