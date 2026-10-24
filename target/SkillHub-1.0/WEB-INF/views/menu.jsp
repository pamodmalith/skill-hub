<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<nav class="header" role="navigation">
    <div class="nav container">
        <a class="nav-brand" href="<c:url value='/dashboard'/>">${academyName}</a>
        <ul class="nav-links">
            <li><a href="<c:url value='/dashboard'/>">Dashboard</a></li>
            <li><a href="<c:url value='/courses'/>">Courses</a></li>
            <c:if test="${sessionScope.loggedUser.role == 'ADMIN'}">
                <li><a href="<c:url value='/admin/add-course'/>">Add Course</a></li>
            </c:if>
        </ul>
        <div class="nav-user">
            <span><c:out value="${sessionScope.loggedUser.fullName}"/></span>
            <span class="btn btn-secondary btn-sm"><c:out value="${sessionScope.loggedUser.role}"/></span>
            <a href="<c:url value='/profile'/>" class="btn btn-secondary btn-sm">Profile</a>
            <a href="<c:url value='/logout'/>" class="btn btn-primary btn-sm">Logout</a>
        </div>
    </div>
</nav>