-- 1. /* Show all of the patients grouped into weight groups.
Show the total amount of patients in each weight group.
Order the list by the weight group decending.

For example, if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.*/

select 
	count(*) as patients_in_group,
    floor(weight/10)*10 as weight_group
from patients
group by weight_group
order by weight_group desc;


-- 2. /*Show patient_id, weight, height, isObese from the patients table.

Display isObese as a boolean 0 or 1.

Obese is defined as weight(kg)/(height(m)2) >= 30.

weight is in units kg.

height is in units cm.*/

SELECT patient_id, 
	   weight, 
       height,
	   CASE
       		WHEN weight/POWER(height/100.0,2) >= 30 THEN '1'
        	ELSE '0'
       END AS isObese
FROM patients


-- 3. /*Show patient_id, first_name, last_name, and attending doctor's specialty.
Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'

Check patients, admissions, and doctors tables for required information.*/

SELECT patients.patient_id,	
	   patients.first_name,
       patients.last_name,
       doctors.specialty
FROM patients
JOIN admissions ON patients.patient_id = admissions.patient_id
JOIN doctors ON admissions.attending_doctor_id = doctors.doctor_id
WHERE admissions.diagnosis = 'Epilepsy' AND doctors.first_name = 'Lisa';


-- 4. /*All patients who have gone through admissions, can see their medical documents on our site. Those patients are given a temporary password after their first admission. Show the patient_id and temp_password.

The password must be the following, in order:
1. patient_id
2. the numerical length of patient's last_name
3. year of patient's birth_date*/

SELECT DISTINCT patients.patient_id, 
	   CONCAT(patients.patient_id, LEN(last_name), YEAR(birth_date))  AS temp_password
FROM patients
JOIN admissions ON patients.patient_id = admissions.patient_id;


-- 5. /*Each admission costs $50 for patients without insurance, and $10 for patients with insurance. All patients with an even patient_id have insurance.

Give each patient a 'Yes' if they have insurance, and a 'No' if they don't have insurance. Add up the admission_total cost for each has_insurance group.*/

SELECT 
	CASE 
    	WHEN patient_id % 2 = 0 THEN 'YES'
        ELSE 'NO'
    END as has_insurance,
    SUM
    (CASE
     	WHEN patient_id % 2 = 0 THEN 10
     ELSE 50
     END
    ) AS cost_after_insurance   
FROM admissions
GROUP BY has_insurance;


-- 6. Show the provinces that has more patients identified as 'M' than 'F'. Must only show full province_name

SELECT DISTINCT province_name 
FROM province_names
JOIN patients ON province_names.province_id = patients.province_id
GROUP BY province_name
HAVING 
	COUNT(CASE WHEN gender = 'M' THEN 1 END) > COUNT(CASE WHEN gender = 'F' THEN 1 END)
ORDER BY province_name; 


-- 7. /*We are looking for a specific patient. Pull all columns for the patient who matches the following criteria:
- First_name contains an 'r' after the first two letters.
- Identifies their gender as 'F'
- Born in February, May, or December
- Their weight would be between 60kg and 80kg
- Their patient_id is an odd number
- They are from the city 'Kingston'*/

SELECT *
FROM patients
WHERE first_name LIKE '__r%' AND
	gender = 'F' AND
    MONTH(birth_date) IN (02, 05, 12) AND
    weight BETWEEN 60 AND 80 and
    patient_id % 2 != 0 AND
    city = 'Kingston';


-- 8. Show the percent of patients that have 'M' as their gender. Round the answer to the nearest hundreth number and in percent form.

SELECT CONCAT(
	ROUND((SELECT COUNT(*) FROM patients WHERE gender = 'M') *100.0 / COUNT(*), 2),'%') as percent_of_male_patients
FROM patients


-- 9. Sort the province names in ascending order in such a way that the province 'Ontario' is always on top.

select province_name 
from province_names
order by province_name = 'Ontario' DESC, province_name;


-- 10. We need a breakdown for the total amount of admissions each doctor has started each year. Show the doctor_id, doctor_full_name, specialty, year, total_admissions for that year.

SELECT 
	octor_id,
    CONCAT(first_name, ' ', last_name) AS doctor_full_name,
    specialty,
    COUNT(*) AS total_admissions,
    YEAR(admission_date) AS Year
FROM admissions
RIGHT JOIN doctors ON admissions.attending_doctor_id = doctors.doctor_id
GROUP BY doctor_full_name, Year 
ORDER BY doctor_id, Year



