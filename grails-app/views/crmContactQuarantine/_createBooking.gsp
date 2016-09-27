<g:form action="createBooking">

    <input type="hidden" name="id" value="${bean.id}"/>
    <input type="hidden" name="person" value="${crmTaskAttender.contactId}"/>

    <div class="modal-header">
        <a class="close" data-dismiss="modal">×</a>

        <h3>Boka - ${crmTaskAttender}</h3>
    </div>

    <div class="modal-body" style="overflow: auto;">

        <div class="control-group">
            <label class="control-label"><g:message code="crmTaskBooking.task.label" /></label>

            <div class="controls">
                <g:select name="task" from="${trainingList}" value="${crmTask?.id}" optionKey="id" style="width: 90%;"/>
            </div>
        </div>

        <div class="control-group">
             <label class="control-label"><g:message code="crmTaskAttender.status.label" /></label>

             <div class="controls">
                 <g:select from="${statusList}" name="status" optionKey="param" value="${crmTaskAttender.status?.param}"
                           style="width: 90%;"/>
             </div>
         </div>

         <div class="control-group">
             <label class="control-label"><g:message code="crmTaskAttender.bookingDate.label" /></label>

             <div class="controls">
                 <div class="input-append date">
                     <g:textField name="bookingDate" size="10" style="width: 90%;"
                                  value="${formatDate(type: 'date', date: crmTaskAttender.bookingDate ?: new Date())}"/><span
                         class="add-on"><i class="icon-th"></i></span>
                 </div>
             </div>
         </div>

        <div class="control-group">
            <label class="control-label">Meddelande</label>

            <div class="controls">
                <g:textArea name="comments" value="${bean.comments}" rows="3" style="width: 90%;"/>
            </div>
        </div>

    </div>

    <div class="modal-footer">
        <crm:button action="createBooking" visual="success" icon="icon-ok icon-white"
                    label="crmContact.button.save.label" default="Save"/>
        <a href="#" class="btn" data-dismiss="modal"><i class="icon-remove"></i> <g:message
                code="default.button.close.label" default="Close"/></a>
    </div>
</g:form>
