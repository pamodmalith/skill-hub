package com.skillhub.listener;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpSessionEvent;
import jakarta.servlet.http.HttpSessionListener;

import java.util.concurrent.atomic.AtomicInteger;

public class SessionListener implements HttpSessionListener {

    @Override
    public void sessionCreated(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        AtomicInteger counter = (AtomicInteger) context.getAttribute("activeSessions");
        if (counter != null) {
            counter.incrementAndGet();
        }
    }

    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        ServletContext context = se.getSession().getServletContext();
        AtomicInteger counter = (AtomicInteger) context.getAttribute("activeSessions");
        if (counter != null) {
            int val = counter.decrementAndGet();
            if (val < 0) {
                counter.set(0);
            }
        }
    }
}