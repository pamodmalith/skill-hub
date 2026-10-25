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
import java.util.regex.Pattern;

@WebServlet("/register")
public class RegisterServlet extends HttpServlet {

    private static final Pattern USERNAME_PATTERN = Pattern.compile("[A-Za-z0-9_]{3,20}");

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

        // Trim all inputs
        username = username == null ? "" : username.trim();
        password = password == null ? "" : password.trim();
        confirmPassword = confirmPassword == null ? "" : confirmPassword.trim();
        fullName = fullName == null ? "" : fullName.trim();
        email = email == null ? "" : email.trim();

        // Validation
        if (username.isEmpty() || password.isEmpty() || fullName.isEmpty() || email.isEmpty()) {
            req.setAttribute("error", "All fields are required.");
            req.setAttribute("formUsername", username);
            req.setAttribute("formFullName", fullName);
            req.setAttribute("formEmail", email);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        if (!USERNAME_PATTERN.matcher(username).matches()) {
            req.setAttribute("error", "Username must be 3-20 letters, digits or underscores.");
            req.setAttribute("formUsername", username);
            req.setAttribute("formFullName", fullName);
            req.setAttribute("formEmail", email);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        if (password.length() < 4) {
            req.setAttribute("error", "Password must be at least 4 characters.");
            req.setAttribute("formUsername", username);
            req.setAttribute("formFullName", fullName);
            req.setAttribute("formEmail", email);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        if (!email.contains("@")) {
            req.setAttribute("error", "Enter a valid email address.");
            req.setAttribute("formUsername", username);
            req.setAttribute("formFullName", fullName);
            req.setAttribute("formEmail", email);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Passwords do not match.");
            req.setAttribute("formUsername", username);
            req.setAttribute("formFullName", fullName);
            req.setAttribute("formEmail", email);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");

        if (!store.addUser(new User(username, password, fullName, email, Role.STUDENT))) {
            req.setAttribute("error", "That username is already taken.");
            req.setAttribute("formUsername", username);
            req.setAttribute("formFullName", fullName);
            req.setAttribute("formEmail", email);
            req.getRequestDispatcher("/WEB-INF/views/register.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/login?registered=true");
    }
}