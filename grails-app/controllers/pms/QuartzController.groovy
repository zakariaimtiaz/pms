package pms

import actions.quartz.CreateQuartzActionService
import actions.quartz.DeleteQuartzActionService
import actions.quartz.ListQuartzActionService
import actions.quartz.UpdateQuartzActionService
import com.pms.Quartz
import grails.converters.JSON
import org.quartz.CronScheduleBuilder
import org.quartz.CronTrigger
import org.quartz.TriggerBuilder

class QuartzController extends BaseController {

    static allowedMethods = [show: "POST",create: "POST",update: "POST",delete: "POST",
                             list: "POST",startScheduler: "POST", stopScheduler: "POST"]

    CreateQuartzActionService createQuartzActionService
    UpdateQuartzActionService updateQuartzActionService
    DeleteQuartzActionService deleteQuartzActionService
    ListQuartzActionService listQuartzActionService


    def show(){
        render(view: "/quartz/show")
    }
    def create() {
        renderOutput(createQuartzActionService, params)

    }
    def update() {
        renderOutput(updateQuartzActionService, params)

    }
    def delete() {
        renderOutput(deleteQuartzActionService, params)

    }
    def list() {
        renderOutput(listQuartzActionService, params)
    }

    def startScheduler(){
        Map result = new LinkedHashMap()
        Quartz quartz =  Quartz.read(Long.parseLong(params.id.toString()))
        if(!quartz?.isActive){
            result.put('message', "Trigger is not active!")
        }
        if(quartz?.isRunning){
            result.put('message', "Trigger is already running!")
        }
        if(quartz?.isActive && !quartz.isRunning){
            CronTrigger trigger = TriggerBuilder.newTrigger()
                    .withIdentity(quartz.triggerName,quartz.triggerName+"GP")
                    .withSchedule(CronScheduleBuilder.cronSchedule(quartz.cronExpression))
                    .build();

            switch (quartz.jobName) {
                case "DynamicSpMailSendJob":
                    DynamicSpMailSendJob.schedule( trigger );
                    break;
                default:
                    throw new IllegalArgumentException("Invalid trigger");
            }

            quartz.isRunning = Boolean.TRUE
            quartz.save()

            result.put('message', "Trigger started!")
        }
        render result as JSON
    }

    def stopScheduler(){
        Map result = new LinkedHashMap()
        Quartz quartz =  Quartz.read(Long.parseLong(params.id.toString()))

        switch (quartz.jobName) {
            case "DynamicSpMailSendJob":
                DynamicSpMailSendJob.unschedule(quartz.triggerName,quartz.triggerName+"GP");
                break;
            default:
                throw new IllegalArgumentException("Invalid trigger");
        }

        quartz.isRunning = Boolean.FALSE
        quartz.save()

        result.put('message', "Trigger stopped!")
        render result as JSON
    }

}
