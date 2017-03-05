package actions.pmServiceSector

import com.model.ListPmServiceSectorActionServiceModel
import com.pms.PmServiceSector
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class CreatePmServiceSectorActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "PmServiceSector has been saved successfully"
    private static final String NAME_ALREADY_EXIST = "Same PmServiceSector already exist"
    private static final String SEQUENCE_ALREADY_EXIST = "Same Sequence already exist"
    private static final String SHORT_NAME_ALREADY_EXIST = "Short name already exist"
    private static final String SERVICE_OBJECT = "pmServiceSector"

    private Logger log = Logger.getLogger(getClass())


    /**
     * 1. input validation check
     * 2. duplicate check for role-name
     * @param params - receive role object from controller
     * @return - map.
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if (!params.name && !params.shortName) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            int count = PmServiceSector.countByNameIlike(params.name)
            if (count > 0) {
                return super.setError(params, NAME_ALREADY_EXIST)
            }
/*            int countSequence = PmServiceSector.countBySequence(Integer.parseInt(params.sequence.toString()))
            if (countSequence > 0) {
                return super.setError(params, SEQUENCE_ALREADY_EXIST)
            }*/
            int duplicateCount = PmServiceSector.countByShortNameIlike(params.shortName)
            if (duplicateCount > 0) {
                return super.setError(params, SHORT_NAME_ALREADY_EXIST)
            }
            PmServiceSector service = buildObject(params)
            params.put(SERVICE_OBJECT, service)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     * 1. receive pmPmServiceSectorSector object from pre execute method
     * 2. create new pmPmServiceSectorSector
     * This method is in transactional block and will roll back in case of any exception
     * @param result - map received from pre execute method
     * @return - map.
     */
    @Transactional
    public Map execute(Map result) {
        try {
            PmServiceSector service = (PmServiceSector) result.get(SERVICE_OBJECT)
            service.save()
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
        PmServiceSector service = (PmServiceSector) result.get(SERVICE_OBJECT)
        ListPmServiceSectorActionServiceModel model = ListPmServiceSectorActionServiceModel.read(service.id)
        result.put(SERVICE_OBJECT, model)
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

    /**
     * Build PmServiceSector object
     * @param parameterMap -serialized parameters from UI
     * @return -new PmServiceSector object
     */
    private PmServiceSector buildObject(Map parameterMap) {
        def user = userAllInformation(parameterMap.departmentHeadId.toString())
        PmServiceSector service = new PmServiceSector(parameterMap)
        service.staticName = service.name.toUpperCase()
        service.categoryId = Long.parseLong(parameterMap.categoryId.toString())
        service.departmentHeadId = user?.login_id
        service.departmentHead = user?.employee_name
        service.contactDesignation = user?.designation
        service.contactEmail = user?.official_email
        return service
    }
    private GroovyRowResult userAllInformation(String employee_id){
        String query= """
            SELECT * FROM list_hr_user_action_service_model WHERE login_id = ${employee_id}
        """
        return executeSelectSql(query)[0]
    }
}
