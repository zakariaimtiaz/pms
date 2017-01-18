<table class="table table-bordered table-hover">

    <tr style="background-color: #c0c0c0">
        <td style="width: 10%;"><label class=" control-label">Issue</label></td>
        <td style="width: 40%;"><label class=" control-label">Description</label></td>
        <td style="width: 25%;"><label class=" control-label">Remarks</label></td>
        <td style="width: 25%;"><label class=" control-label">Ed's Advice</label></td>
    </tr>

    <g:each var="item" in="${list}">
        <g:hiddenField name="hfIsHeading${item?.id}" value="${item?.is_heading}"></g:hiddenField>
        <g:if test="${!item?.is_heading}">
            <tr>

                <td style="width: 10%;">

                    <label id="issue${item?.id}" name="issue${item?.id}">
                        ${item?.issue_name}</label></td>
                <td style="padding: 0 0 0 0 ! important; width: 40%;">

                    <g:if test="${item?.isReadable}">
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

                </td>
                <td style="padding: 0 0 0 0 ! important;width: 25%;">
                    <g:if test="${item?.isReadable}">
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
                    <textarea id="edAdvice${item?.id}" name="edAdvice${item?.id}" rows="3"
                              style="padding: 0 0 0 0 ! important;"
                              class="form-control"
                              placeholder="">${item?.ed_advice}</textarea>

                </td>

            </tr>
        </g:if>
        <g:else>
            <tr style="background-color: #c0c0c0">
                <td colspan="4" style="width: 100%; text-align: left;">
                    <label id="issue${item?.id}" name="issue${item?.id}">
                        ${item?.issue_name}</label></td>
            </tr>
        </g:else>
    </g:each>
</table>