package com.skillhub.controller;

import com.skillhub.data.DataStore;
import com.skillhub.model.AttendanceStatus;
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
import java.time.LocalDate;
import java.time.format.DateTimeParseException;
import java.util.*;

@WebServlet("/attendance")
public class AttendanceServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");

        boolean isAdmin = user.getRole() == Role.ADMIN;

        // Always set the list of courses the user can see
        List<Course> courses = isAdmin ? store.getAllCourses() : store.getCoursesByTrainer(user.getUsername());
        req.setAttribute("courses", courses);

        String courseIdParam = req.getParameter("courseId");
        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            // No course selected - show picker only
            req.getRequestDispatcher("/WEB-INF/views/attendance.jsp").forward(req, resp);
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdParam.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/attendance?msg=invalidCourse");
            return;
        }

        Course course = store.getCourse(courseId);
        if (course == null) {
            resp.sendRedirect(req.getContextPath() + "/attendance?msg=invalidCourse");
            return;
        }

        // Ownership check for trainers
        if (!isAdmin && !course.getTrainerUsername().equals(user.getUsername())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Parse date
        LocalDate date;
        String dateParam = req.getParameter("date");
        try {
            date = (dateParam != null && !dateParam.trim().isEmpty())
                    ? LocalDate.parse(dateParam.trim())
                    : LocalDate.now();
        } catch (DateTimeParseException e) {
            date = LocalDate.now();
        }

        // Get data for the view
        List<User> students = store.getStudentsInCourse(courseId);
        Map<String, AttendanceStatus> statuses = store.getAttendance(courseId, date);

        // Past sessions summary (newest first)
        Map<LocalDate, int[]> sessionSummaries = new LinkedHashMap<>();
        for (LocalDate d : store.getSessionDates(courseId)) {
            Map<String, AttendanceStatus> dayStatuses = store.getAttendance(courseId, d);
            int present = 0, absent = 0;
            for (AttendanceStatus status : dayStatuses.values()) {
                if (status == AttendanceStatus.PRESENT) present++;
                else absent++;
            }
            sessionSummaries.put(d, new int[]{present, absent});
        }

        req.setAttribute("course", course);
        req.setAttribute("date", date);
        req.setAttribute("today", LocalDate.now());
        req.setAttribute("students", students);
        req.setAttribute("statuses", statuses);
        req.setAttribute("sessionSummaries", sessionSummaries);
        req.setAttribute("readOnly", isAdmin);

        req.getRequestDispatcher("/WEB-INF/views/attendance.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");
        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");

        // Only trainers can POST
        if (user.getRole() != Role.TRAINER) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        String courseIdParam = req.getParameter("courseId");
        String dateParam = req.getParameter("date");

        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/attendance?msg=invalidCourse");
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdParam.trim());
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/attendance?msg=invalidCourse");
            return;
        }

        Course course = store.getCourse(courseId);
        if (course == null) {
            resp.sendRedirect(req.getContextPath() + "/attendance?msg=invalidCourse");
            return;
        }

        // Ownership check
        if (!course.getTrainerUsername().equals(user.getUsername())) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        LocalDate date;
        try {
            date = LocalDate.parse(dateParam.trim());
        } catch (DateTimeParseException | NullPointerException e) {
            resp.sendRedirect(req.getContextPath() + "/attendance?courseId=" + courseId + "&msg=invalidDate");
            return;
        }

        // Cannot record for future dates
        if (date.isAfter(LocalDate.now())) {
            resp.sendRedirect(req.getContextPath() + "/attendance?courseId=" + courseId + "&msg=futureDate");
            return;
        }

        // Build status map for all enrolled students
        List<User> students = store.getStudentsInCourse(courseId);
        Map<String, AttendanceStatus> statuses = new HashMap<>();
        for (User student : students) {
            String paramName = "status_" + student.getUsername();
            String statusParam = req.getParameter(paramName);
            AttendanceStatus status = "PRESENT".equals(statusParam)
                    ? AttendanceStatus.PRESENT
                    : AttendanceStatus.ABSENT;
            statuses.put(student.getUsername(), status);
        }

        store.saveAttendance(courseId, date, statuses);
        getServletContext().log("Attendance saved for course " + courseId + " on " + date + " by " + user.getUsername());

        resp.sendRedirect(req.getContextPath() + "/attendance?courseId=" + courseId + "&date=" + date + "&msg=attendanceSaved");
    }
}