package com.skillhub.model;

public class Course {
    private final int id;
    private final String title;
    private final String category;
    private final String description;
    private final String trainerUsername;

    public Course(int id, String title, String category, String description, String trainerUsername) {
        this.id = id;
        this.title = title;
        this.category = category;
        this.description = description;
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

    public String getDescription() {
        return description;
    }

    public String getTrainerUsername() {
        return trainerUsername;
    }
}