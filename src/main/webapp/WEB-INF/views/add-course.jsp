<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Course - ${academyName}</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<jsp:include page="menu.jsp"/>

<main class="main container">
    <div class="page-header">
        <h1 class="page-title">Add New Course</h1>
        <p class="page-subtitle">Create a new training course and assign a trainer</p>
    </div>

    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>

    <div class="card">
        <div class="card-body">
            <form method="post" action="<c:url value='/admin/add-course'/>">
                <div class="form-group">
                    <label class="form-label" for="title">Course Title</label>
                    <input type="text" id="title" name="title" class="form-control"
                           required maxlength="100" placeholder="e.g., Java Web Development">
                </div>

                <div class="form-group">
                    <label class="form-label" for="category">Category</label>
                    <input type="text" id="category" name="category" class="form-control"
                           required maxlength="50" placeholder="e.g., Technology, Business, Professional Development">
                </div>

                <div class="form-group">
                    <label class="form-label" for="trainerUsername">Trainer</label>
                    <select id="trainerUsername" name="trainerUsername" class="form-control" required>
                        <option value="">Select a trainer</option>
                        <c:forEach items="${trainers}" var="trainer">
                            <option value="${trainer.username}"><c:out value="${trainer.fullName}"/> (<c:out value="${trainer.username}"/>)</option>
                        </c:forEach>
                    </select>
                </div>

                <div style="display: flex; gap: 12px;">
                    <button type="submit" class="btn btn-primary">Create Course</button>
                    <a href="<c:url value='/courses'/>" class="btn btn-secondary" style="padding-top: 10px; padding-bottom: 10px;">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</main>

<footer class="footer container">
    <p>&copy; 2026 ${academyName}. All rights reserved.</p>
</footer>
</body>
</html>