-- Load the Kaggle CSV into the student_survey table (MySQL)
-- Start the MySQL client with local files enabled:
--   mysql --local-infile=1 -u root -p
-- Then allow local loading and select the database:
SET GLOBAL local_infile = 1;
USE student_depression;

-- Replace the path with the location of the downloaded CSV (use forward slashes)
LOAD DATA LOCAL INFILE 'path/to/Student_Depression_Dataset.csv'
INTO TABLE student_survey
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES
(gender, age, family_background, relationship_status, marital_status,
 living_style, current_semester, cgpa, friend_circle, health_condition,
 cost_without_study, home_division, @dep)
SET depression = TRIM(TRAILING '\r' FROM @dep);

-- Check: should return 4464 rows
SELECT COUNT(*) FROM student_survey;
