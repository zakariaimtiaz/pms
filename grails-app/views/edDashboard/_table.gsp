<table class="table table-bordered table-hover">
    <tr style="background-color: #c2c9f6">
        <td colspan="6" style="padding-top: 0px;padding-bottom: 0px;">

            <label class=" control-label" style="font-weight: bold; padding-bottom: 5px;">Unresolve Issues From Previous Months</label>
        </td>
    </tr>
    <tr style="background-color: #c0c0c0">
        <td style="width: 10%;"><label class=" control-label">Issue</label></td>
        <td style="width: 10%;"><label class=" control-label">Issued Month</label></td>
        <td style="width: 30%;"><label class=" control-label">Crisis and Highlights</label></td>
        <td style="width: 40%;"><label class=" control-label">Remarks and Recommendations</label></td>
        <td style="width: 10%;"><label class=" control-label">Status</label></td>
    </tr>

    <g:each var="item" in="${list}">
        <g:hiddenField name="hfIsFollowup${item?.id}" value="${item?.is_followup}"></g:hiddenField>
        <g:hiddenField name="hfIsResolve${item?.id}" value="${item?.is_resolve}"></g:hiddenField>
        <g:hiddenField name="hfFollowupMonthFor${item?.id}" value="${item?.followup_month_for}"></g:hiddenField>

            <tr>
                <td style="width: 10%;">
                    <label id="issue${item?.id}" name="issue${item?.id}">
                        ${item?.issue_name}</label>
                </td>
                <td style="width: 10%;">
                    <label id="issuedMonth${item?.id}" name="issuedMonth${item?.id}">
                       ${item?.issuedMonthStr}</label>
                </td>
                <td style="padding: 0 0 0 0 ! important; width: 30%;">
                            <textarea id="description${item?.id}" name="description${item?.id}" rows="3"
                                      style="padding: 0 0 0 0 ! important;"
                                      class="form-control" onclick="showRemarksModal(${item?.id});"
                                      placeholder="">${item?.description}</textarea>
                </td>
                <td style="padding: 0 0 0 0 ! important;width: 40%;">
                        <textarea id="remarks${item?.id}" name="remarks${item?.id}" rows="3"
                                  style="padding: 0 0 0 0 ! important;"
                                  class="form-control" onclick="showRemarksModal(${item?.id});"
                                  placeholder="">${item?.remarks}</textarea>
                </td>
                <td style="padding: 0 0 0 0 ! important;width: 10%;">
                    <textarea id="status${item?.id}" name="status${item?.id}" rows="3"
                              style="padding: 0 0 0 0 ! important;" class="form-control"
                              placeholder="" readonly>${item?.issue_status}</textarea>
                </td>

            </tr>

    </g:each>
</table>