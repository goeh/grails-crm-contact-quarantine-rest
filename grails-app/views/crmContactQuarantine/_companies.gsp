<g:each in="${list}" var="c">
    <tr>
        <td><input type="radio" name="company" value="${c.id}"/></td>
        <td><g:link mapping="crm-contact-show" id="${c.id}">${c.name}</g:link></td>
        <td>${c.email}</td>
        <td>${c.telephone}</td>
        <td>${c.fullAddress}</td>
    </tr>
</g:each>
