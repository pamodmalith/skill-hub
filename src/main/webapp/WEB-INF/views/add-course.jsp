<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.User, java.util.List" %>
<%
    List<User> trainers = (List<User>) request.getAttribute("trainers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Course - <%= application.getInitParameter("academyName") %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"
          rel="stylesheet"
          integrity="sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"
          crossorigin="anonymous">
</head>
<body class="bg-light">
<jsp:include page="menu.jsp"/>

<main class="container py-4">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">Add New Course</h1>
        <p class="text-muted">Create a new training course and assign a trainer</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="row">
        <div class="col-12 col-md-7 col-lg-6">
            <div class="card shadow-sm border-0">
                <div class="card-body p-4">
                    <form method="post" action="<%= request.getContextPath() %>/admin/add-course">
                        <div class="mb-3">
                            <label class="form-label fw-medium" for="title">Course Title</label>
                            <input type="text" id="title" name="title" class="form-control"
                                   required maxlength="100" placeholder="e.g., Java Web Development">
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-medium" for="category">Category</label>
                            <input type="text" id="category" name="category" class="form-control"
                                   required maxlength="50"
                                   placeholder="e.g., Technology, Business, Professional Development">
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-medium" for="trainerUsername">Trainer</label>
                            <select id="trainerUsername" name="trainerUsername" class="form-select" required>
                                <option value="">Select a trainer</option>
                                <% if (trainers != null) {
                                       for (User trainer : trainers) { %>
                                    <option value="<%= trainer.getUsername() %>">
                                        <%= trainer.getFullName() %> (<%= trainer.getUsername() %>)
                                    </option>
                                <%     }
                                   } %>
                            </select>
                        </div>

                        <div class="d-flex gap-2">
                            <button type="submit" class="btn btn-primary">Create Course</button>
                            <a href="<%= request.getContextPath() %>/courses" class="btn btn-outline-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="bg-white border-top py-3 mt-4">
    <div class="container text-center text-muted small">
        &copy; 2026 <%= application.getInitParameter("academyName") %>. All rights reserved.
    </div>
</footer>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/js/bootstrap.bundle.min.js"
        integrity="sha384-FKyoEForCGlyvwx9Hj09JcYn3nv7wiPVlz7YYwJrWVcXK/BmnVDxM+D2scQbITxI"
        crossorigin="anonymous"></script>
</body>
</html>
