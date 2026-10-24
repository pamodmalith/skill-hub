package com.skillhub.listener;

import com.skillhub.data.DataStore;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;
import jakarta.servlet.annotation.WebListener;
import java.util.concurrent.atomic.AtomicInteger;

@WebListener
public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        // Create DataStore and load sample data
        DataStore store = new DataStore();
        store.loadSampleData();

        // Store in application scope
        sce.getServletContext().setAttribute("dataStore", store);

        // Initialize active sessions counter
        sce.getServletContext().setAttribute("activeSessions", new AtomicInteger(0));

        System.out.println("SkillHub Training Portal initialized with sample data.");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        System.out.println("SkillHub Training Portal shutting down.");
    }
}