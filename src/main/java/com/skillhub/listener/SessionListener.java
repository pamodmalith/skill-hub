package com.skillhub.listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;
import jakarta.servlet.annotation.WebListener;

import java.util.concurrent.atomic.AtomicInteger;

@WebListener
public class SessionListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        AtomicInteger counter = (AtomicInteger) context.getAttribute("activeSessions");
        if (counter != null) {
            counter.incrementAndGet();
            System.out.println("Session created");
            System.out.println("Active sessions: " + counter.get());
        }
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        AtomicInteger counter = (AtomicInteger) context.getAttribute("activeSessions");
        if (counter != null) {
            counter.decrementAndGet();
            System.out.println("Session destroyed");
            System.out.println("Active sessions: " + counter.get());
        }
    }
}