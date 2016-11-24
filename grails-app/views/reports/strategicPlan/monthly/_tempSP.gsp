<script language="javascript" xmlns="http://www.w3.org/1999/html">
    $(document).ready(function () {
        /*        $('#accordion').on('show.bs.collapse', function () {
         $('#accordion .in').collapse('hide');
         });*/
    });
    function togglePlus(e) {
        $(e.target)
                .prev('.panel-heading')
                .find("i.fa")
                .toggleClass('fa fa-plus-square-o fa fa-minus-square-o');
    }
    function toggleMinus(e) {
        $(e.target)
                .prev('.panel-heading')
                .find("i.fa")
                .toggleClass('fa fa-minus-square-o fa fa-plus-square-o');
    }
    $('#accordion').on('hidden.bs.collapse', togglePlus);
    $('#accordion').on('shown.bs.collapse', toggleMinus);
</script>
<style>
.panel-heading {
    cursor: pointer;
}
</style>

<div class="panel-group" id="accordion">
    <!-- First Panel -->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title"
                data-toggle="collapse"
                data-target="#collapseOne">
                Mission<i class="fa fa-plus-square-o pull-right"></i>
            </h4>
        </div>

        <div id="collapseOne" class="panel-collapse collapse">
            <div class="panel-body">
                <table class="table table-striped">
                    <tbody id="lstMission"></tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- Second Panel -->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title"
                data-toggle="collapse"
                data-target="#collapseTwo">
                Goals<i class="fa fa-plus-square-o pull-right"></i>
            </h4>
        </div>

        <div id="collapseTwo" class="panel-collapse collapse">
            <div class="panel-body">
                <table id="myTbl" class="table table-striped">
                    <tbody id="lstGoal"></tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- Third Panel -->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title"
                data-toggle="collapse"
                data-target="#collapseThree">
                Objectives<i class="fa fa-plus-square-o pull-right"></i>
            </h4>
        </div>

        <div id="collapseThree" class="panel-collapse collapse">
            <div class="panel-body">
                <table class="table table-striped">
                    <tr>
                        <th width='5%'>ID#</th>
                        <th width='90%'>Objectives</th>
                        <th>Weight</th>
                    </tr>
                    <tbody id="lstObjective"></tbody>
                </table>
            </div>
        </div>
    </div>

    <!-- Fourth Panel -->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title"
                data-toggle="collapse"
                data-target="#collapseFour">
                Actions<i class="fa fa-plus-square-o pull-right"></i>
            </h4>
        </div>

        <div id="collapseFour" class="panel-collapse collapse">
            <div class="panel-body">
                <table class="table table-striped">
                    <tr>
                        <th width='3%'>ID#</th>
                        <th width='20%'>Actions</th>
                        <th>Weight</th>
                        <th>Measurement Indicator</th>
                        <th>Target</th>
                        <th>Responsible Person</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Support Department</th>

                    </tr>
                    <tbody id="lstAction">
                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <!-- Fifth Panel -->
    <div class="panel panel-default">
        <div class="panel-heading">
            <h4 class="panel-title"
                data-toggle="collapse"
                data-target="#collapseFive">
                Sprints<i class="fa fa-plus-square-o pull-right"></i>
            </h4>
        </div>

        <div id="collapseFive" class="panel-collapse collapse">
            <div class="panel-body">
                <table class="table table-striped">
                    <tbody id="lstSprint"></tbody>
                </table>
            </div>
        </div>
    </div>

</div>









