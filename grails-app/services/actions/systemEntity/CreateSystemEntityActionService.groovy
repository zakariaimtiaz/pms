package actions.systemEntity

import com.model.ListSystemEntityActionServiceModel
import com.pms.SystemEntity
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class CreateSystemEntityActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Data has been saved successfully"
    private static final String NAME_ALREADY_EXIST = "Data already exist"
    private static final String SYSTEM_ENTITY_OBJECT = "systemEntity"
    private static final String NEWLY_CREATED_ID = "newId"

    private Logger log = Logger.getLogger(getClass())


    /**
     * 1. input validation check
     * 2. duplicate check for entity name
     * @param params - receive role object from controller
     * @return - map.
     */
    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if(params.nameEntityModal && params.typeEntityModal){
                params.name = params.nameEntityModal
                params.typeId = params.typeEntityModal
            }
            //Check parameters
            if (!params.name && !params.typeId) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long typeId = Long.parseLong(params.typeId.toString())
            int count = SystemEntity.countByNameIlikeAndTypeId(params.name, typeId)
            if (count > 0) {
                return super.setError(params, NAME_ALREADY_EXIST)
            }
            SystemEntity systemEntity = buildObject(params)
            params.put(SYSTEM_ENTITY_OBJECT, systemEntity)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }
    /**
     * 1. receive systemEntity object from pre execute method
     * 2. create new systemEntity
     * This method is in transactional block and will roll back in case of any exception
     * @param result - map received from pre execute method
     * @return - map.
     */
    @Transactional
    public Map execute(Map result) {
        try {
            SystemEntity systemEntity = (SystemEntity) result.get(SYSTEM_ENTITY_OBJECT)
            systemEntity.save()
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
        SystemEntity systemEntity = (SystemEntity) result.get(SYSTEM_ENTITY_OBJECT)
        ListSystemEntityActionServiceModel model = ListSystemEntityActionServiceModel.read(systemEntity.id)
        result.put(SYSTEM_ENTITY_OBJECT, model)
        result.put(NEWLY_CREATED_ID, systemEntity.id)
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
     * Build SystemEntity object
     * @param parameterMap -serialized parameters from UI
     * @return -new SystemEntity object
     */
    private SystemEntity buildObject(Map parameterMap) {
        SystemEntity systemEntity = new SystemEntity(parameterMap)
        systemEntity.typeId = Long.parseLong(parameterMap.typeId.toString())
        return systemEntity
    }
}
