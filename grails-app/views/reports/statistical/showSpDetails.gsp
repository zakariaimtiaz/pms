<style>
.pdf-page {
    margin: 0 auto;
    box-sizing: border-box;
    box-shadow: 0 5px 10px 0 rgba(0, 0, 0, .3);
    background-color: #fff;
    color: #333;
    position: relative;
}

.pdf-header {
    position: absolute;
    top: .2in;
    left: .5in;
    right: .5in;
    border-bottom: 1px solid #e5e5e5;
}

.pdf-body {
    position: absolute;
    top: 1.2in;
    bottom: 1.2in;
    left: .5in;
    right: .5in;
}

.page-size {
    width: 7in;
    height: 6in;
}

.pdf-page {
    font-family: "DejaVu Sans", "Arial", sans-serif;
}

.table tr td {
    text-align: center;
}
</style>
<script language="javascript">
    $(document).ready(function () {
        defaultPageTile("SP Log Details", "reports/showSpStatus");
    });

    function getPDF(selector) {
        kendo.drawing.drawDOM($(selector)).then(function (group) {
            kendo.drawing.pdf.saveAs(group, "SAP LOG.pdf");
        });
    }

</script>

<div class="col-lg-6">
    <div class="page-container hidden-on-narrow">
        <div class="pdf-page page-size">
            <div class="pdf-header">
                <span class="company-logo">
                    <img src="images/logo.png"/>
                </span>
                <button class="export-pdf k-button pull-right" onclick="getPDF('.pdf-page')">
                    <span class="k-icon k-i-pdf"></span>Download Result
                </button>
            </div>

            <div class="pdf-body">
                <table class="table table-bordered">
                    <center>SAP log summary for ${year}</center><br/>
                    <center><b>${service}</b></center><br/>

                </thead>
                    <tbody>
                    <th width="5%" class="active" style="text-align: left">SL#</th>
                    <th class="active" style="text-align: center">Editable On</th>
                    <th class="active" style="text-align: center">Submitted On</th>
                    <th class="active" style="text-align: center">Current</th>
                    <g:each var="log" in="${result}">
                        <tr>
                            <td>${log?.sl}</td>
                            <td>${log?.editable_on?log.editable_on:logStart}</td>
                            <td>${log?.submitted_on}</td>
                            <td>${log?.is_current?'YES':'NO'}</td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</div>