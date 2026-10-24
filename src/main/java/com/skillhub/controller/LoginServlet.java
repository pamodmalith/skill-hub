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

        // Check for remember username cookie
        String rememberedUser = "";
        Cookie[] cookies = req.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberedUser".equals(cookie.getName())) {
                    rememberedUser = cookie.getValue();
                    break;
                }
            }
        }
        req.setAttribute("rememberedUser", rememberedUser);

        req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String username = req.getParameter("username");
        String password = req.getParameter("password");
        String remember = req.getParameter("remember");

        DataStore store = (DataStore) getServletContext().getAttribute("dataStore");
        if (store == null) {
            req.setAttribute("error", "System not ready. Please try again in a moment.");
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }
        User user = store.authenticate(username, password);

        if (user == null) {
            req.setAttribute("error", "Invalid username or password.");
            req.setAttribute("rememberedUser", username);
            req.getRequestDispatcher("/WEB-INF/views/login.jsp").forward(req, resp);
            return;
        }

        HttpSession session = req.getSession(true);
        session.setAttribute("loggedUser", user);

        // Remember-username cookie
        Cookie c = new Cookie("rememberedUser", user.getUsername());
        c.setPath(req.getContextPath());
        c.setHttpOnly(true);
        c.setMaxAge(remember != null ? 7 * 24 * 60 * 60 : 0);
        resp.addCookie(c);

        resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath() + "/dashboard"));
    }
}