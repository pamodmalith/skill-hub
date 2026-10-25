package com.skillhub.controller;

import com.skillhub.data.DataStore;
import com.skillhub.model.Course;
import com.skillhub.model.Role;
import com.skillhub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

@WebServlet(urlPatterns = {"/enroll", "/admin/enroll"})
public class EnrollmentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/admin/enroll".equals(path)) {
            DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
            List<User> students = store.getUsersByRole(Role.STUDENT);
            List<Course> courses = store.getAllCourses();
            req.setAttribute("students", students);
            req.setAttribute("courses", courses);
            req.getRequestDispatcher("/WEB-INF/views/enroll-student.jsp").forward(req, resp);
        } else {
            // GET /enroll is not allowed
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");

        if ("/enroll".equals(path)) {
            // Student self-enrolment
            String courseIdParam = req.getParameter("courseId");
            if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/courses?msg=invalidCourse");
                return;
            }

            int courseId;
            try {
                courseId = Integer.parseInt(courseIdParam.trim());
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/courses?msg=invalidCourse");
                return;
            }

            Course course = store.getCourse(courseId);
            if (course == null) {
                resp.sendRedirect(req.getContextPath() + "/courses?msg=invalidCourse");
                return;
            }

            boolean success = store.enroll(user.getUsername(), courseId);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/dashboard?msg=enrolled");
            } else {
                resp.sendRedirect(req.getContextPath() + "/courses?msg=alreadyEnrolled");
            }

        } else if ("/admin/enroll".equals(path)) {
            // Admin enrols a student
            String studentUsername = req.getParameter("studentUsername");
            String courseIdParam = req.getParameter("courseId");

            if (studentUsername == null || studentUsername.trim().isEmpty()
                    || courseIdParam == null || courseIdParam.trim().isEmpty()) {
                resp.sendRedirect(req.getContextPath() + "/admin/enroll?msg=invalid");
                return;
            }

            int courseId;
            try {
                courseId = Integer.parseInt(courseIdParam.trim());
            } catch (NumberFormatException e) {
                resp.sendRedirect(req.getContextPath() + "/admin/enroll?msg=invalid");
                return;
            }

            User student = store.getUser(studentUsername);
            Course course = store.getCourse(courseId);

            if (student == null || student.getRole() != Role.STUDENT || course == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/enroll?msg=invalid");
                return;
            }

            boolean success = store.enroll(studentUsername, courseId);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/enroll?msg=enrolledByAdmin");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/enroll?msg=alreadyEnrolled");
            }
        }
    }
}