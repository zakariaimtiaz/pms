package pms

class ReportsController  extends BaseController  {
    static allowedMethods = [
            show: "POST", create: "POST", update: "POST",delete: "POST", list: "POST"
    ]
    def showStrategicPlan() {
        render(view: "/reports/strategicPlan/show")
    }
}
