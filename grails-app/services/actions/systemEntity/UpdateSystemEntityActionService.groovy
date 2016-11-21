package actions.systemEntity

import com.model.ListSystemEntityActionServiceModel
import com.pms.SystemEntity
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class UpdateSystemEntityActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Data has been updated successfully"
    private static final String NAME_ALREADY_EXIST = "Data entity already exist"
    private static final String SYSTEM_ENTITY_OBJ = "systemEntity"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            //Check parameters
            if ((!params.name) || (!params.typeId)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            long typeId = Long.parseLong(params.typeId.toString())

            //Check existing of Obj and version matching
            SystemEntity oldSystemEntity = (SystemEntity) SystemEntity.read(id)

            String name = params.name.toString()
            int count = SystemEntity.countByNameIlikeAndTypeIdAndIdNotEqual(name,typeId, id)
            if (count > 0) {
                return super.setError(params, NAME_ALREADY_EXIST)
            }
            SystemEntity service = buildObject(params, oldSystemEntity)
            params.put(SYSTEM_ENTITY_OBJ, service)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            SystemEntity systemEntity = (SystemEntity) result.get(SYSTEM_ENTITY_OBJ)
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
     * @param result - map received from execute method
     * @return - map with success message
     */
    public Map buildSuccessResultForUI(Map result) {
        SystemEntity systemEntity = (SystemEntity) result.get(SYSTEM_ENTITY_OBJ)
        ListSystemEntityActionServiceModel model = ListSystemEntityActionServiceModel.read(systemEntity.id)
        result.put(SYSTEM_ENTITY_OBJ, model)
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

    private static SystemEntity buildObject(Map parameterMap, SystemEntity oldSystemEntity) {
        SystemEntity se = new SystemEntity(parameterMap)
        oldSystemEntity.name = se.name
        oldSystemEntity.typeId = Long.parseLong(parameterMap.typeId.toString())
        return oldSystemEntity
    }
}
