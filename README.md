# SSIS Project

## Overview
Thank you for taking the time to review this project. This is a small, yet interesting, project designed to test my skills in SSIS (SQL Server Integration Services). The purpose of this project is to read data from a CSV file, clean and isolate its records, and then import the data into staging before finally moving it to the production table.

## Key Points
- You need a local database with the name "KoreAssignment_Arshia_Alidousti."
- Reads data from a CSV file named "Data_Source.csv" located on your desktop.
- I save error logs on desktop under the file name "Arshia_Alidousti_SSIS_ErrorLog.txt."
- I added all Execute SQL Task queries in one file for you to check.
- I added the result of my database backup file as a zip file, under the name "KoreAssignment_Arshia_Alidousti_bak.zip."
- In production, I prefer not to create tables in the project and use a restricted connection to the database. I also ensure that the connection string is protected and not exposed in the Git repository. However, for this project, I skipped these steps to reduce complexity.
- I'm handling errors with an event handler. I added a C# file to the main directory for you to check the script.
- Please feel free to ask questions and add more tasks to the project.
