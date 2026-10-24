<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Profile - ${academyName}</title>
    <link rel="stylesheet" href="<c:url value='/css/style.css'/>">
</head>
<body>
<jsp:include page="menu.jsp"/>

<main class="main container">
    <div class="page-header">
        <h1 class="page-title">My Profile</h1>
        <p class="page-subtitle">Your account information</p>
    </div>

    <div class="card">
        <div class="card-body">
            <div style="max-width: 500px;">
                <div class="form-group">
                    <label class="form-label">Full Name</label>
                    <input type="text" class="form-control" value="${sessionScope.loggedUser.fullName}" readonly style="background: #f9fafb;">
                </div>

                <div class="form-group">
                    <label class="form-label">Username</label>
                    <input type="text" class="form-control" value="${sessionScope.loggedUser.username}" readonly style="background: #f9fafb;">
                </div>

                <div class="form-group">
                    <label class="form-label">Email</label>
                    <input type="email" class="form-control" value="${sessionScope.loggedUser.email}" readonly style="background: #f9fafb;">
                </div>

                <div class="form-group">
                    <label class="form-label">Role</label>
                    <input type="text" class="form-control" value="${sessionScope.loggedUser.role}" readonly style="background: #f9fafb;">
                </div>

                <div class="form-group">
                    <label class="form-label">Academy</label>
                    <input type="text" class="form-control" value="${academyName}" readonly style="background: #f9fafb;">
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="footer container">
    <p>&copy; 2026 ${academyName}. All rights reserved.</p>
</footer>
</body>
</html>