package actions.pmServiceSector

import com.model.ListPmServiceSectorActionServiceModel
import com.pms.PmServiceSector
import com.pms.SecUser
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class UpdatePmServiceSectorActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Service has been updated successfully"
    private static final String NAME_ALREADY_EXIST = "Same Service already exist"
    private static final String SEQUENCE_ALREADY_EXIST = "Same Sequence already exist"
    private static final String SHORT_NAME_ALREADY_EXIST = "Same Short Name already exist"
    private static final String SERVICE_OBJ = "pmServiceSector"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if (!params.departmentHeadId) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())

            PmServiceSector oldDepartment = (PmServiceSector) PmServiceSector.read(id)

            String name = params.name.toString()
            int count = PmServiceSector.countByNameIlikeAndIdNotEqual(name, id)
            if (count > 0) {
                return super.setError(params, NAME_ALREADY_EXIST)
            }
            int duplicateCount = PmServiceSector.countByShortNameIlikeAndIdNotEqual(name, id)
            if (duplicateCount > 0) {
                return super.setError(params, SHORT_NAME_ALREADY_EXIST)
            }
            PmServiceSector service = buildObject(params, oldDepartment)
            params.put(SERVICE_OBJ, service)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmServiceSector service = (PmServiceSector) result.get(SERVICE_OBJ)
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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        PmServiceSector service = (PmServiceSector) result.get(SERVICE_OBJ)
        ListPmServiceSectorActionServiceModel model = ListPmServiceSectorActionServiceModel.read(service.id)
        result.put(SERVICE_OBJ, model)
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

    private PmServiceSector buildObject(Map parameterMap, PmServiceSector oldDepartment) {
        GroovyRowResult user = userAllInformation(parameterMap.departmentHeadId.toString())
        PmServiceSector service = new PmServiceSector(parameterMap)
        if(!service.departmentHead.equals(oldDepartment.departmentHead)){
            List<SecUser> lstUser = SecUser.findAllByServiceId(oldDepartment.id)
            for(int i=0; i<lstUser.size();i++){
                lstUser[i].employeeName = service.departmentHead
                lstUser[i].save()
            }
        }
        oldDepartment.departmentHead = service.departmentHead
        oldDepartment.departmentHeadId = user?.login_id
        oldDepartment.departmentHead = user?.employee_name
        oldDepartment.departmentHeadGender = user?.gender_str
        oldDepartment.contactDesignation = user?.designation
        oldDepartment.contactEmail = user?.official_email
        return oldDepartment
    }

    private GroovyRowResult userAllInformation(String employee_id){
        String query= """
            SELECT * FROM list_hr_user_action_service_model WHERE login_id = ${employee_id}
        """
        return executeSelectSql(query)[0]
    }
}
