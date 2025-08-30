-- Create Database
CREATE DATABASE microsoft_productivity;
USE microsoft_productivity;

-- Employees Table
CREATE TABLE employees (
    emp_id INT PRIMARY KEY,
    name VARCHAR(100),
    department VARCHAR(50),
    role VARCHAR(50),
    location VARCHAR(50)
);



-- Meetings Table
CREATE TABLE meetings (
    meeting_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    date DATE,
    duration_hours DECIMAL(4,2),
    attendees INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);



-- Emails Table
CREATE TABLE emails (
    email_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    emails_sent INT,
    emails_received INT,
    attachments INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);


-- Documents Table
CREATE TABLE documents (
    doc_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    docs_created INT,
    docs_edited INT,
    docs_shared INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);


-- Teams Usage Table
CREATE TABLE teams_usage (
    usage_id INT AUTO_INCREMENT PRIMARY KEY,
    emp_id INT,
    chats_sent INT,
    calls_made INT,
    screenshare_time_min INT,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id)
);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/meetings.csv'
INTO TABLE meetings
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(emp_id, date, duration_hours, attendees);



LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/emails.csv'
INTO TABLE emails
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(emp_id, emails_sent, emails_received, attachments);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/documents.csv'
INTO TABLE documents
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(emp_id, docs_created, docs_edited, docs_shared);

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 9.3/Uploads/teams_usage.csv'
INTO TABLE teams_usage
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS
(emp_id, chats_sent, calls_made, screenshare_time_min);

-- Queries 
-- Top 10 Busiest Employees (by Meeting Hours)
SELECT 
    e.emp_id AS busiest_employee,
    e.name,
    SUM(m.duration_hours) AS total_meeting_hours
FROM employees e
JOIN meetings m ON m.emp_id = e.emp_id
GROUP BY e.emp_id, e.name
ORDER BY total_meeting_hours DESC
LIMIT 10;

-- Email Activity per Department

Select e.department as departments,
sum( emails_sent) as email_Sent,
sum(emails_received) as email_Received,
(sum(em.emails_sent + em.emails_received)) as total_email_activity
from emails em 
join employees e on em.emp_id = e.emp_id
Group by e.department
order by total_email_activity DESC;


-- Document Collaboration Score
Select e.department as department,
sum(d.docs_created) as Docs_Created,
sum(d.docs_edited) as Docs_Edited,
sum(d.docs_shared) as Docs_Shared,
(sum(d.docs_created + d.docs_edited + d.docs_shared)) as Docs_Collaboration
from Documents d
join employees e on d.emp_id = e.emp_id
Group by department
order by Docs_Collaboration DESC; 

-- Monthly Meeting Trends
-- Monthly Meeting Trends
SELECT 
    DATE_FORMAT(m.date, '%Y-%m') AS month_trend,
    e.department AS department,
    SUM(m.duration_hours) AS total_meeting_duration
FROM meetings m 
JOIN employees e ON m.emp_id = e.emp_id
GROUP BY month_trend, e.department
ORDER BY month_trend DESC;


-- 7. Location-wise Productivity

SELECT e.location,
       COUNT(DISTINCT e.emp_id) AS total_employees,
       SUM(em.emails_sent) AS total_emails_sent,
       SUM(d.docs_shared) AS total_docs_shared,
       SUM(t.chats_sent) AS total_chats
FROM employees e
LEFT JOIN emails em ON e.emp_id = em.emp_id
LEFT JOIN documents d ON e.emp_id = d.emp_id
LEFT JOIN teams_usage t ON e.emp_id = t.emp_id
GROUP BY e.location
ORDER BY total_emails_sent DESC;


-- Overall Productivity Score (Employee Level)
SELECT e.emp_id, e.name, e.department,
       ROUND(
         (IFNULL(SUM(m.duration_hours),0) * 0.4) +
         (IFNULL(SUM(em.emails_sent),0) * 0.2) +
         (IFNULL(SUM(d.docs_shared),0) * 0.2) +
         (IFNULL(SUM(t.chats_sent),0) * 0.2), 2
       ) AS productivity_score
FROM employees e
LEFT JOIN meetings m ON e.emp_id = m.emp_id
LEFT JOIN emails em ON e.emp_id = em.emp_id
LEFT JOIN documents d ON e.emp_id = d.emp_id
LEFT JOIN teams_usage t ON e.emp_id = t.emp_id
GROUP BY e.emp_id, e.name, e.department
ORDER BY productivity_score DESC
LIMIT 10;
