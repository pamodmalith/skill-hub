package com.skillhub.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class ProfileServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        HttpSession session = req.getSession(false);
        if (session == null) {
            resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath() + "/login"));
            return;
        }

        String academyName = getServletContext().getInitParameter("academyName");
        req.setAttribute("academyName", academyName);

        req.getRequestDispatcher("/WEB-INF/views/profile.jsp").forward(req, resp);
    }
}