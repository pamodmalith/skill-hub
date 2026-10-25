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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.concurrent.atomic.AtomicInteger;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
        if (store == null) {
            throw new ServletException("DataStore not initialized");
        }

        AtomicInteger activeSessionsCounter =
                (AtomicInteger) getServletContext().getAttribute("activeSessions");
        int activeSessions = activeSessionsCounter != null ? activeSessionsCounter.get() : 0;

        switch (user.getRole()) {
            case STUDENT: {
                List<Course> myCourses = store.getCoursesOfStudent(user.getUsername());
                Map<Integer, int[]> attendanceSummaries = new HashMap<>();
                for (Course c : myCourses) {
                    attendanceSummaries.put(c.getId(), store.getAttendanceSummary(user.getUsername(), c.getId()));
                }
                req.setAttribute("myCourses", myCourses);
                req.setAttribute("attendanceSummaries", attendanceSummaries);
                break;
            }
            case TRAINER: {
                List<Course> myCourses = store.getCoursesByTrainer(user.getUsername());
                Map<Integer, List<com.skillhub.model.User>> studentsByCourse = new HashMap<>();
                for (Course c : myCourses) {
                    studentsByCourse.put(c.getId(), store.getStudentsInCourse(c.getId()));
                }
                req.setAttribute("myCourses", myCourses);
                req.setAttribute("studentsByCourse", studentsByCourse);
                break;
            }
            case ADMIN: {
                int trainerCount = store.getUsersByRole(Role.TRAINER).size();
                int studentCount = store.getUsersByRole(Role.STUDENT).size();
                int adminCount = store.getUsersByRole(Role.ADMIN).size();
                int userCount = adminCount + trainerCount + studentCount;
                int courseCount = store.getAllCourses().size();
                int enrollmentCount = store.countEnrollments();

                req.setAttribute("trainerCount", trainerCount);
                req.setAttribute("studentCount", studentCount);
                req.setAttribute("userCount", userCount);
                req.setAttribute("courseCount", courseCount);
                req.setAttribute("enrollmentCount", enrollmentCount);
                req.setAttribute("activeSessions", activeSessions);
                break;
            }
        }

        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }
}