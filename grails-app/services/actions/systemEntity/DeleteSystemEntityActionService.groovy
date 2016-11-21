package actions.systemEntity

import com.pms.SystemEntity
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class DeleteSystemEntityActionService extends BaseService implements ActionServiceIntf {

    private Logger log = Logger.getLogger(getClass())

    private static final String DELETE_SUCCESS_MESSAGE = "Data has been deleted successfully"
    private static final String NOT_FOUND = "Data does not exits"
    private static final String ASSOCIATION_EXISTS = "Selected entity could not be deleted"
    private static final String SYSTEM_ENTITY_OBJ = "systemEntity"

    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        long id = Long.parseLong(params.id)
        SystemEntity se = SystemEntity.read(id)
        if(!se){
            super.setError(params, NOT_FOUND)
        }
/*        int count = countByEntityType(se.typeId, se.id)
        if(count > 0 ){
            return super.setError(params, ASSOCIATION_EXISTS)
        }*/
        params.put(SYSTEM_ENTITY_OBJ, se)
        return params
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SystemEntity se = (SystemEntity) result.get(SYSTEM_ENTITY_OBJ)
            se.delete()
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

    private countByEntityType(typeId, id){
        int count = 0
/*        switch (typeId){
            case 1:  count = Employee.countByDesignationId(id)
                break;
            case 2:  count = Employee.countByGenderId(id)
                break;
            case 3: count = Employee.countByReligionId(id)
                break;
            case 4:  count = Employee.countByMaritalStatusId(id)
                break;
            case 5:  count = Employee.countByBloodGroupId(id)
                break;
            case 6: count = Employee.countByNationalityId(id)
                break;
            default:
                break;
        }*/
        return count
    }
}
