package com.skillhub.data;

import com.skillhub.model.Course;
import com.skillhub.model.Enrollment;
import com.skillhub.model.Role;
import com.skillhub.model.User;

import java.util.*;
import java.util.concurrent.ConcurrentHashMap;

public class DataStore {
    private final Map<String, User> users = new ConcurrentHashMap<>();
    private final Map<Integer, Course> courses = new ConcurrentHashMap<>();
    private final List<Enrollment> enrollments = new ArrayList<>();
    private int nextCourseId = 1;

    public DataStore() {
        // Sample data will be loaded by AppContextListener
    }

    // User methods
    public synchronized User authenticate(String username, String password) {
        User user = users.get(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    public synchronized boolean usernameExists(String username) {
        return users.containsKey(username);
    }

    public synchronized void addUser(User user) {
        users.put(user.getUsername(), user);
    }

    public User getUser(String username) {
        return users.get(username);
    }

    public Collection<User> getAllUsers() {
        return Collections.unmodifiableCollection(users.values());
    }

    public List<User> getUsersByRole(Role role) {
        List<User> result = new ArrayList<>();
        for (User user : users.values()) {
            if (user.getRole() == role) {
                result.add(user);
            }
        }
        return Collections.unmodifiableList(result);
    }

    public int getUserCount() {
        return users.size();
    }

    // Course methods
    public synchronized int addCourse(String title, String category, String trainerUsername) {
        int id = nextCourseId++;
        Course course = new Course(id, title, category, trainerUsername);
        courses.put(id, course);
        return id;
    }

    public Course getCourse(int id) {
        return courses.get(id);
    }

    public Collection<Course> getAllCourses() {
        return Collections.unmodifiableCollection(courses.values());
    }

    public List<Course> getCoursesByTrainer(String trainerUsername) {
        List<Course> result = new ArrayList<>();
        for (Course course : courses.values()) {
            if (course.getTrainerUsername().equals(trainerUsername)) {
                result.add(course);
            }
        }
        return Collections.unmodifiableList(result);
    }

    public int getCourseCount() {
        return courses.size();
    }

    // Enrollment methods
    public synchronized boolean enrollStudent(String studentUsername, int courseId) {
        Course course = courses.get(courseId);
        if (course == null) {
            return false;
        }

        // Check if already enrolled
        for (Enrollment e : enrollments) {
            if (e.getStudentUsername().equals(studentUsername) && e.getCourseId() == courseId) {
                return false; // Already enrolled
            }
        }

        enrollments.add(new Enrollment(studentUsername, courseId));
        return true;
    }

    public List<Enrollment> getEnrollmentsByStudent(String studentUsername) {
        List<Enrollment> result = new ArrayList<>();
        for (Enrollment e : enrollments) {
            if (e.getStudentUsername().equals(studentUsername)) {
                result.add(e);
            }
        }
        return Collections.unmodifiableList(result);
    }

    public List<Enrollment> getEnrollmentsByCourse(int courseId) {
        List<Enrollment> result = new ArrayList<>();
        for (Enrollment e : enrollments) {
            if (e.getCourseId() == courseId) {
                result.add(e);
            }
        }
        return Collections.unmodifiableList(result);
    }

    public int getEnrollmentCount() {
        return enrollments.size();
    }

    // Initialize sample data
    public void loadSampleData() {
        // Admin
        addUser(new User("admin", "admin123", "System Administrator", "admin@skillhub.com", Role.ADMIN));

        // Trainers
        addUser(new User("trainer1", "trainer123", "Kamal Silva", "trainer1@skillhub.com", Role.TRAINER));
        addUser(new User("trainer2", "trainer123", "Nimali Fernando", "trainer2@skillhub.com", Role.TRAINER));

        // Student
        addUser(new User("student1", "student123", "Saman Kumara", "student1@skillhub.com", Role.STUDENT));

        // Courses
        addCourse("Java Web Development", "Technology", "trainer1");
        addCourse("Python Fundamentals", "Technology", "trainer2");
        addCourse("Business Communication", "Professional Development", "trainer2");
        addCourse("Project Management Essentials", "Business", "trainer1");
    }
}