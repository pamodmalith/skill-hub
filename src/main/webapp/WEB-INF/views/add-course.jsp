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
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<%@include file="menu.jsp"%>

<main class="main container">
    <div class="page-header">
        <h1 class="page-title">Add New Course</h1>
        <p class="page-subtitle">Create a new training course and assign a trainer</p>
    </div>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-error"><%= request.getAttribute("error") %></div>
    <% } %>

    <div class="card">
        <div class="card-body">
            <form method="post" action="<%= request.getContextPath() %>/admin/add-course">
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
                        <% if (trainers != null) {
                               for (User trainer : trainers) { %>
                            <option value="<%= trainer.getUsername() %>"><%= trainer.getFullName() %> (<%= trainer.getUsername() %>)</option>
                        <%     }
                           } %>
                    </select>
                </div>

                <div style="display: flex; gap: 12px;">
                    <button type="submit" class="btn btn-primary">Create Course</button>
                    <a href="<%= request.getContextPath() %>/courses" class="btn btn-secondary"
                       style="padding-top: 10px; padding-bottom: 10px;">Cancel</a>
                </div>
            </form>
        </div>
    </div>
</main>

<footer class="footer container">
    <p>&copy; 2026 <%= application.getInitParameter("academyName") %>. All rights reserved.</p>
</footer>
</body>
</html>
