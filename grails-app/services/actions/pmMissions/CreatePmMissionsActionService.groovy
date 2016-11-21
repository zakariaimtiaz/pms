package actions.pmMissions

import com.model.ListPmMissionsActionServiceModel
import com.pms.PmMissions
import grails.transaction.Transactional
import org.apache.log4j.Logger
import pms.ActionServiceIntf
import pms.BaseService

@Transactional
class CreatePmMissionsActionService extends BaseService implements ActionServiceIntf {

    private static final String SAVE_SUCCESS_MESSAGE = "Mission has been saved successfully"
    private static final String ALREADY_EXIST = "Mission already exist"
    private static final String MISSION_OBJECT = "pmMission"

    private Logger log = Logger.getLogger(getClass())



    @Transactional(readOnly = true)
    public Map executePreCondition(Map params) {
        try {
            if (!params.serviceId&&!params.mission) {
                return super.setError(params, INVALID_INPUT_MSG)
            }
            long serviceId = Long.parseLong(params.serviceId.toString())
            int count = PmMissions.countByServiceId(serviceId)
            if (count > 0) {
                return super.setError(params, ALREADY_EXIST)
            }
            PmMissions missions = buildObject(params)
            params.put(MISSION_OBJECT, missions)
            return params
        } catch (Exception ex) {
            log.error(ex.getMessage())
            throw new RuntimeException(ex)
        }
    }

    @Transactional
    public Map execute(Map result) {
        try {
            PmMissions missions = (PmMissions) result.get(MISSION_OBJECT)
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
     * @param result - map received from executePost method
     * @return - map containing success message
     */
    public Map buildSuccessResultForUI(Map result) {
        PmMissions missions = (PmMissions) result.get(MISSION_OBJECT)
        ListPmMissionsActionServiceModel model = ListPmMissionsActionServiceModel.read(missions.id)
        result.put(MISSION_OBJECT, model)
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

    private static PmMissions buildObject(Map parameterMap) {
        PmMissions service = new PmMissions(parameterMap)
        service.serviceId = Long.parseLong(parameterMap.serviceId.toString())
        return service
    }
}
