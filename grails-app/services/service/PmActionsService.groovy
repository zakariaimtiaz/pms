package service

import com.pms.SecUser
import grails.transaction.Transactional
import groovy.sql.GroovyRowResult
import pms.BaseService

import java.text.DateFormat
import java.text.SimpleDateFormat

@Transactional
class PmActionsService extends BaseService {

    public List<GroovyRowResult> lstActionsByServiceIdAndYear(long serviceId, String year) {
        String queryForList = """
            SELECT o.id,o.sequence AS name FROM pm_actions o
                WHERE o.service_id = ${serviceId}
                AND YEAR(start)<='${year}' AND YEAR(end) >='${year}'
                ORDER BY o.goal_id,o.tmp_seq
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        return lst
    }
    public List<GroovyRowResult> lstActionsForDropDown(long goalId) {
        String queryForList = """
            SELECT o.id AS id, CONCAT(o.sequence,'. ',o.actions) AS name
                FROM pm_actions o
                WHERE o.goal_id = ${goalId}
                ORDER BY o.tmp_seq
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        return lst
    }
    public boolean taskDateWithinActionsDate(Date start,Date end,long actionsId) {
        String queryForList = """
            SELECT COUNT(id) as c FROM pm_actions
            WHERE START<='${start}' AND END >='${end}' AND id=${actionsId}
        """
        List<GroovyRowResult> lst = executeSelectSql(queryForList)
        int count =(int) lst[0].c
        boolean isWithin=false
        if(count>0){
            isWithin=true
        }
        return isWithin
    }
    public List<GroovyRowResult> lstDepartmentSpStatus(String dateStr) {
        int year = Integer.parseInt(dateStr)

        String query = """
            SELECT ss.short_name service,
                CASE WHEN l.year=2017 THEN l.submission_date ELSE NULL END 'YEAR_2017',
                CASE WHEN l.year=2017 THEN l.dead_line ELSE NULL END 'YEAR_2017D',
                CASE WHEN l.year=2018 THEN l.submission_date ELSE NULL END 'YEAR_2018',
                CASE WHEN l.year=2018 THEN l.dead_line ELSE NULL END 'YEAR_2018D',
                CASE WHEN l.year=2019 THEN l.submission_date ELSE NULL END 'YEAR_2019',
                CASE WHEN l.year=2019 THEN l.dead_line ELSE NULL END 'YEAR_2019D',
                CASE WHEN l.year=2020 THEN l.submission_date ELSE NULL END 'YEAR_2020',
                CASE WHEN l.year=2020 THEN l.dead_line ELSE NULL END 'YEAR_2020D',
                CASE WHEN l.year=2021 THEN l.submission_date ELSE NULL END 'YEAR_2021',
                CASE WHEN l.year=2021 THEN l.dead_line ELSE NULL END 'YEAR_2021D',
                CASE WHEN l.year=2022 THEN l.submission_date ELSE NULL END 'YEAR_2022',
                CASE WHEN l.year=2022 THEN l.dead_line ELSE NULL END 'YEAR_2022D',
                CASE WHEN l.year=2023 THEN l.submission_date ELSE NULL END 'YEAR_2023',
                CASE WHEN l.year=2023 THEN l.dead_line ELSE NULL END 'YEAR_2023D',
                CASE WHEN l.year=2024 THEN l.submission_date ELSE NULL END 'YEAR_2024',
                CASE WHEN l.year=2024 THEN l.dead_line ELSE NULL END 'YEAR_2024D',
                CASE WHEN l.year=2025 THEN l.submission_date ELSE NULL END 'YEAR_2025',
                CASE WHEN l.year=2025 THEN l.dead_line ELSE NULL END 'YEAR_2025D',
                CASE WHEN l.year=2026 THEN l.submission_date ELSE NULL END 'YEAR_2026',
                CASE WHEN l.year=2026 THEN l.dead_line ELSE NULL END 'YEAR_2026D',
                CASE WHEN l.year=2027 THEN l.submission_date ELSE NULL END 'YEAR_2027',
                CASE WHEN l.year=2027 THEN l.dead_line ELSE NULL END 'YEAR_2027D'
                FROM pm_service_sector ss
                LEFT JOIN pm_sp_log l ON l.service_id = ss.id AND l.year = ${year}
                WHERE ss.is_in_sp = TRUE
                ORDER BY ss.name,l.year;
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    public List<GroovyRowResult> lstDepartmentMcrsStatus(String yearStr) {
        int year = Integer.parseInt(yearStr)
        String query = """
                SELECT tmp.short_name service,
                MAX(tmp.JanuaryID) JanuaryID     ,MAX(tmp.January) January     ,MAX(tmp.JanuaryDsb) JanuaryDsb     ,MAX(tmp.JanuaryD) JanuaryD ,
                MAX(tmp.FebruaryID) FebruaryID   ,MAX(tmp.February) February   ,MAX(tmp.FebruaryDsb) FebruaryDsb   ,MAX(tmp.FebruaryD) FebruaryD ,
                MAX(tmp.MarchID) MarchID         ,MAX(tmp.March) March         ,MAX(tmp.MarchDsb) MarchDsb         ,MAX(tmp.MarchD) MarchD ,
                MAX(tmp.AprilID) AprilID         ,MAX(tmp.April) April         ,MAX(tmp.AprilDsb) AprilDsb         ,MAX(tmp.AprilD) AprilD ,
                MAX(tmp.MayID) MayID             ,MAX(tmp.May) May             ,MAX(tmp.MayDsb) MayDsb             ,MAX(tmp.MayD) MayD ,
                MAX(tmp.JuneID) JuneID           ,MAX(tmp.June) June           ,MAX(tmp.JuneDsb) JuneDsb           ,MAX(tmp.JuneD) JuneD ,
                MAX(tmp.JulyID) JulyID           ,MAX(tmp.July) July           ,MAX(tmp.JulyDsb) JulyDsb           ,MAX(tmp.JulyD) JulyD ,
                MAX(tmp.AugustID) AugustID       ,MAX(tmp.August) August       ,MAX(tmp.AugustDsb) AugustDsb       ,MAX(tmp.AugustD) AugustD ,
                MAX(tmp.SeptemberID) SeptemberID ,MAX(tmp.September) September ,MAX(tmp.SeptemberDsb) SeptemberDsb ,MAX(tmp.SeptemberD) SeptemberD ,
                MAX(tmp.OctoberID) OctoberID     ,MAX(tmp.October) October     ,MAX(tmp.OctoberDsb) OctoberDsb     ,MAX(tmp.OctoberD) OctoberD,
                MAX(tmp.NovemberID) NovemberID   ,MAX(tmp.November) November   ,MAX(tmp.NovemberDsb) NovemberDsb   ,MAX(tmp.NovemberD) NovemberD  ,
                MAX(tmp.DecemberID) DecemberID   ,MAX(tmp.December) December   ,MAX(tmp.DecemberDsb) DecemberDsb   ,MAX(tmp.DecemberD) DecemberD
                FROM (SELECT ss.short_name,
                CASE WHEN l.month_str='January' THEN l.id ELSE NULL END JanuaryID,
                CASE WHEN l.month_str='January' THEN l.submission_date ELSE NULL END January,
                CASE WHEN l.month_str='January' THEN l.submission_date_db ELSE NULL END JanuaryDsb,
                CASE WHEN l.month_str='January' THEN l.dead_line ELSE NULL END JanuaryD,

                CASE WHEN l.month_str='February' THEN l.id ELSE NULL END FebruaryID,
                CASE WHEN l.month_str='February' THEN l.submission_date ELSE NULL END February,
                CASE WHEN l.month_str='February' THEN l.submission_date_db ELSE NULL END FebruaryDsb,
                CASE WHEN l.month_str='February' THEN l.dead_line ELSE NULL END FebruaryD,

                CASE WHEN l.month_str='March' THEN l.id ELSE NULL END MarchID,
                CASE WHEN l.month_str='March' THEN l.submission_date ELSE NULL END March,
                CASE WHEN l.month_str='March' THEN l.submission_date_db ELSE NULL END MarchDsb,
                CASE WHEN l.month_str='March' THEN l.dead_line ELSE NULL END MarchD,

                CASE WHEN l.month_str='April' THEN l.id ELSE NULL END AprilID,
                CASE WHEN l.month_str='April' THEN l.submission_date ELSE NULL END April,
                CASE WHEN l.month_str='April' THEN l.submission_date_db ELSE NULL END AprilDsb,
                CASE WHEN l.month_str='April' THEN l.dead_line ELSE NULL END AprilD,

                CASE WHEN l.month_str='May' THEN l.id ELSE NULL END MayID,
                CASE WHEN l.month_str='May' THEN l.submission_date ELSE NULL END May,
                CASE WHEN l.month_str='May' THEN l.submission_date_db ELSE NULL END MayDsb,
                CASE WHEN l.month_str='May' THEN l.dead_line ELSE NULL END MayD,

                CASE WHEN l.month_str='June' THEN l.id ELSE NULL END JuneID,
                CASE WHEN l.month_str='June' THEN l.submission_date ELSE NULL END June,
                CASE WHEN l.month_str='June' THEN l.submission_date_db ELSE NULL END JuneDsb,
                CASE WHEN l.month_str='June' THEN l.dead_line ELSE NULL END JuneD,

                CASE WHEN l.month_str='July' THEN l.id ELSE NULL END JulyID,
                CASE WHEN l.month_str='July' THEN l.submission_date ELSE NULL END July,
                CASE WHEN l.month_str='July' THEN l.submission_date_db ELSE NULL END JulyDsb,
                CASE WHEN l.month_str='July' THEN l.dead_line ELSE NULL END JulyD,

                CASE WHEN l.month_str='August' THEN l.id ELSE NULL END AugustID,
                CASE WHEN l.month_str='August' THEN l.submission_date ELSE NULL END August,
                CASE WHEN l.month_str='August' THEN l.submission_date_db ELSE NULL END AugustDsb,
                CASE WHEN l.month_str='August' THEN l.dead_line ELSE NULL END AugustD,

                CASE WHEN l.month_str='September' THEN l.id ELSE NULL END SeptemberID,
                CASE WHEN l.month_str='September' THEN l.submission_date ELSE NULL END September,
                CASE WHEN l.month_str='September' THEN l.submission_date_db ELSE NULL END SeptemberDsb,
                CASE WHEN l.month_str='September' THEN l.dead_line ELSE NULL END SeptemberD,

                CASE WHEN l.month_str='October' THEN l.id ELSE NULL END OctoberID,
                CASE WHEN l.month_str='October' THEN l.submission_date ELSE NULL END October,
                CASE WHEN l.month_str='October' THEN l.submission_date_db ELSE NULL END OctoberDsb,
                CASE WHEN l.month_str='October' THEN l.dead_line ELSE NULL END OctoberD,

                CASE WHEN l.month_str='November' THEN l.id ELSE NULL END NovemberID,
                CASE WHEN l.month_str='November' THEN l.submission_date ELSE NULL END November,
                CASE WHEN l.month_str='November' THEN l.submission_date_db ELSE NULL END NovemberDsb,
                CASE WHEN l.month_str='November' THEN l.dead_line ELSE NULL END NovemberD,

                CASE WHEN l.month_str='December' THEN l.id ELSE NULL END DecemberID,
                CASE WHEN l.month_str='December' THEN l.submission_date ELSE NULL END December,
                CASE WHEN l.month_str='December' THEN l.submission_date_db ELSE NULL END DecemberDsb,
                CASE WHEN l.month_str='December' THEN l.dead_line ELSE NULL END DecemberD
                FROM pm_service_sector ss
                LEFT JOIN pm_mcrs_log l ON l.service_id = ss.id AND l.year = ${year}
                WHERE ss.is_in_sp = TRUE
                ORDER BY ss.name,l.month) tmp GROUP BY tmp.short_name;
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
    public List<GroovyRowResult> lstServiceWiseAcvStatus(String monthStr) {
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
        Date date = originalFormat.parse(monthStr);
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        int month = c.get(Calendar.MONTH)+1
        int year = c.get(Calendar.YEAR)
        SecUser user = currentUserObject();

        String query = """
        (SELECT ROUND(SUM(a_pert)/COUNT(cat_axe)) act_val, "Achieved" act_name,"#069302" act_color FROM
                (SELECT cat_axe,IF(ROUND(a_col/ac_count*100)>100,100,ROUND(a_col/ac_count*100)) a_pert FROM
                (SELECT CONCAT('Goal ',g.sequence) cat_axe,COUNT(a.id) ac_count,aid.target,aid.achievement,
                ROUND(SUM(FLOOR(((COALESCE(aid.achievement,0)/aid.target)*100)))/COUNT(ai.id)*COUNT(a.id)/100,2) a_col
                                FROM pm_goals g
                LEFT JOIN pm_service_sector sc ON sc.id = g.service_id
                LEFT JOIN pm_actions a ON a.goal_id = g.id
                LEFT JOIN pm_actions_indicator ai ON a.id = ai.actions_id
                LEFT JOIN pm_actions_indicator_details aid ON ai.id=aid.indicator_id
                JOIN custom_month cm ON cm.name=aid.month_name,
                (SELECT @curmon := ${month}) r
                WHERE g.service_id=  ${user.serviceId}  AND  a.year = ${year} AND cm.sl_index=@curmon AND aid.target > 0
                GROUP BY g.id
                ORDER BY sc.sequence,a.id,ai.id,aid.id) tmp ) tmp2)
        UNION ALL
            (SELECT 100-ROUND(SUM(a_pert)/COUNT(cat_axe)) act_val, "Remaining" act_name,"#ff8a00" act_color FROM
                (SELECT cat_axe,IF(ROUND(a_col/ac_count*100)>100,100,ROUND(a_col/ac_count*100)) a_pert FROM
                (SELECT CONCAT('Goal ',g.sequence) cat_axe,COUNT(a.id) ac_count,aid.target,aid.achievement,
                ROUND(SUM(FLOOR(((COALESCE(aid.achievement,0)/aid.target)*100)))/COUNT(ai.id)*COUNT(a.id)/100,2) a_col
                                FROM pm_goals g
                LEFT JOIN pm_service_sector sc ON sc.id = g.service_id
                LEFT JOIN pm_actions a ON a.goal_id = g.id
                LEFT JOIN pm_actions_indicator ai ON a.id = ai.actions_id
                LEFT JOIN pm_actions_indicator_details aid ON ai.id=aid.indicator_id
                JOIN custom_month cm ON cm.name=aid.month_name,
                (SELECT @curmon := ${month}) r
                WHERE g.service_id=  ${user.serviceId}  AND  a.year = ${year} AND cm.sl_index=@curmon AND aid.target > 0
                GROUP BY g.id
                ORDER BY sc.sequence,a.id,ai.id,aid.id) tmp ) tmp2);
        """
        List<GroovyRowResult> lst = groovySql.rows(query)
        return lst
    }
    public List<GroovyRowResult> lstGoalWiseActionStatus(String monthStr) {
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
        Date date = originalFormat.parse(monthStr);
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        int month = c.get(Calendar.MONTH)+1
        int year = c.get(Calendar.YEAR)
        SecUser user = currentUserObject();

        String query = """
            SELECT cat_axe,ac_count,IF((ac_count-a_col)<0,0.00,ac_count-a_col) t_col,a_col,a_color,t_color,goal,ROUND(a_col/ac_count*100) a_pert
            FROM
            (SELECT CONCAT('Goal ',g.sequence) cat_axe,COUNT(a.id) ac_count,
            ROUND(SUM(FLOOR(((COALESCE(aid.achievement,0)/aid.target)*100)))/COUNT(ai.id)*COUNT(a.id)/100,2) a_col,
            '#ff8a00' t_color, '#069302' a_color,g.goal
            FROM pm_goals g
            LEFT JOIN pm_actions a ON a.goal_id = g.id
            LEFT JOIN pm_actions_indicator ai ON a.id = ai.actions_id
            LEFT JOIN pm_actions_indicator_details aid ON ai.id=aid.indicator_id
            JOIN custom_month cm ON cm.name=aid.month_name,
            (SELECT @curmon := ${month}) r
            WHERE g.service_id = ${user.serviceId} AND a.year = ${year} AND cm.sl_index=@curmon AND aid.target > 0
            GROUP BY g.id
            ORDER BY g.sequence,a.id,ai.id,aid.id) tmp;
        """
        List<GroovyRowResult> lst = groovySql.rows(query)
        return lst
    }
    public List<GroovyRowResult> lstServiceWiseActionStatus(String monthStr) {
        DateFormat originalFormat = new SimpleDateFormat("MMMM yyyy", Locale.ENGLISH);
        Date date = originalFormat.parse(monthStr);
        Calendar c = Calendar.getInstance();
        c.setTime(date);
        int month = c.get(Calendar.MONTH)+1
        int year = c.get(Calendar.YEAR)

        String query = """
            SELECT service_id,service,short_name,ROUND(SUM(a_pert)/COUNT(cat_axe)) a_pert,'#069302' a_color,
            100-ROUND(SUM(a_pert)/COUNT(cat_axe)) r_pert,'#ff8a00' r_color
            FROM
            (SELECT service_id,service,short_name,cat_axe,IF(ROUND(a_col/ac_count*100)>100,100,ROUND(a_col/ac_count*100)) a_pert FROM
            (SELECT sc.id service_id,g.id AS goal_id,sc.name service,sc.short_name,
            CONCAT('Goal ',g.sequence) cat_axe,COUNT(a.id) ac_count,
            ROUND(SUM(FLOOR(((COALESCE(aid.achievement,0)/aid.target)*100)))/COUNT(ai.id)*COUNT(a.id)/100,2) a_col
            FROM pm_goals g
            LEFT JOIN pm_service_sector sc ON sc.id = g.service_id
            LEFT JOIN pm_actions a ON a.goal_id = g.id
            LEFT JOIN pm_actions_indicator ai ON a.id = ai.actions_id
            LEFT JOIN pm_actions_indicator_details aid ON ai.id=aid.indicator_id
            JOIN custom_month cm ON cm.name=aid.month_name,
            (SELECT @curmon := ${month}) r
            WHERE a.year = ${year} AND cm.sl_index=@curmon AND aid.target > 0
            GROUP BY g.id
            ORDER BY sc.sequence,a.id,ai.id,aid.id) tmp ) tmp2 GROUP BY service_id;
        """
        List<GroovyRowResult> lst = groovySql.rows(query)
        return lst
    }
    public List<GroovyRowResult> findAllDetailsByActionsIdAndIndicatorId(long actionsId, long indicatorId) {
        String query = """
            SELECT aid.*,ai.indicator_type
                FROM pm_actions_indicator_details aid
                LEFT JOIN pm_actions_indicator ai ON ai.id=aid.indicator_id
                WHERE aid.actions_id = ${actionsId} AND aid.indicator_id = ${indicatorId}
        """
        List<GroovyRowResult> lst = executeSelectSql(query)
        return lst
    }
}
