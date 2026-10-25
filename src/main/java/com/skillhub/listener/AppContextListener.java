package com.skillhub.listener;

import com.skillhub.data.DataStore;
import com.skillhub.model.AttendanceStatus;
import com.skillhub.model.Role;
import com.skillhub.model.User;

import jakarta.servlet.ServletContextEvent;
import jakarta.servlet.ServletContextListener;

import java.time.LocalDate;
import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.atomic.AtomicInteger;

public class AppContextListener implements ServletContextListener {

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        DataStore store = new DataStore();

        // Users
        store.addUser(new User("admin", "admin123", "System Administrator", "admin@skillhub.example", Role.ADMIN));
        store.addUser(new User("trainer1", "trainer123", "Kamal Silva", "kamal@skillhub.example", Role.TRAINER));
        store.addUser(new User("trainer2", "trainer123", "Nimali Fernando", "nimali@skillhub.example", Role.TRAINER));
        store.addUser(new User("student1", "student123", "Saman Kumara", "saman@skillhub.example", Role.STUDENT));
        store.addUser(new User("student2", "student123", "Dilani Jayawardena", "dilani@skillhub.example", Role.STUDENT));

        // Courses (in this order so ids are 1-4)
        store.addCourse("Java Web Development", "Technology",
                "Servlets, JSP and web containers using Jakarta EE.", "trainer1");
        store.addCourse("Python Fundamentals", "Technology",
                "Programming basics using Python.", "trainer2");
        store.addCourse("Business Communication", "Professional Development",
                "Professional writing and presentation skills.", "trainer2");
        store.addCourse("Project Management Essentials", "Business",
                "Planning, scheduling and managing projects.", "trainer1");

        // Enrolments
        store.enroll("student1", 1);
        store.enroll("student2", 1);

        // Attendance for course 1 (relative to LocalDate.now())
        LocalDate today = LocalDate.now();
        Map<String, AttendanceStatus> day1 = new ConcurrentHashMap<>();
        day1.put("student1", AttendanceStatus.PRESENT);
        day1.put("student2", AttendanceStatus.PRESENT);
        store.saveAttendance(1, today.minusDays(2), day1);

        Map<String, AttendanceStatus> day2 = new ConcurrentHashMap<>();
        day2.put("student1", AttendanceStatus.ABSENT);
        day2.put("student2", AttendanceStatus.PRESENT);
        store.saveAttendance(1, today.minusDays(1), day2);

        // Store in application scope
        sce.getServletContext().setAttribute("dataStore", store);
        sce.getServletContext().setAttribute("activeSessions", new AtomicInteger(0));

        sce.getServletContext().log("SkillHub started: sample data loaded");
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        sce.getServletContext().log("SkillHub stopped");
    }
}