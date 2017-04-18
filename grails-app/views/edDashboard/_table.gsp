<table class="table table-bordered table-hover">

    <tr style="background-color: #c0c0c0">
        <td style="width: 10%;"><label class=" control-label">Issue</label></td>
        <td style="width: 10%;"><label class=" control-label"></label></td>
        <td style="width: 30%;"><label class=" control-label">Crisis & Highlights</label></td>
        <td style="width: 25%;"><label class=" control-label">Remarks</label></td>
        <td style="width: 25%;"><label class=" control-label">ED's Advice</label></td>
    </tr>

    <g:each var="item" in="${list}">
        <g:hiddenField name="hfIsHeading${item?.id}" value="${item?.is_heading}"></g:hiddenField>
        <g:hiddenField name="hfIsAdditional${item?.id}" value="${item?.is_additional}"></g:hiddenField>
        <g:if test="${!item?.is_heading}">
            <tr>

                <td style="width: 10%;">

                    <label id="issue${item?.id}" name="issue${item?.id}">
                        ${item?.issue_name}</label></td>
                <td style="width: 10%;">

                    <input type="radio" name="selection${item?.id}" id="selection${item?.id}"
                           onchange="loadFollowupMonth(this);" value="New" checked><label>New</label><br/>

                    <input type="radio" name="selection${item?.id}" id="selection${item?.id}"
                           onchange="loadFollowupMonth(this);" value="Followup"><label>Followup</label><br/>

                    <div id="divfollowupMonth${item?.id}" style="display: none;">
                        <input type="text" id="followupMonth${item?.id}" name="followupMonth${item?.id}"
                               placeholder="Select month" style="width: 100px;">
                    </div>

                </td>
                <td style="padding: 0 0 0 0 ! important; width: 30%;">
<div id="divDescriptionTextArea${item?.id}">
                    <g:if test="${!isEdAssistant ? item?.crisis_remarks_g : item?.crisis_remarks_s}">
                        <textarea id="description${item?.id}" name="description${item?.id}" rows="3"
                                  style="padding: 0 0 0 0 ! important;"
                                  class="form-control" readonly>${item?.description}</textarea>
                    </g:if>
                    <g:else>
                        <textarea id="description${item?.id}" name="description${item?.id}" rows="3"
                                  style="padding: 0 0 0 0 ! important;"
                                  class="form-control"
                                  placeholder="">${item?.description}</textarea>
                    </g:else>
</div>
                    <div id="divDescFollowupMonthDDL${item?.id}" style="display: none;">
                            <select
                                    id="descFollowupMonthDDL${item?.id}" name="descFollowupMonthDDL${item?.id}"
                                    class="kendo-drop-down" onchange="loadRemarksAndEdAdvice(this);">
                            </select>
                    </div>

                </td>
                <td style="padding: 0 0 0 0 ! important;width: 25%;">
                    <g:if test="${!isEdAssistant ? item?.crisis_remarks_g : item?.crisis_remarks_s}">
                        <textarea id="remarks${item?.id}" name="remarks${item?.id}" rows="3"
                                  style="padding: 0 0 0 0 ! important;"
                                  class="form-control" readonly>${item?.remarks}</textarea>
                    </g:if>
                    <g:else>
                        <textarea id="remarks${item?.id}" name="remarks${item?.id}" rows="3"
                                 style="padding: 0 0 0 0 ! important;"
                                  class="form-control"
                                  placeholder="">${item?.remarks}</textarea>


                    </g:else>
                </td>
                <td style="padding: 0 0 0 0 ! important;width: 25%;">
                    <g:if test="${!isEdAssistant ? item?.advice_g : item?.advice_s}">
                        <textarea id="edAdvice${item?.id}" name="edAdvice${item?.id}" rows="3"
                                  style="padding: 0 0 0 0 ! important;"
                                  class="form-control" readonly
                                  placeholder="">${item?.ed_advice}</textarea>
                    </g:if>
                    <g:else>
                        <textarea id="edAdvice${item?.id}" name="edAdvice${item?.id}" rows="3"
                                  style="padding: 0 0 0 0 ! important;"
                                  class="form-control"
                                  placeholder="">${item?.ed_advice}</textarea>
                    </g:else>
                </td>

            </tr>
        </g:if>
        <g:else>
            <tr style="background-color: #c0c0c0">
                <td colspan="6" style="width: 100%; text-align: left;">
                    <label id="issue${item?.id}" name="issue${item?.id}">
                        ${item?.issue_name}</label></td>
            </tr>
        </g:else>
    </g:each>
</table>