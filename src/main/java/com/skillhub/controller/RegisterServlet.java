package com.skillhub.controller;

import com.skillhub.data.DataStore;
import com.skillhub.model.Role;
import com.skillhub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");

        // Validation
        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()
                || fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");

        if (store.usernameExists(username)) {
            req.setAttribute("error", "Username already exists.");
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        User user = new User(username.trim(), password, fullName.trim(), email.trim(), Role.STUDENT);
        store.addUser(user);

        resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath() + "/login?msg=registered"));
    }
}