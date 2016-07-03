<g:each in="${list}" var="c">
    <tr>
        <td><input type="radio" name="person" value="${c.id}"/></td>
        <td><g:link mapping="crm-contact-show" id="${c.id}">${c.fullName}</g:link></td>
        <td>${c.email}</td>
        <td>${c.preferredPhone}</td>
        <td>${c.fullAddress}</td>
    </tr>
</g:each>
