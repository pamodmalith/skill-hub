package com.skillhub.model;

import java.time.LocalDate;

public class AttendanceRecord {
    private final int courseId;
    private final String studentUsername;
    private final LocalDate date;
    private final AttendanceStatus status;

    public AttendanceRecord(int courseId, String studentUsername, LocalDate date, AttendanceStatus status) {
        this.courseId = courseId;
        this.studentUsername = studentUsername;
        this.date = date;
        this.status = status;
    }

    public int getCourseId() {
        return courseId;
    }

    public String getStudentUsername() {
        return studentUsername;
    }

    public LocalDate getDate() {
        return date;
    }

    public AttendanceStatus getStatus() {
        return status;
    }
}