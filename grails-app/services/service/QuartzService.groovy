package service

import com.pms.PropertiesReader
import com.pms.Quartz
import grails.transaction.Transactional
import org.quartz.CronScheduleBuilder
import org.quartz.CronTrigger
import org.quartz.TriggerBuilder
import pms.DynamicSpMailSendJob

@Transactional
class QuartzService {

    public void startScheduler() {
        String jobName = PropertiesReader.getProperty("scheduler.default.job.name", PropertiesReader.CONFIG_FILE_DB)
        Quartz quartz =  Quartz.findByJobName(jobName)
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
        }
    }
}
