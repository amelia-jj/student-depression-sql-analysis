select * from student_depression.student_survey limit 10;

-- What percentage of students suffer from depression?
select count(*) as number_of_students, sum(depression = 'Yes') as depression_total, round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey;

-- What percentage of students suffer from depression among males and females?
select gender, count(*) as number_of_students, sum(depression = 'Yes') as depression_total, round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by gender;

-- Which age group appears to be most affected by depression among the students who participated in the survey?
select
    case
        when age < 20 and gender = 'Female' then 'Female Teenager (17 - 19)'
        when age < 20 and gender = 'Male' then 'Male Teenager (17 - 19)'
        when age < 23 and gender = 'Female' then 'Female Early Twenties (20 - 22)'
        when age < 23 and gender = 'Male' then 'Male Early Twenties (20 - 22)'
        when age < 26 and gender = 'Female' then 'Female Young Adult (23 - 25)'
        when age < 26 and gender = 'Male' then 'Male Young Adult (23 - 25)'
        when age >= 26 and gender = 'Female' then 'Female Adult (26+)'
        else 'Male Adult (26+)'
    end as student_age,
    count(*) as number_of_students,
    sum(depression = 'Yes') as depression_total,
    round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by student_age
order by depression_pct desc;

-- Is there any connection to the student's family background?
select family_background,
count(*) as number_of_students, sum(depression = 'Yes') as depression_total,
round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by family_background
order by family_background;

-- How do health status, having a circle of friends, and living alone or with family differ in terms of the rate of depression?
select living_style, health_condition, friend_circle, count(*) as number_of_students,
sum(depression = 'Yes') as depression_total, round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by living_style, health_condition, friend_circle
order by depression_pct desc;

-- Did students in critical health condition only answer "yes" in the survey?
select distinct depression
from student_depression.student_survey
where health_condition = 'Critical';

-- How many students are in critical health condition?
select count(*) as health_in_critical_condition
from student_depression.student_survey
where health_condition = 'Critical';

-- How many students are in good health?
select count(*) as health_in_good_condition
from student_depression.student_survey
where health_condition = 'Good';

-- How do rates of depression related to marriage and relationships differ among women?
select marital_status, relationship_status, count(*) as number_of_female_students,
sum(depression = 'Yes') as depression_total, round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
where gender = 'Female'
group by marital_status, relationship_status
order by marital_status;

-- How do rates of depression related to marriage and relationships differ among men?
select marital_status, relationship_status, count(*) as number_of_male_students,
sum(depression = 'Yes') as depression_total, round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
where gender = 'Male'
group by marital_status, relationship_status
order by marital_status;

-- How many male students are in a relationship?
select count(*) from student_depression.student_survey
where gender = 'Male' and relationship_status = 'In a Relationship';

-- Did all male students in relationships answer 'No' to depression?
select distinct(depression) from student_depression.student_survey
where gender = 'Male' and relationship_status = 'In a Relationship';

-- Does the depression rate differ between semesters?
select current_semester, count(*) as number_of_students, sum(depression = 'Yes') as depression_total,
round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by current_semester
having count(*) > 100
order by depression_pct desc;

-- What is the average CGPA among all students who participated in the survey?
select round(avg(cgpa), 2) as average_cgpa
from student_depression.student_survey;

-- Does the depression rate vary depending on students' CGPA?
select
    case
        when cgpa >= (select avg(cgpa) from student_depression.student_survey) then 'Above Average'
        else 'Below Average'
    end as cgpa_group,
    gender, count(*) as number_of_students, sum(depression = 'Yes') as depression_total, 
    round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by cgpa_group, gender;

-- What are the minimum and maximum costs that students pay in addition to official tuition fees? What is the average?
select min(cost_without_study) as min_cost,
    round(avg(cost_without_study), 2) as avg_cost,
    max(cost_without_study) as max_cost
from student_depression.student_survey;

-- Do higher or lower costs of living make a difference in the level of depression among students?
select
    case
        when cost_without_study <= 6000 then 'Very Low Cost'
        when cost_without_study <= 12000 then 'Low Cost'
        when cost_without_study <= 18000 then 'Middle Cost'
        when cost_without_study <= 24000 then 'High Cost'
        else 'Very High Cost'
    end as cost,
    count(*) as number_of_students, sum(depression = 'Yes') as depressed_students,
    round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by cost
order by field(cost, 'Very Low Cost', 'Low Cost', 'Middle Cost', 'High Cost', 'Very High Cost');

-- Does the district from which the respondent is from differ in terms of the rate of depression?
select home_division, count(*) as number_of_students,
sum(depression = 'Yes') as depression_total,
round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by home_division
order by depression_pct desc;

-- Does the depression rate differ by cost band and CGPA group?
select
    case
        when cost_without_study <= 12000 then 'Low Cost'
        when cost_without_study <= 24000 then 'Middle Cost'
        else 'High Cost'
        end as cost,
    case
        when cgpa >= (select avg(cgpa) from student_depression.student_survey) then 'Above Average'
        else 'Below Average'
    end as cgpa_group,
    count(*) as number_of_students, sum(depression = 'Yes') as depression_total,
    round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by cgpa_group, cost
order by field(cost, 'Low Cost', 'Middle Cost', 'High Cost');