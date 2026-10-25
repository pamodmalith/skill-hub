<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.skillhub.model.User, java.util.List" %>
<%@ page import="com.skillhub.util.HtmlUtil" %>
<%
    List<User> trainers = (List<User>) request.getAttribute("trainers");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Add Course - <%= HtmlUtil.escape(application.getInitParameter("academyName")) %></title>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/bootstrap.min.css">
    <link rel="stylesheet" href="<%= request.getContextPath() %>/css/style.css">
</head>
<body>
<jsp:include page="menu.jsp"/>

<main class="container-lg py-4 px-3">
    <div class="mb-4">
        <h1 class="h3 fw-bold mb-1">Add New Course</h1>
        <p class="text-muted mb-0">Create a new training course and assign a trainer</p>
    </div>

    <%
        if (request.getAttribute("error") != null) {
    %>
    <div class="alert alert-error" role="alert"><%= HtmlUtil.escape((String) request.getAttribute("error")) %></div>
    <%
        }
    %>

    <div class="row">
        <div class="col-12 col-md-8 col-lg-6">
            <div class="card">
                <div class="card-header">Course Details</div>
                <div class="card-body p-4">
                    <form method="post" action="<%= request.getContextPath() %>/admin/add-course">
                        <div class="form-group">
                            <label class="form-label fw-medium" for="title">Course Title</label>
                            <input type="text" id="title" name="title" class="form-control"
                                   value="<%= HtmlUtil.escape((String) request.getAttribute("formTitle")) %>"
                                   required maxlength="100" placeholder="e.g., Java Web Development">
                        </div>

                        <div class="form-group">
                            <label class="form-label fw-medium" for="category">Category</label>
                            <input type="text" id="category" name="category" class="form-control"
                                   value="<%= HtmlUtil.escape((String) request.getAttribute("formCategory")) %>"
                                   required maxlength="50"
                                   placeholder="e.g., Technology, Business">
                        </div>

                        <div class="form-group">
                            <label class="form-label fw-medium" for="description">Description</label>
                            <textarea id="description" name="description" class="form-control" rows="4"
                                      required maxlength="500"
                                      placeholder="Course description..."><%= HtmlUtil.escape((String) request.getAttribute("formDescription")) %></textarea>
                        </div>

                        <div class="form-group">
                            <label class="form-label fw-medium" for="trainerUsername">Trainer</label>
                            <select id="trainerUsername" name="trainerUsername" class="form-select" required>
                                <option value="">Select a trainer</option>
                                <% if (trainers != null && !trainers.isEmpty()) {
                                    String formTrainer = (String) request.getAttribute("formTrainer");
                                    for (User trainer : trainers) {
                                        String selected = trainer.getUsername().equals(formTrainer) ? " selected" : "";
                                %>
                                <option value="<%= trainer.getUsername() %>"<%= selected %>>
                                    <%= HtmlUtil.escape(trainer.getFullName()) %> (<%= HtmlUtil.escape(trainer.getUsername()) %>)
                                </option>
                                <% }
                                } else { %>
                                <option value="" disabled>No trainers available</option>
                                <% } %>
                            </select>
                            <% if (trainers == null || trainers.isEmpty()) { %>
                            <div class="form-text text-danger mt-1">Add a trainer first before creating a course.</div>
                            <% } %>
                        </div>

                        <div class="d-flex gap-2 mt-3">
                            <button type="submit" class="btn btn-primary">Create Course</button>
                            <a href="<%= request.getContextPath() %>/courses" class="btn btn-outline-secondary">Cancel</a>
                        </div>
                    </form>
                </div>
            </div>
        </div>
    </div>
</main>

<footer class="sh-footer mt-4">
    <div class="container-lg text-center">
        &copy; 2026 <%= HtmlUtil.escape(application.getInitParameter("academyName")) %>. All rights reserved.
    </div>
</footer>

<script src="<%= request.getContextPath() %>/js/bootstrap.bundle.min.js"></script>
</body>
</html>
