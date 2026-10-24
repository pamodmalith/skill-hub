<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courses - ${academyName}</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<jsp:include page="menu.jsp"/>

<main class="main container">
    <div class="page-header">
        <h1 class="page-title">Available Courses</h1>
        <p class="page-subtitle">Browse and enroll in our training programs</p>
    </div>

    <c:if test="${param.msg == 'added'}">
        <div class="alert alert-success">Course added successfully!</div>
    </c:if>

    <div class="card">
        <div class="card-body">
            <c:if test="${empty courses}">
                <p style="color: #666;">No courses available at the moment.</p>
            </c:if>
            <c:if test="${not empty courses}">
                <div class="table-responsive">
                    <table class="table">
                        <thead>
                        <tr>
                            <th>Title</th>
                            <th>Category</th>
                            <th>Trainer</th>
                            <c:if test="${userRole == 'STUDENT'}"><th>Action</th></c:if>
                        </tr>
                        </thead>
                        <tbody>
                        <c:forEach items="${courses}" var="course">
                            <tr>
                                <td><c:out value="${course.title}"/></td>
                                <td><c:out value="${course.category}"/></td>
                                <td>
                                    <c:set var="trainer" value="${trainerMap[course.id]}"/>
                                    <c:if test="${trainer != null}">
                                        <c:out value="${trainer.fullName}"/>
                                    </c:if>
                                </td>
                                <c:if test="${userRole == 'STUDENT'}">
                                    <td>
                                        <div class="course-actions">
                                            <form method="post" action="<c:url value='/enroll'/>">
                                                <input type="hidden" name="courseId" value="${course.id}"/>
                                                <button type="submit" class="btn btn-primary btn-sm">Enrol</button>
                                            </form>
                                        </div>
                                    </td>
                                </c:if>
                            </tr>
                        </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </div>

    <c:if test="${userRole == 'ADMIN'}">
        <div style="margin-top: 24px; text-align: right;">
            <a href="<c:url value='/admin/add-course'/>" class="btn btn-primary">Add New Course</a>
        </div>
    </c:if>
</main>

<footer class="footer container">
    <p>&copy; 2026 ${academyName}. All rights reserved.</p>
</footer>
</body>
</html>