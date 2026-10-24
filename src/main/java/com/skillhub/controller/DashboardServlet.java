package com.skillhub.controller;

import com.skillhub.data.DataStore;
import com.skillhub.model.Course;
import com.skillhub.model.Enrollment;
import com.skillhub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath() + "/login"));
            return;
        }
        
        User user = (User) session.getAttribute("loggedUser");
        if (user == null) {
            resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath() + "/login"));
            return;
        }

        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
        if (store == null) {
            throw new ServletException("DataStore not initialized - AppContextListener may not have run");
        }

        String academyName = getServletContext().getInitParameter("academyName");
        req.setAttribute("academyName", academyName);

        // Active session count from SessionListener (stored as AtomicInteger)
        java.util.concurrent.atomic.AtomicInteger activeSessionsCounter = 
            (java.util.concurrent.atomic.AtomicInteger) getServletContext().getAttribute("activeSessions");
        int activeSessions = activeSessionsCounter != null ? activeSessionsCounter.get() : 0;
        req.setAttribute("activeSessions", activeSessions);

        switch (user.getRole()) {
            case STUDENT:
                List<Enrollment> myEnrollments = store.getEnrollmentsByStudent(user.getUsername());
                List<Course> enrolledCourses = new ArrayList<>();
                Map<Integer, User> trainerMap = new HashMap<>();
                for (Enrollment e : myEnrollments) {
                    Course c = store.getCourse(e.getCourseId());
                    if (c != null) {
                        enrolledCourses.add(c);
                        User trainer = store.getUser(c.getTrainerUsername());
                        if (trainer != null) {
                            trainerMap.put(c.getId(), trainer);
                        }
                    }
                }
                req.setAttribute("enrolledCourses", enrolledCourses);
                req.setAttribute("trainerMap", trainerMap);
                break;

            case TRAINER:
                List<Course> trainerCourses = store.getCoursesByTrainer(user.getUsername());
                req.setAttribute("trainerCourses", trainerCourses);
                // For each course, get enrolled students
                for (Course c : trainerCourses) {
                    List<Enrollment> enrollments = store.getEnrollmentsByCourse(c.getId());
                    List<User> students = new ArrayList<>();
                    for (Enrollment e : enrollments) {
                        User s = store.getUser(e.getStudentUsername());
                        if (s != null) {
                            students.add(s);
                        }
                    }
                    req.setAttribute("studentsForCourse_" + c.getId(), students);
                }
                break;

            case ADMIN:
                req.setAttribute("userCount", store.getUserCount());
                req.setAttribute("courseCount", store.getCourseCount());
                req.setAttribute("enrollmentCount", store.getEnrollmentCount());
                req.setAttribute("activeSessions", activeSessions);
                break;
        }

        req.getRequestDispatcher("/WEB-INF/views/dashboard.jsp").forward(req, resp);
    }
}