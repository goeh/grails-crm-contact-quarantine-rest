<g:each in="${list}" var="c">
    <tr>
        <td><g:radio name="company" value="${c.id}" checked="${c.id == selected}"/></td>
        <td><g:link mapping="crm-contact-show" id="${c.id}">${c.name}</g:link></td>
        <td>${c.email}</td>
        <td>${c.telephone}</td>
        <td>${c.fullAddress}</td>
    </tr>
</g:each>
