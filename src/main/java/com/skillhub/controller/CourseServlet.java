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
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

@WebServlet(urlPatterns = {"/courses", "/admin/add-course"})
public class CourseServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();
        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
        HttpSession session = req.getSession(false);
        User user = (User) session.getAttribute("loggedUser");

        if ("/admin/add-course".equals(path)) {
            // Admin only - checked by filter
            List<User> trainers = store.getUsersByRole(Role.TRAINER);
            req.setAttribute("trainers", trainers);
            req.getRequestDispatcher("/WEB-INF/views/add-course.jsp").forward(req, resp);
        } else {
            // /courses - all logged-in users
            List<Course> courses = store.getAllCourses();
            Map<Integer, User> trainerNames = new HashMap<>();
            for (Course c : courses) {
                User trainer = store.getUser(c.getTrainerUsername());
                if (trainer != null) {
                    trainerNames.put(c.getId(), trainer);
                }
            }

            Set<Integer> enrolledIds = new HashSet<>();
            if (user.getRole() == Role.STUDENT) {
                for (Course c : store.getCoursesOfStudent(user.getUsername())) {
                    enrolledIds.add(c.getId());
                }
            }

            req.setAttribute("courses", courses);
            req.setAttribute("trainerNames", trainerNames);
            req.setAttribute("enrolledIds", enrolledIds);
            req.getRequestDispatcher("/WEB-INF/views/courses.jsp").forward(req, resp);
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String path = req.getServletPath();

        if ("/admin/add-course".equals(path)) {
            String title = req.getParameter("title");
            String category = req.getParameter("category");
            String description = req.getParameter("description");
            String trainerUsername = req.getParameter("trainerUsername");

            title = title == null ? "" : title.trim();
            category = category == null ? "" : category.trim();
            description = description == null ? "" : description.trim();
            trainerUsername = trainerUsername == null ? "" : trainerUsername.trim();

            if (title.isEmpty() || category.isEmpty() || description.isEmpty()) {
                req.setAttribute("error", "All fields are required.");
                req.setAttribute("formTitle", title);
                req.setAttribute("formCategory", category);
                req.setAttribute("formDescription", description);
                req.setAttribute("formTrainer", trainerUsername);

                DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
                List<User> trainers = store.getUsersByRole(com.skillhub.model.Role.TRAINER);
                req.setAttribute("trainers", trainers);
                req.getRequestDispatcher("/WEB-INF/views/add-course.jsp").forward(req, resp);
                return;
            }

            DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
            User trainer = store.getUser(trainerUsername);
            if (trainer == null || trainer.getRole() != Role.TRAINER) {
                req.setAttribute("error", "Please choose a valid trainer.");
                req.setAttribute("formTitle", title);
                req.setAttribute("formCategory", category);
                req.setAttribute("formDescription", description);
                req.setAttribute("formTrainer", trainerUsername);

                List<User> trainers = store.getUsersByRole(Role.TRAINER);
                req.setAttribute("trainers", trainers);
                req.getRequestDispatcher("/WEB-INF/views/add-course.jsp").forward(req, resp);
                return;
            }

            store.addCourse(title, category, description, trainerUsername);
            resp.sendRedirect(req.getContextPath() + "/courses?msg=courseAdded");
        } else {
            // POST to /courses is not allowed
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }
}