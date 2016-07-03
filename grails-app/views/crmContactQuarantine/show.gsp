<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Contact Quarantine</title>
    <r:script>
        var searchDelay = (function(){
          var timer = 0;
          return function(callback, ms){
            clearTimeout (timer);
            timer = setTimeout(callback, ms);
          };
        })();
        var crmContactQuarantine = {
            loadCompanies: function(q) {
                if(!q) q = '';
                $('#company-container tbody').load("${createLink(action: 'companies', id: contact.id)}?q=" + q);
            },
            loadContacts: function(q) {
                if(!q) q = '';
                $('#person-container tbody').load("${createLink(action: 'contacts', id: contact.id)}?q=" + q);
            }
        };
        $(document).ready(function () {
            $('button[name="_action_company"]').click(function (ev) {
                ev.preventDefault();
                var $modal = $('#modal-container');
                $modal.load("${createLink(action: 'createCompany', id: contact.id)}", function() {
                    $modal.modal('show');
                    $('form', $modal).submit(function(ev) {
                        ev.preventDefault();
                        var $form = $(this);
                        $.ajax({
                            type: $form.attr('method'),
                            url: $form.attr('action'),
                            data: $form.serialize(),
                            success: function (data) {
                                $modal.modal('hide');
                                crmContactQuarantine.loadCompanies(null);
                            },
                            error: function(data) {
                                alert("Error " + data);
                            }
                        });
                    });
                });
            });
            $('button[name="_action_person"]').click(function (ev) {
                ev.preventDefault();
                var $modal = $('#modal-container');
                var selectedCompany = $('input[name="company"]:checked').val();
                $modal.load("${createLink(action: 'createPerson', id: contact.id)}?company=" + selectedCompany, function() {
                    $modal.modal('show');
                    $('form', $modal).submit(function(ev) {
                        ev.preventDefault();
                        var $form = $(this);
                        $.ajax({
                            type: $form.attr('method'),
                            url: $form.attr('action'),
                            data: $form.serialize(),
                            success: function (data) {
                                $modal.modal('hide');
                                crmContactQuarantine.loadContacts(null);
                            },
                            error: function(data) {
                                alert("Error " + data);
                            }
                        });
                    });
                });
            });
            $('button[name="_action_booking"]').click(function (ev) {
                ev.preventDefault();
                var $modal = $('#modal-container');
                var selectedContact = $('input[name="person"]:checked').val();
                if(! selectedContact) {
                    return;
                }
                $modal.load("${createLink(action: 'createBooking', id: contact.id)}?person=" + selectedContact, function() {
                    $modal.modal('show');
                    $('form', $modal).submit(function(ev) {
                        ev.preventDefault();
                        var $form = $(this);
                        $.ajax({
                            type: $form.attr('method'),
                            url: $form.attr('action'),
                            data: $form.serialize(),
                            success: function (data) {
                                $modal.modal('hide');
                                //crmContactQuarantine.loadContacts(null);
                            },
                            error: function(data) {
                                alert("Error " + data);
                            }
                        });
                    });
                });
            });
            $('button[name="_action_task"]').click(function (ev) {
                ev.preventDefault();
                var $modal = $('#modal-container');
                $modal.load("${createLink(action: 'createTask', id: contact.id)}", function() {
                    $modal.modal('show');
                });
            });

            $('.crm-search').click(function(ev) {
                var $self = $(this);
                var $table = $self.closest('table');
                var $toggle = $table.find('.crm-toggle');
                $toggle.children().toggle();
                var $input = $toggle.find('input');
                if($input.is(':visible')) {
                    $input.focus();
                }
            });

            $('.crm-toggle input').keydown(function(event){
                if(event.keyCode == 13) {
                    event.preventDefault();
                    return false;
                }
            });

            $('#company-container .crm-toggle input').keyup(function() {
                var q = $(this).val();
                searchDelay(function(){
                    crmContactQuarantine.loadCompanies(q);
                }, 750 );
            });

            $('#person-container .crm-toggle input').keyup(function() {
                var q = $(this).val();
                searchDelay(function(){
                    crmContactQuarantine.loadContacts(q);
                }, 750 );
            });

            crmContactQuarantine.loadContacts(null);
            crmContactQuarantine.loadCompanies(null);
        });
    </r:script>
    <style type="text/css">
    .crm-search {
        cursor: pointer;
    }
    .crm-toggle input {
        margin-bottom: 0;
        padding: 1px 4px;
    }
    </style>
</head>

<body>

<header class="page-header clearfix">
    <h1>
        Kontakt via webben
        <small><g:formatDate format="'den' d MMMM yyyy 'kl.' HH:mm" date="${contact.timestamp ? new Date(contact.timestamp) : null}"/></small>
    </h1>
    <g:if test="${target}">
        <h2>${target}</h2>
    </g:if>
</header>

<g:form>
    <div class="row-fluid">
        <div class="span5">
            <div class="row-fluid">
                <div class="control-group">
                    <label class="control-label">Namn</label>

                    <div class="controls">
                        <g:textField name="firstName" value="${contact.firstName}" class="span5"/>
                        <g:textField name="lastName" value="${contact.lastName}" class="span6"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Titel</label>

                    <div class="controls">
                        <g:textField name="title" value="${contact.title}" class="span11"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Företag</label>

                    <div class="controls">
                        <g:textField name="companyName" value="${contact.companyName}" class="span11"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Adress</label>

                    <div class="controls">
                        <g:textField name="address1" value="${contact.address1}" class="span11"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Postnr/ort</label>

                    <div class="controls">
                        <g:textField name="postalCode" value="${contact.postalCode}" class="span3"/>
                        <g:textField name="city" value="${contact.city}" class="span8"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Telefon</label>

                    <div class="controls">
                        <g:textField name="telephone" value="${contact.telephone}" class="span11"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">E-post</label>

                    <div class="controls">
                        <g:textField name="email" value="${contact.email}" class="span11"/>
                    </div>
                </div>

                <div class="control-group">
                    <label class="control-label">Meddelande</label>

                    <div class="controls">
                        <g:textArea name="comments" value="${contact.comments}" rows="3" class="span11"/>
                    </div>
                </div>

            </div>
        </div>

        <div class="span7">
            <div class="row-fluid">

                <h4>Matchande personer</h4>

                <div id="person-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th class="crm-search"><i class="icon-search"></i></th>
                                <th class="crm-toggle">
                                    <span>Namn</span>
                                    <input type="text" name="q" maxlength="80" style="display: none;"/>
                                </th>
                                <th>E-post</th>
                                <th>Telefon</th>
                                <th>Adress</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>
                                    <g:img dir="images" file="spinner.gif" alt="Loading..."/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <h4>Matchande företag</h4>

                <div id="company-container">
                    <table class="table">
                        <thead>
                            <tr>
                                <th class="crm-search"><i class="icon-search"></i></th>
                                <th class="crm-toggle">
                                    <span>Företagsnamn</span>
                                    <input type="text" name="q" maxlength="80" style="display: none;"/>
                                </th>
                                <th>E-post</th>
                                <th>Telefon</th>
                                <th>Adress</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td colspan="5">
                                    <g:img dir="images" file="spinner.gif" alt="Loading..."/>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

            </div>
        </div>
    </div>

    <div class="form-actions">
        <input type="hidden" name="id" value="${contact.id}"/>
        <crm:button action="update" label="Uppdatera" icon="icon-pencil icon-white" visual="warning"/>
        <crm:button action="company" label="Nytt företag" icon="icon-home icon-white" visual="success"/>
        <crm:button action="person" label="Ny person" icon="icon-user icon-white" visual="success"/>
        <crm:button action="booking" label="Ny bokning" icon="icon-glass icon-white" visual="info"/>
        <crm:button action="task" label="Ny aktivitet" icon="icon-time icon-white" visual="info"/>
        <crm:button action="delete" label="Ta bort" icon="icon-trash icon-white" visual="danger"
                    confirm="Bekräfta borttag"/>
        <crm:button type="link" action="index" label="Tillbaka" icon="icon-remove"/>
    </div>

</g:form>

<div class="modal hide fade" id="modal-container"></div>

</body>
</html>