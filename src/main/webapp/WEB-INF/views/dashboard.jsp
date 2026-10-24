<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Dashboard - ${academyName}</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<jsp:include page="menu.jsp"/>

<main class="main container">
    <div class="page-header">
        <h1 class="page-title">Dashboard</h1>
        <p class="page-subtitle">Welcome, <c:out value="${sessionScope.loggedUser.fullName}"/>!</p>
    </div>

    <c:if test="${param.msg == 'enrolled'}">
        <div class="alert alert-success">Successfully enrolled in the course!</div>
    </c:if>
    <c:if test="${param.msg == 'duplicate'}">
        <div class="alert alert-error">You are already enrolled in this course.</div>
    </c:if>
    <c:if test="${param.msg == 'added'}">
        <div class="alert alert-success">Course added successfully!</div>
    </c:if>

    <c:choose>
        <c:when test="${sessionScope.loggedUser.role == 'STUDENT'}">
            <div class="card">
                <div class="card-header">My Enrolments</div>
                <div class="card-body">
                    <c:if test="${empty enrolledCourses}">
                        <p style="color: #666;">You are not enrolled in any courses yet. <a href="<c:url value='/courses'/>">Browse courses</a> to get started.</p>
                    </c:if>
                    <c:if test="${not empty enrolledCourses}">
                        <div class="table-responsive">
                            <table class="table">
                                <thead>
                                <tr>
                                    <th>Course</th>
                                    <th>Category</th>
                                    <th>Trainer</th>
                                </tr>
                                </thead>
                                <tbody>
                                <c:forEach items="${enrolledCourses}" var="course">
                                    <tr>
                                        <td><c:out value="${course.title}"/></td>
                                        <td><c:out value="${course.category}"/></td>
                                        <td>
                                            <c:set var="trainer" value="${trainerMap[course.id]}"/>
                                            <c:if test="${trainer != null}">
                                                <c:out value="${trainer.fullName}"/>
                                            </c:if>
                                        </td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:when>

        <c:when test="${sessionScope.loggedUser.role == 'TRAINER'}">
            <div class="card">
                <div class="card-header">My Courses</div>
                <div class="card-body">
                    <c:if test="${empty trainerCourses}">
                        <p style="color: #666;">No courses assigned to you.</p>
                    </c:if>
                    <c:forEach items="${trainerCourses}" var="course">
                        <div style="margin-bottom: 24px; padding-bottom: 24px; border-bottom: 1px solid #eef2f7;">
                            <h3 style="margin-bottom: 8px;"><c:out value="${course.title}"/></h3>
                            <p style="color: #666; margin-bottom: 16px;"><c:out value="${course.category}"/></p>
                            <h4 style="margin-bottom: 12px;">Enrolled Students</h4>
                            <c:set var="students" value="${requestScope['studentsForCourse_' + course.id]}"/>
                            <c:if test="${empty students}">
                                <p style="color: #666;">No students enrolled yet.</p>
                            </c:if>
                            <c:if test="${not empty students}">
                                <div class="table-responsive">
                                    <table class="table">
                                        <thead>
                                        <tr>
                                            <th>Student Name</th>
                                            <th>Email</th>
                                        </tr>
                                        </thead>
                                        <tbody>
                                        <c:forEach items="${students}" var="student">
                                            <tr>
                                                <td><c:out value="${student.fullName}"/></td>
                                                <td><c:out value="${student.email}"/></td>
                                            </tr>
                                        </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:if>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </c:when>

        <c:when test="${sessionScope.loggedUser.role == 'ADMIN'}">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-value">${userCount}</div>
                    <div class="stat-label">Total Users</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${courseCount}</div>
                    <div class="stat-label">Total Courses</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${enrollmentCount}</div>
                    <div class="stat-label">Total Enrolments</div>
                </div>
                <div class="stat-card">
                    <div class="stat-value">${activeSessions}</div>
                    <div class="stat-label">Active Sessions</div>
                </div>
            </div>

            <div class="card">
                <div class="card-header">Quick Actions</div>
                <div class="card-body">
                    <a href="<c:url value='/admin/add-course'/>" class="btn btn-primary">Add New Course</a>
                    <a href="<c:url value='/courses'/>" class="btn btn-secondary" style="margin-left: 12px;">View All Courses</a>
                </div>
            </div>
        </c:when>
    </c:choose>
</main>

<footer class="footer container">
    <p>&copy; 2026 ${academyName}. All rights reserved.</p>
</footer>
</body>
</html>