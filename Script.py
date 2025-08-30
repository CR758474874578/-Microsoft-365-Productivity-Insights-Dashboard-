import pandas as pd
import numpy as np
from faker import Faker
import random
from datetime import timedelta, datetime

# Initialize Faker
fake = Faker()

# Parameters
n_employees = 100
n_days = 90   # last 3 months

# Departments and Roles
departments = ["Engineering", "Marketing", "Sales", "HR", "Finance", "IT Support"]
roles = ["Manager", "Senior Analyst", "Associate", "Intern", "Director"]
locations = ["USA", "India", "UK", "Germany", "Canada"]

# Generate Employees
employees = []
for i in range(1, n_employees+1):
    employees.append({
        "emp_id": i,
        "name": fake.name(),
        "department": random.choice(departments),
        "role": random.choice(roles),
        "location": random.choice(locations)
    })

df_employees = pd.DataFrame(employees)

# Generate Meetings Data
meetings = []
for emp in df_employees.emp_id:
    for _ in range(random.randint(20, 50)):  # meetings per employee
        meeting_date = fake.date_between(start_date=f'-{n_days}d', end_date='today')
        meetings.append({
            "emp_id": emp,
            "date": meeting_date,
            "duration_hours": round(random.uniform(0.5, 3), 2),
            "attendees": random.randint(2, 15)
        })

df_meetings = pd.DataFrame(meetings)

# Generate Emails Data
emails = []
for emp in df_employees.emp_id:
    emails.append({
        "emp_id": emp,
        "emails_sent": random.randint(50, 300),
        "emails_received": random.randint(80, 400),
        "attachments": random.randint(5, 50)
    })

df_emails = pd.DataFrame(emails)

# Generate Documents Data
documents = []
for emp in df_employees.emp_id:
    documents.append({
        "emp_id": emp,
        "docs_created": random.randint(5, 40),
        "docs_edited": random.randint(10, 100),
        "docs_shared": random.randint(5, 60)
    })

df_documents = pd.DataFrame(documents)

# Generate Teams Usage Data
teams = []
for emp in df_employees.emp_id:
    teams.append({
        "emp_id": emp,
        "chats_sent": random.randint(50, 300),
        "calls_made": random.randint(10, 100),
        "screenshare_time_min": random.randint(30, 500)
    })

df_teams = pd.DataFrame(teams)

# Export to CSV (for MySQL import)
df_employees.to_csv("employees.csv", index=False)
df_meetings.to_csv("meetings.csv", index=False)
df_emails.to_csv("emails.csv", index=False)
df_documents.to_csv("documents.csv", index=False)
df_teams.to_csv("teams_usage.csv", index=False)

print("✅ Data generated and saved as CSVs: employees, meetings, emails, documents, teams_usage")
