package com.skillhub.filter;

import com.skillhub.model.Role;
import com.skillhub.model.User;

import jakarta.servlet.*;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String path = req.getRequestURI().substring(req.getContextPath().length());

        // Public paths that don't require authentication
        if (isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check session
        HttpSession session = req.getSession(false);
        if (session == null || session.getAttribute("loggedUser") == null) {
            // Not logged in - redirect to login
            resp.sendRedirect(resp.encodeRedirectURL(req.getContextPath() + "/login"));
            return;
        }

        User user = (User) session.getAttribute("loggedUser");

        // Role-based authorization
        if (path.startsWith("/admin/") && user.getRole() != Role.ADMIN) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        if ("/enroll".equals(path) && user.getRole() != Role.STUDENT) {
            resp.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }

        // Authorized - continue
        chain.doFilter(request, response);
    }

    private boolean isPublicPath(String path) {
        return path.equals("/")
                || path.equals("/index.jsp")
                || path.equals("/login")
                || path.equals("/register")
                || path.startsWith("/css/")
                || path.equals("/favicon.ico");
    }
}