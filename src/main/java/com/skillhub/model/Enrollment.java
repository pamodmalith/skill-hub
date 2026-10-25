package com.skillhub.model;

import java.time.LocalDate;

public class Enrollment {
    private final String studentUsername;
    private final int courseId;
    private final LocalDate enrolledOn;

    public Enrollment(String studentUsername, int courseId, LocalDate enrolledOn) {
        this.studentUsername = studentUsername;
        this.courseId = courseId;
        this.enrolledOn = enrolledOn;
    }

    public String getStudentUsername() {
        return studentUsername;
    }

    public int getCourseId() {
        return courseId;
    }

    public LocalDate getEnrolledOn() {
        return enrolledOn;
    }
}