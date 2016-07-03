<g:form action="createTask">

    <input type="hidden" name="id" value="${bean.id}"/>

    <div class="modal-header">
        <a class="close" data-dismiss="modal">×</a>

        <h3>Ny aktivitet - ${bean.fullName}</h3>
    </div>

    <div class="modal-body" style="overflow: auto;">

        <div class="control-group">
             <label class="control-label"><g:message code="crmTask.type.label" /></label>

             <div class="controls">
                 <g:select from="${typeList}" name="type.id" optionKey="id" value="${crmTask.type?.id}"
                           style="width: 92%;"/>
             </div>
         </div>

         <div class="control-group">
             <label class="control-label"><g:message code="crmTask.name.label" /></label>

             <div class="controls">
                 <g:textField name="name" value="${crmTask.name}" style="width: 90%;"/>
             </div>
         </div>

         <div class="control-group">
             <label class="control-label"><g:message code="crmTask.startTime.label" /></label>

             <div class="controls">
                 <div class="input-append date">
                     <g:textField name="startTime" size="10" style="width: 70%;"
                                  value="${formatDate(type: 'date', date: crmTask.startTime ?: new Date() + 1)}"/><span
                         class="add-on"><i class="icon-th"></i></span>
                 </div>

                 <g:select name="inspectionTime" from="${timeList}" value="09:00"
                           style="margin-left: 5px; width: 20%"/>
             </div>
         </div>

        <div class="control-group">
            <label class="control-label">Beskrivning</label>

            <div class="controls">
                <g:textArea name="description" value="${bean.comments}" rows="3" style="width: 90%;"/>
            </div>
        </div>

    </div>

    <div class="modal-footer">
        <crm:button action="createTask" visual="success" icon="icon-ok icon-white"
                    label="crmContact.button.save.label" default="Save"/>
        <a href="#" class="btn" data-dismiss="modal"><i class="icon-remove"></i> <g:message
                code="default.button.close.label" default="Close"/></a>
    </div>
</g:form>
