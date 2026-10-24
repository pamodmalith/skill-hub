package com.skillhub.controller;

import com.skillhub.data.DataStore;
import com.skillhub.model.Course;
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

@WebServlet({"/courses", "/admin/add-course"})
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
            List<User> trainers = store.getUsersByRole(com.skillhub.model.Role.TRAINER);
            req.setAttribute("trainers", trainers);
            req.getRequestDispatcher("/WEB-INF/views/add-course.jsp").forward(req, resp);
        } else {
            // /courses - all logged-in users
            List<Course> courses = new ArrayList<>(store.getAllCourses());
            Map<Integer, User> trainerMap = new HashMap<>();
            for (Course c : courses) {
                User trainer = store.getUser(c.getTrainerUsername());
                if (trainer != null) {
                    trainerMap.put(c.getId(), trainer);
                }
            }
            req.setAttribute("courses", courses);
            req.setAttribute("trainerMap", trainerMap);
            req.setAttribute("userRole", user.getRole());
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
            String trainerUsername = req.getParameter("trainerUsername");

            if (title == null || title.trim().isEmpty()
                    || category == null || category.trim().isEmpty()
                    || trainerUsername == null || trainerUsername.trim().isEmpty()) {
                req.setAttribute("error", "All fields are required.");
                DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
                List<User> trainers = store.getUsersByRole(com.skillhub.model.Role.TRAINER);
                req.setAttribute("trainers", trainers);
                req.getRequestDispatcher("/WEB-INF/views/add-course.jsp").forward(req, resp);
                return;
            }

            DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
            store.addCourse(title.trim(), category.trim(), trainerUsername.trim());

            resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath() + "/courses?msg=added"));
        }
    }
}