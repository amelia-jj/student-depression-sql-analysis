-- Create the database and table for the student depression survey (MySQL)

CREATE DATABASE student_depression;
USE student_depression;

CREATE TABLE student_survey (
    gender VARCHAR(10),
    age INT,
    family_background VARCHAR(30),
    relationship_status VARCHAR(30),
    marital_status VARCHAR(20),
    living_style VARCHAR(40),
    current_semester INT,
    cgpa DECIMAL(4,2),
    friend_circle VARCHAR(5),
    health_condition VARCHAR(20),
    cost_without_study INT,
    home_division VARCHAR(30),
    depression VARCHAR(5)
);
