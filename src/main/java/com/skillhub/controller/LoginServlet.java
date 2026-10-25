package com.skillhub.controller;

import com.skillhub.data.DataStore;
import com.skillhub.model.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session != null && session.getAttribute("loggedUser") != null) {
            resp.sendRedirect(req.getContextPath() + "/dashboard");
            return;
        }

        String savedUsername = "";
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUser".equals(cookie.getName())) {
                    savedUsername = cookie.getValue();
                    break;
                }
            }
        }
        req.setAttribute("savedUsername", savedUsername);

        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        if (username == null || username.trim().isEmpty()
                || password == null || password.trim().isEmpty()) {
            req.setAttribute("error", "Username and password are required.");
            req.setAttribute("savedUsername", username == null ? "" : username);
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
        User user = store.authenticate(username, password);

        if (user == null) {
            req.setAttribute("error", "Invalid username or password.");
            req.setAttribute("savedUsername", username);
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("loggedUser", user);

        Cookie c = new Cookie("rememberedUser", user.getUsername());
        c.setPath(req.getContextPath());
        c.setHttpOnly(true);
        c.setMaxAge(remember != null ? 7 * 24 * 60 * 60 : 0);
        resp.addCookie(c);

        resp.sendRedirect(req.getContextPath() + "/dashboard");
    }
}