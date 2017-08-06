package pms

import com.pms.*
import pms.utility.DateUtility
import pms.utility.Tools

class DynamicSpMailSendJob {

    private static final String REMINDER = "SAP reminder mail"
    private static final String WARNING = "SAP warning mail"
    private static final String BOTH_STR = "Both MRP & ED's Dashboard"
    private static final String MRP_STR = "MRP"
    private static final String DASHBOARD_STR = "ED's Dashboard"
    private static final String REMINDER_MAIL_BEFORE_DEADLINE = "REMINDER_MAIL_BEFORE_DEADLINE"
    private static final String REMINDER_MAIL_ON_DEADLINE = "REMINDER_MAIL_ON_DEADLINE"
    private static final String WARNING_MAIL_AFTER_DEADLINE = "WARNING_MAIL_AFTER_DEADLINE"

    def mailService

    static triggers = {
        // cron name: 'cronTrigger', cronExpression: "0 0 9 * * ?"
    }

    def execute() {
        Calendar now = Calendar.getInstance();
        int year = now.get(Calendar.YEAR);
        int month = now.get(Calendar.MONTH);
        int currentDay = now.get(Calendar.DAY_OF_MONTH);
        int reminder = 3
        int warning = 1
        try {
            SystemEntityType st1 = SystemEntityType.findByNameLike(REMINDER)
            SystemEntityType st2 = SystemEntityType.findByNameLike(WARNING)
            SystemEntity reminderDay = SystemEntity.findByTypeId(st1.id)
            SystemEntity warningDay = SystemEntity.findByTypeId(st2.id)
            reminder = Integer.parseInt(reminderDay.name)
            warning = Integer.parseInt(warningDay.name)
        } catch (Exception ex) {
        }


        List<PmMcrsLog> lstLog = PmMcrsLog.findAllByMonthAndYearAndDeadLineIsNotNull(month, year)
        Calendar c = Calendar.getInstance();

        for (int i = 0; i < lstLog.size(); i++) {
            c.setTime(lstLog[i].deadLine);
            int deadlineDay = c.get(Calendar.DAY_OF_MONTH);
            String deadline = DateUtility.getDateForUI(lstLog[i].deadLine)
            PmServiceSector sc = PmServiceSector.findByIdAndIsInSp(lstLog[i].serviceId, true)
            //REMINDER_MAIL_BEFORE_DEADLINE
            if (currentDay + reminder == deadlineDay && sc && !lstLog[i].isSubmitted && !lstLog[i].isSubmittedDb) {
                AppMail appMail = AppMail.findByTransactionCodeAndIsActive(REMINDER_MAIL_BEFORE_DEADLINE, true)
                if (appMail) {
                    sendMail(appMail, sc.departmentHead, sc.contactEmail, deadline, sc.departmentHeadGender, lstLog[i].monthStr, lstLog[i].year,BOTH_STR)
                }
            }else if (currentDay + reminder == deadlineDay && sc && !lstLog[i].isSubmitted && lstLog[i].isSubmittedDb) {
                AppMail appMail = AppMail.findByTransactionCodeAndIsActive(REMINDER_MAIL_BEFORE_DEADLINE, true)
                if (appMail) {
                    sendMail(appMail, sc.departmentHead, sc.contactEmail, deadline, sc.departmentHeadGender, lstLog[i].monthStr, lstLog[i].year,MRP_STR)
                }
            }else if (currentDay + reminder == deadlineDay && sc && lstLog[i].isSubmitted && !lstLog[i].isSubmittedDb) {
                AppMail appMail = AppMail.findByTransactionCodeAndIsActive(REMINDER_MAIL_BEFORE_DEADLINE, true)
                if (appMail) {
                    sendMail(appMail, sc.departmentHead, sc.contactEmail, deadline, sc.departmentHeadGender, lstLog[i].monthStr, lstLog[i].year,DASHBOARD_STR)
                }
            }
            //WARNING_MAIL_AFTER_DEADLINE
            if (deadlineDay + warning == currentDay && sc && !lstLog[i].isSubmitted && !lstLog[i].isSubmittedDb) {
                AppMail appMail = AppMail.findByTransactionCodeAndIsActive(WARNING_MAIL_AFTER_DEADLINE, true)
                if (appMail) {
                    sendMail(appMail, sc.departmentHead, sc.contactEmail, deadline, sc.departmentHeadGender, lstLog[i].monthStr, lstLog[i].year,BOTH_STR)
                }
            }else if (deadlineDay + warning == currentDay && sc && !lstLog[i].isSubmitted && lstLog[i].isSubmittedDb) {
                AppMail appMail = AppMail.findByTransactionCodeAndIsActive(WARNING_MAIL_AFTER_DEADLINE, true)
                if (appMail) {
                    sendMail(appMail, sc.departmentHead, sc.contactEmail, deadline, sc.departmentHeadGender, lstLog[i].monthStr, lstLog[i].year,MRP_STR)
                }
            }else if (deadlineDay + warning == currentDay && sc && lstLog[i].isSubmitted && !lstLog[i].isSubmittedDb) {
                AppMail appMail = AppMail.findByTransactionCodeAndIsActive(WARNING_MAIL_AFTER_DEADLINE, true)
                if (appMail) {
                    sendMail(appMail, sc.departmentHead, sc.contactEmail, deadline, sc.departmentHeadGender, lstLog[i].monthStr, lstLog[i].year,DASHBOARD_STR)
                }
            }

            //REMINDER_MAIL_ON_DEADLINE
            if (currentDay == deadlineDay && sc && !lstLog[i].isSubmitted && !lstLog[i].isSubmittedDb) {
                AppMail appMail = AppMail.findByTransactionCodeAndIsActive(REMINDER_MAIL_ON_DEADLINE, true)
                if (appMail) {
                    sendMail(appMail, sc.departmentHead, sc.contactEmail, deadline, sc.departmentHeadGender, lstLog[i].monthStr, lstLog[i].year,BOTH_STR)
                }
            }else if (currentDay == deadlineDay && sc && !lstLog[i].isSubmitted && lstLog[i].isSubmittedDb) {
                AppMail appMail = AppMail.findByTransactionCodeAndIsActive(REMINDER_MAIL_ON_DEADLINE, true)
                if (appMail) {
                    sendMail(appMail, sc.departmentHead, sc.contactEmail, deadline, sc.departmentHeadGender, lstLog[i].monthStr, lstLog[i].year,MRP_STR)
                }
            }else if (currentDay == deadlineDay && sc && lstLog[i].isSubmitted && !lstLog[i].isSubmittedDb) {
                AppMail appMail = AppMail.findByTransactionCodeAndIsActive(REMINDER_MAIL_ON_DEADLINE, true)
                if (appMail) {
                    sendMail(appMail, sc.departmentHead, sc.contactEmail, deadline, sc.departmentHeadGender, lstLog[i].monthStr, lstLog[i].year,DASHBOARD_STR)
                }
            }
        }
    }

    public String sendMail(AppMail appMail, String user, String email, String deadline, String genderStr, String monthStr, int year,String mrpType) {
        String subjectStr = """${appMail.subject}"""
        String mailBody = """${appMail.body}"""
        subjectStr = subjectStr?.replaceAll("__MCRS_TYPE__",mrpType)
        mailBody = mailBody?.replaceAll("__APP_USER__", user + Tools.SINGLE_SPACE + genderStr)
                .replaceAll("__DEADLINE__", deadline)
                .replaceAll("_MONTH_NAME_", monthStr + Tools.SINGLE_SPACE + year)
                .replaceAll("__MCRS_TYPE__", mrpType)

        Thread trd = new Thread() {
            public void run() {
                mailService.sendMail {
                    to "${email}"
                    from "sp.notification@friendship-bd.org"
                    subject "${subjectStr}"
                    html(mailBody)
                }
            }
        }.start();
        return null
    }
}
