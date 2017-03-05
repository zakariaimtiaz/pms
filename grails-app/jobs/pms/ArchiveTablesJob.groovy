package pms

import com.pms.PmMcrsLog
import com.pms.PmServiceSector
import pms.utility.DateUtility


class ArchiveTablesJob {
    def mailService

    static triggers = {
        cron name: 'cronTrigger', cronExpression: "0 0 9 * * ?"

    }

    def execute() {
        Calendar now = Calendar.getInstance();
        int year = now.get(Calendar.YEAR);
        int month = now.get(Calendar.MONTH);
        int currentDay = now.get(Calendar.DAY_OF_MONTH);

        List<PmMcrsLog> lstLog = PmMcrsLog.findAllByMonthAndYearAndDeadLineIsNotNull(month, year)
        Calendar c = Calendar.getInstance();

        for (int i = 0; i < lstLog.size(); i++) {
            c.setTime(lstLog[i].deadLine);
            int deadlineDay = c.get(Calendar.DAY_OF_MONTH);
            PmServiceSector sc = PmServiceSector.findByIdAndIsInSp(lstLog[i].serviceId, true)
            if (currentDay + 3 == deadlineDay && sc && !lstLog[i].isSubmitted) {
                //send mail 3 days before deadline
                //sendMail(DateUtility.getDateForUI(lstLog[i].deadLine), sc.departmentHead, sc.contactDesignation, sc.name, sc.contactEmail)
            }
            if (deadlineDay == currentDay + 1 && sc && !lstLog[i].isSubmitted) {
                //send mail 1 day after deadline
                //sendMail2(DateUtility.getDateForUI(lstLog[i].deadLine), sc.departmentHead, sc.contactDesignation, sc.name, sc.contactEmail)
            }
        }
    }

    private void sendMail(String deadline, String name, String designation, String department, String email) {
        String beforeDeadLine = """
            <div>
                <p>
                    Dear Mr/Mrs ${name},
                    ${designation},
                    ${department}
                </p>
                <p>
                    This is here-by notify that MCRS submission deadline is <b>${deadline}</b>.
                    As only 3 days remaining for submission, this is a general reminder for MCRS submission.
                </p>
                <p>
                    Thanks in advance.
                </p>
                <p>
                    Regards,
                    Friendship SP Team
                </p>
                <i>This is an auto-generated email, which does not need reply.</i>
            </div>
        """

        Thread trd = new Thread() {
            public void run() {
                mailService.sendMail {
                    to "imtiaz@friendship-bd.org"
                    from "info.friendship.bd@gmail.com"
                    subject "MCRS deadline is knocking at the door"
                    html(beforeDeadLine)
                }
            }
        }.start();
    }

    private void sendMail2(String deadline, String name, String designation, String department, String email) {
        String afterDeadLine = """
            <div>
                <p>
                    Dear Mr/Mrs ${name},<br/>
                    ${designation} ,<br/>
                    ${department}
                </p>
                <p>
                    This is here-by notify that MCRS submission deadline is <b>${deadline}</b>.<br/>
                    We are very sorry to infor you that you did not submitted your MCRS yet.
                </p>
                <p>
                    Please submit your MCRS as soon as possible.<br/>
                    Thanks in advance.
                </p>
                <p>
                    Regards,<br/>
                      Friendship SP Team
                </p>
                <i>This is an auto-generated email, which does not need reply.</i>
            </div>
        """

        Thread trd = new Thread() {
            public void run() {
                mailService.sendMail {
                    to "imtiaz@friendship-bd.org"
                    from "info.friendship.bd@gmail.com"
                    subject "MCRS deadline exceeds"
                    html(afterDeadLine)
                }
            }
        }.start();
    }
}
