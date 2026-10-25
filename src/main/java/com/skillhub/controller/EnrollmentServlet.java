package com.skillhub.controller;

import com.skillhub.data.DataStore;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/enroll")
public class EnrollmentServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String courseIdParam = req.getParameter("courseId");
        if (courseIdParam == null || courseIdParam.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?msg=error");
            return;
        }

        int courseId;
        try {
            courseId = Integer.parseInt(courseIdParam);
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?msg=error");
            return;
        }

        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
        String username = ((com.skillhub.model.User) session.getAttribute("loggedUser")).getUsername();

        boolean success = store.enrollStudent(username, courseId);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/dashboard?msg=enrolled");
        } else {
            resp.sendRedirect(req.getContextPath() + "/dashboard?msg=duplicate");
        }
    }
}