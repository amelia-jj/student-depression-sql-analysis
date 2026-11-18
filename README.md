# Student Depression Survey: SQL Analysis

I analysed a survey dataset of 4,464 students (13 columns: gender, age, family background, relationship and marital status, living style, semester, CGPA, friend circle, health condition, living costs, home division, and a Yes/No depression answer) using MySQL (queried in PopSQL).

The goal was to see whether some circumstances are associated with higher depression rates than others.

Files: create_table.sql, load_data.sql, analysis.sql (all questions and queries below). Dataset: https://www.kaggle.com/datasets/mkhoirulmustaqim/student-depression-detection-dataset?resource=download&select=Student+Depression+Detection+Dataset


**Key findings**

• 1,202 of 4,464 students (26.9%) answered "Yes" to depression.

• Gender makes almost no difference: 27.3% of men and 26.6% of women.

• Students with a below-average CGPA answered "Yes" more often than those above average, for both genders (women 31% vs 23%, men 31% vs 25%) and in every cost-of-living group. This is the most consistent pattern in the data.

• Family background shows a gradient: rich 18%, middle class about 28%, lower class 31%.

• Health condition separates the answers perfectly at the extremes (0% for good health, 100% for critical health). See the limitations below.

• Living costs and semester show no clear trend. By home division, Dhaka has the lowest rate (22%) and Rangpur, Rajshahi and Khulna the highest (31-32%).


**About the data**

The answers are self-reported Yes/No responses, not clinical measurements, and the results are associations, not causes.

All home divisions are in Bangladesh, so the data covers students from one country only.

Several results are perfectly clean: all 1,162 students in good health answered "No", all 634 in critical health answered "Yes", and men in a relationship answered "No" every time. Real survey data rarely looks like this, so the dataset may be simulated or the answers may be derived from other columns. I treat the results with caution and do not generalise from them.

Some groups are small (for example 78 men and 87 women aged 17-19), so their percentages can swing a lot.


**Results by question**
```sql
select gender, count(*) as number_of_students, sum(depression = 'Yes') as depression_total, round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by gender;
```
Of the 4,464 students, 1,202 (almost 27%) answered "Yes". There are 2,002 men and 2,462 women, with depression rates of 27.3% and 26.6%.
 
**Age**

The largest groups are men aged 20-22 (1,054 students, 28.8%) and women aged 23-25 (1,407 students, 25.9%). The highest rate (31%) is among women aged 17-19, but that group has only 87 students. The second highest is men over 26 (163 students, 30.1%). The lowest rates are among men aged 23-25 (707 students, 25%) and men aged 17-19 (78 students, 20.5%).

**Family background**

Most students (2,642) come from middle-class families, and 731 of them (almost 28%) answered "Yes". Students from rich families have a lower rate: 18% of 671. The highest rate is among lower-class families: 31% of 1,151.

**Health condition, friend circle and living style**
```sql
select living_style, health_condition, friend_circle, count(*) as number_of_students,
sum(depression = 'Yes') as depression_total, round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by living_style, health_condition, friend_circle
order by depression_pct desc;
```
• Good health: all 1,162 students answered "No", regardless of living style or friend circle.

• Critical health: all 634 students answered "Yes". I checked the distinct answers of this group to confirm it.

• Normal health: the rate is close to 0% for students with a friend circle (0.7% of 591 living with family, about 0.4% of 731 living alone or with peers, which is only 3 students). It is higher for students without a friend circle: 18.4% of 250 living with family and 14% of 215 living alone or with peers.

• Abnormal health: there is no consistent friend-circle effect. Among students living alone, those with a friend circle have the higher rate (62% of 376 vs 46.3% of 134). Among students living with family, those without a friend circle have the higher rate (60% of 137 vs 46% of 234). The direction is opposite, so I would not draw a conclusion from it.

**Marital and relationship status**

• Women: the largest group is unmarried, single women (1,081), with a depression rate of 41%. Next are unmarried women in a relationship (693, 17.5%) and married women in a relationship (457, 8%).

• Men: the largest group is unmarried, single men (1,481), with a rate of 34%. Married but single men have 23% (123 students). Men in a relationship, whatever their marital status, answered "No" every time (273 students).

**Semester**

Excluding semesters with 100 students or fewer, no clear pattern appears. The highest rate (31%) is in the 9th semester (286 students) and the 2nd semester (543 students). Rates are about 27% in the 3rd, 5th, 6th and 8th semesters, then fall to 25%, 23%, 21% and finally 19% in the 11th semester (119 students).

**CGPA**
```sql
select
    case
        when cgpa >= (select avg(cgpa) from student_depression.student_survey) then 'Above Average'
        else 'Below Average'
    end as cgpa_group,
    gender, count(*) as number_of_students, sum(depression = 'Yes') as depression_total, 
    round(avg(depression = 'Yes') * 100, 1) as depression_pct
from student_depression.student_survey
group by cgpa_group, gender;
```
The average CGPA is 3.41.

• Women: 23% of 1,401 students above average vs 31% of 1,061 below average.

• Men: 25% of 1,140 students above average vs 31% of 862 below average.

The gap is 6-8 percentage points, and it appears in both genders.

**Living costs**

Costs range from 0 to 32,000, with an average of 11,242.98. I grouped them into five bands. The highest rate (33%) is in the middle band (935 students). The other bands are close to each other: high 25% (471 students), very high 24% (279), low 27% (1,695) and very low 23% (1,084). There is no clear trend with cost.

**Home division**

The highest rates are in Rangpur, Rajshahi and Khulna (31-32%, from 360-550 students each) and the lowest in Dhaka (22% of 1,527 students).

**Cost and CGPA together**

Using three cost bands, the CGPA pattern holds in every group: students below average CGPA answered "Yes" more often. The gap is about 10 percentage points in the low and high cost groups and only 4 points in the middle group.


Note on AI assistance: I wrote the analysis queries and the findings myself. I used Claude AI to help set up the table and load the CSV into MySQL, to get hints when I was stuck on SQL syntax, and to proofread this README.
