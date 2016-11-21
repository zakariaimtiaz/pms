package actions.pmMissions

import com.model.ListPmMissionsActionServiceModel
import com.pms.PmMissions
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class UpdatePmMissionsActionService extends BaseService implements ActionServiceIntf {

    private static final String UPDATE_SUCCESS_MESSAGE = "Mission has been updated successfully"
    private static final String MISSION_OBJ = "pmMission"

    private Logger log = Logger.getLogger(getClass())

    public Map executePreCondition(Map params) {
        try {
            if ((!params.serviceId) || (!params.mission)) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long id = Long.parseLong(params.id.toString())
            PmMissions oldObject = PmMissions.read(id)
            PmMissions missions = buildObject(params, oldObject)
            params.put(MISSION_OBJ, missions)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmMissions missions = (PmMissions) result.get(MISSION_OBJ)
            missions.save()
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
        PmMissions missions = (PmMissions) result.get(MISSION_OBJ)
        ListPmMissionsActionServiceModel model = ListPmMissionsActionServiceModel.read(missions.id)
        result.put(MISSION_OBJ, model)
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

    private static PmMissions buildObject(Map parameterMap, PmMissions oldObject) {
        PmMissions missions = new PmMissions(parameterMap)
        oldObject.mission = missions.mission
        return oldObject
    }
}
