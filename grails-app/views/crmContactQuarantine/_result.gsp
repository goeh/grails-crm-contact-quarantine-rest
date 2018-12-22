<g:each in="${result.keySet()}" var="p">
    <tr>
        <td>
            <%= raw(g.link(p, result[p])) %>
        </td>
    </tr>
</g:each>
