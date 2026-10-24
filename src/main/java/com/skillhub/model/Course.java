package com.skillhub.model;

import java.io.Serializable;

public class Course implements Serializable {
    private static final long serialVersionUID = 1L;

    private final int id;
    private final String title;
    private final String category;
    private final String trainerUsername;

    public Course(int id, String title, String category, String trainerUsername) {
        this.id = id;
        this.title = title;
        this.category = category;
        this.trainerUsername = trainerUsername;
    }

    public int getId() {
        return id;
    }

    public String getTitle() {
        return title;
    }

    public String getCategory() {
        return category;
    }

    public String getTrainerUsername() {
        return trainerUsername;
    }

    @Override
    public String toString() {
        return "Course{" +
                "id=" + id +
                ", title='" + title + '\'' +
                ", category='" + category + '\'' +
                ", trainerUsername='" + trainerUsername + '\'' +
                '}';
    }
}