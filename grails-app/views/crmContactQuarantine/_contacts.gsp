<g:each in="${list}" var="c">
    <tr>
        <td><g:radio name="person" value="${c.id}" checked="${c.id == selected}"/></td>
        <td><g:link mapping="crm-contact-show" id="${c.id}">${c.fullName}</g:link></td>
        <td>${c.email}</td>
        <td>${c.preferredPhone}</td>
        <td>${c.fullAddress}</td>
    </tr>
</g:each>
