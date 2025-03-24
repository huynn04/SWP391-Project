<body>
    <%@ include file="navbar.jsp" %> 
    <h2>Danh M?c S?n Ph?m</h2>
    <table border="1">
        <tr>
            <th>H�nh ?nh</th>
            <th>T�n Danh M?c</th>
            <th>M� T?</th>
            <th>Tr?ng Th�i</th>
            <th>Ng�y T?o</th>
        </tr>
        <c:forEach var="category" items="${categoryList}">
            <tr>
                <td><img src="${category.image}" alt="Image" width="50"></td>
                <td>${category.categoryName}</td>
                <td>${category.description}</td>
                <td>
                    <c:choose>
                        <c:when test="${category.status == 1}">Ho?t ??ng</c:when>
                        <c:otherwise>Kh�ng ho?t ??ng</c:otherwise>
                    </c:choose>
                </td>
                <td>${category.createdAt}</td>
            </tr>
        </c:forEach>
    </table>
</body>
