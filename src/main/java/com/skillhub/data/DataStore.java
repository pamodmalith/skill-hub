package com.skillhub.data;

import com.skillhub.model.AttendanceRecord;
import com.skillhub.model.AttendanceStatus;
import com.skillhub.model.Course;
import com.skillhub.model.Enrollment;
import com.skillhub.model.Role;
import com.skillhub.model.User;

import java.time.LocalDate;
import java.util.*;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.CopyOnWriteArrayList;
import java.util.concurrent.atomic.AtomicInteger;
import java.util.stream.Collectors;

public class DataStore {
    private final ConcurrentHashMap<String, User> users = new ConcurrentHashMap<>();
    private final ConcurrentHashMap<Integer, Course> courses = new ConcurrentHashMap<>();
    private final CopyOnWriteArrayList<Enrollment> enrollments = new CopyOnWriteArrayList<>();
    private final CopyOnWriteArrayList<AttendanceRecord> attendance = new CopyOnWriteArrayList<>();
    private final AtomicInteger courseIdCounter = new AtomicInteger(0);

    // User methods
    public boolean addUser(User u) {
        return users.putIfAbsent(u.getUsername(), u) == null;
    }

    public User authenticate(String username, String password) {
        if (username == null || password == null) {
            return null;
        }
        User user = users.get(username);
        if (user != null && user.getPassword().equals(password)) {
            return user;
        }
        return null;
    }

    public User getUser(String username) {
        if (username == null) {
            return null;
        }
        return users.get(username);
    }

    public List<User> getUsersByRole(Role r) {
        List<User> result = new ArrayList<>();
        for (User user : users.values()) {
            if (user.getRole() == r) {
                result.add(user);
            }
        }
        result.sort(Comparator.comparing(User::getFullName, String.CASE_INSENSITIVE_ORDER));
        return result;
    }

    // Course methods
    public Course addCourse(String title, String category, String description, String trainerUsername) {
        int id = courseIdCounter.incrementAndGet();
        Course course = new Course(id, title, category, description, trainerUsername);
        courses.put(id, course);
        return course;
    }

    public Course getCourse(int id) {
        return courses.get(id);
    }

    public List<Course> getAllCourses() {
        List<Course> result = new ArrayList<>(courses.values());
        result.sort(Comparator.comparingInt(Course::getId));
        return result;
    }

    public List<Course> getCoursesByTrainer(String username) {
        List<Course> result = new ArrayList<>();
        for (Course course : courses.values()) {
            if (course.getTrainerUsername().equals(username)) {
                result.add(course);
            }
        }
        result.sort(Comparator.comparingInt(Course::getId));
        return result;
    }

    // Enrollment methods
    public synchronized boolean enroll(String username, int courseId) {
        if (isEnrolled(username, courseId)) {
            return false;
        }
        enrollments.add(new Enrollment(username, courseId, LocalDate.now()));
        return true;
    }

    public boolean isEnrolled(String username, int courseId) {
        for (Enrollment e : enrollments) {
            if (e.getStudentUsername().equals(username) && e.getCourseId() == courseId) {
                return true;
            }
        }
        return false;
    }

    public List<Course> getCoursesOfStudent(String username) {
        List<Course> result = new ArrayList<>();
        for (Enrollment e : enrollments) {
            if (e.getStudentUsername().equals(username)) {
                Course c = courses.get(e.getCourseId());
                if (c != null) {
                    result.add(c);
                }
            }
        }
        result.sort(Comparator.comparingInt(Course::getId));
        return result;
    }

    public List<User> getStudentsInCourse(int courseId) {
        List<User> result = new ArrayList<>();
        for (Enrollment e : enrollments) {
            if (e.getCourseId() == courseId) {
                User u = users.get(e.getStudentUsername());
                if (u != null) {
                    result.add(u);
                }
            }
        }
        result.sort(Comparator.comparing(User::getFullName, String.CASE_INSENSITIVE_ORDER));
        return result;
    }

    public int countEnrollments() {
        return enrollments.size();
    }

    // Attendance methods
    public synchronized void saveAttendance(int courseId, LocalDate date, Map<String, AttendanceStatus> statuses) {
        // Remove existing records for this course and date
        attendance.removeIf(r -> r.getCourseId() == courseId && r.getDate().equals(date));
        // Add new records
        for (Map.Entry<String, AttendanceStatus> entry : statuses.entrySet()) {
            attendance.add(new AttendanceRecord(courseId, entry.getKey(), date, entry.getValue()));
        }
    }

    public Map<String, AttendanceStatus> getAttendance(int courseId, LocalDate date) {
        Map<String, AttendanceStatus> result = new HashMap<>();
        for (AttendanceRecord r : attendance) {
            if (r.getCourseId() == courseId && r.getDate().equals(date)) {
                result.put(r.getStudentUsername(), r.getStatus());
            }
        }
        return result;
    }

    public List<LocalDate> getSessionDates(int courseId) {
        Set<LocalDate> dates = new HashSet<>();
        for (AttendanceRecord r : attendance) {
            if (r.getCourseId() == courseId) {
                dates.add(r.getDate());
            }
        }
        List<LocalDate> result = new ArrayList<>(dates);
        result.sort(Comparator.reverseOrder()); // newest first
        return result;
    }

    public int[] getAttendanceSummary(String username, int courseId) {
        int present = 0;
        int total = 0;
        for (AttendanceRecord r : attendance) {
            if (r.getCourseId() == courseId && r.getStudentUsername().equals(username)) {
                total++;
                if (r.getStatus() == AttendanceStatus.PRESENT) {
                    present++;
                }
            }
        }
        return new int[]{present, total};
    }
}