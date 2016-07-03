<g:form action="createPerson">

    <input type="hidden" name="id" value="${bean.id}"/>
    <input type="hidden" name="company" value="${company?.id}"/>

    <div class="modal-header">
        <a class="close" data-dismiss="modal">×</a>

        <h3>Registrera ny person
            <g:if test="${company}">
                <small>${company}</small>
            </g:if>
        </h3>
    </div>

    <div class="modal-body" style="overflow: auto;">

        <div class="control-group">
            <label class="control-label">Namn</label>

            <div class="controls">
                <input type="text" name="firstName" value="${bean.firstName}" style="width: 40%;"/>
                <input type="text" name="lastName" value="${bean.lastName}" style="width: 45%;"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Titel</label>

            <div class="controls">
                <input type="text" name="title" value="${bean.title}" style="width: 90%;"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">E-post</label>

            <div class="controls">
                <input type="text" name="email" value="${bean.email}" style="width: 90%;"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Telefon</label>

            <div class="controls">
                <input type="text" name="telephone" value="${bean.telephone}" style="width: 90%;"/>
            </div>
        </div>

        <g:if test="${company}">
            <div class="control-group">
                <label class="control-label">Roll/relation</label>

                <div class="controls">
                    <g:select from="${roles}" name="role" optionKey="param" style="width: 90%;"/>
                </div>
            </div>
        </g:if>

        <div class="control-group">
            <label class="control-label">Noteringar på personen</label>

            <div class="controls">
                <g:textArea name="description" value="${bean.comments}" rows="3" style="width: 90%;"/>
            </div>
        </div>

    </div>

    <div class="modal-footer">
        <crm:button action="createPerson" visual="success" icon="icon-ok icon-white"
                    label="crmContact.button.save.label" default="Save"/>
        <a href="#" class="btn" data-dismiss="modal"><i class="icon-remove"></i> <g:message
                code="default.button.close.label" default="Close"/></a>
    </div>
</g:form>
