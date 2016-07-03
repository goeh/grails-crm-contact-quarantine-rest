<g:form action="createCompany">

    <input type="hidden" name="id" value="${bean.id}"/>

    <div class="modal-header">
        <a class="close" data-dismiss="modal">×</a>

        <h3>Registrera nytt företag</h3>
    </div>

    <div class="modal-body" style="overflow: auto;">

        <div class="control-group">
            <label class="control-label">Företagsnamn</label>

            <div class="controls">
                <input type="text" name="name" value="${bean.companyName}" style="width: 90%;"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Adressrad 1</label>

            <div class="controls">
                <input type="text" name="address.address1" value="${bean.address1}" style="width: 90%;"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Adressrad 2</label>

            <div class="controls">
                <input type="text" name="address.address2" value="${bean.address2}" style="width: 90%;"/>
            </div>
        </div>

        <div class="control-group">
            <label class="control-label">Postnr/ort</label>

            <div class="controls">
                <input type="text" name="address.postalCode" value="${bean.postalCode}" style="width: 20%;"/>
                <input type="text" name="address.city" value="${bean.city}" style="width: 70%;"/>
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

        <div class="control-group">
            <label class="control-label">Noteringar på företaget</label>

            <div class="controls">
                <g:textArea name="description" value="${bean.comments}" rows="3" style="width: 90%;"/>
            </div>
        </div>

    </div>

    <div class="modal-footer">
        <crm:button action="createCompany" visual="success" icon="icon-ok icon-white"
                    label="crmContact.button.save.label" default="Save"/>
        <a href="#" class="btn" data-dismiss="modal"><i class="icon-remove"></i> <g:message
                code="default.button.close.label" default="Close"/></a>
    </div>
</g:form>
