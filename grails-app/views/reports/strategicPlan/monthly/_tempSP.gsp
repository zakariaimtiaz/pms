<script language="javascript" xmlns="http://www.w3.org/1999/html">
    $(document).ready(function () {
         $('#accordion').on('show.bs.collapse', function () {
         $('#accordion .in').collapse('hide');
         });
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
                Goals<i class="fa fa-plus-square-o pull-right"></i>
            </h4>
        </div>

        <div id="collapseOne" class="panel-collapse collapse">
            <div class="panel-body">
                <table class="table table-striped">
                    <tr>
                        <th width='5%'>#ID</th>
                        <th width='90%'>Goal</th>
                    </tr>
                    <tbody id="lstGoal"></tbody>
                </table>
            </div>
        </div>
    </div>
</div>









