package com.skillhub.model;

import java.io.Serializable;
import java.time.LocalDateTime;

public class Enrollment implements Serializable {
    private static final long serialVersionUID = 1L;

    private final String studentUsername;
    private final int courseId;
    private final LocalDateTime enrolledAt;

    public Enrollment(String studentUsername, int courseId) {
        this.studentUsername = studentUsername;
        this.courseId = courseId;
        this.enrolledAt = LocalDateTime.now();
    }

    public String getStudentUsername() {
        return studentUsername;
    }

    public int getCourseId() {
        return courseId;
    }

    public LocalDateTime getEnrolledAt() {
        return enrolledAt;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Enrollment that = (Enrollment) o;
        return courseId == that.courseId && studentUsername.equals(that.studentUsername);
    }

    @Override
    public int hashCode() {
        return studentUsername.hashCode() * 31 + courseId;
    }

    @Override
    public String toString() {
        return "Enrollment{" +
                "studentUsername='" + studentUsername + '\'' +
                ", courseId=" + courseId +
                ", enrolledAt=" + enrolledAt +
                '}';
    }
}