<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <meta name="layout" content="main"/>
    <title>Contact Quarantine</title>
    <r:script>
        $(document).ready(function() {
            $('thead input[type="checkbox"]').click(function(ev) {
                $(":checkbox[name='id']", $(this).closest('form')).prop('checked', $(this).is(':checked'));
            });
        });
    </r:script>
    <style type="text/css">
    </style>
</head>

<body>

<g:form>
    <table class="table">
        <thead>
        <tr>
            <th>Namn</th>
            <th>E-post</th>
            <th>Telefon</th>
            <th>Adress</th>
            <th>Mål</th>
            <th>Tidpunkt</th>
            <th><input type="checkbox" name="select-all" title="Markera alla rader"/></th>
        </tr>
        </thead>
        <tbody>
        <g:each in="${result}" var="obj">
            <tr>
                <td><g:link action="show" id="${obj.id}">${obj.fullName}</g:link></td>
                <td class="nowrap"><g:link action="show" id="${obj.id}">${obj.email}</g:link></td>
                <td class="nowrap">${obj.telephone}</td>
                <td>${obj.fullAddress}</td>
                <td class="nowrap">${obj.target}</td>
                <td class="nowrap"><g:formatDate type="datetime" date="${obj.timestamp ? new Date(obj.timestamp) : null}"/></td>
                <td>
                    <input type="checkbox" name="id" value="${obj.id}"/>
                </td>
            </tr>
        </g:each>
        </tbody>
    </table>

    <div class="form-actions">
        <crm:button action="delete" label="crmContactQuarantine.button.delete.label" icon="icon-trash icon-white" visual="danger" confirm="Bekräfta borttag"/>
    </div>

</g:form>

</body>
</html>