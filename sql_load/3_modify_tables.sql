/* 
Database Load Issues (follow if receiving permission denied when running SQL code below)

NOTE: If you are having issues with permissions. And you get error: 

'could not open file "[your file path]\job_postings_fact.csv" for reading: Permission denied.'

1. Open pgAdmin
2. In Object Explorer (left-hand pane), navigate to `sql_course` database
3. Right-click `sql_course` and select `PSQL Tool`
    - This opens a terminal window to write the following code
4. Get the absolute file path of your csv files
    1. Find path by right-clicking a CSV file in VS Code and selecting “Copy Path”
5. Paste the following into `PSQL Tool`, (with the CORRECT file path)



*/



COPY album
FROM 'E:\Ambar\SQL\SQL_Project_Music_Data_Analysis\csv_files\album.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY artist
FROM 'E:\Ambar\SQL\SQL_Project_Music_Data_Analysis\csv_files\artist.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY customer
FROM 'E:\Ambar\SQL\SQL_Project_Music_Data_Analysis\csv_files\customer.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY employee
FROM 'E:\Ambar\SQL\SQL_Project_Music_Data_Analysis\csv_files\employee.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY genre
FROM 'E:\Ambar\SQL\SQL_Project_Music_Data_Analysis\csv_files\genre.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY invoice
FROM 'E:\Ambar\SQL\SQL_Project_Music_Data_Analysis\csv_files\invoice.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY invoice_line
FROM 'E:\Ambar\SQL\SQL_Project_Music_Data_Analysis\csv_files\invoice_line.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY media_type
FROM 'E:\Ambar\SQL\SQL_Project_Music_Data_Analysis\csv_files\media_type.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY playlist_track
FROM 'E:\Ambar\SQL\SQL_Project_Music_Data_Analysis\csv_files\playlist_track.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');

COPY track
FROM 'E:\Ambar\SQL\SQL_Project_Music_Data_Analysis\csv_files\track.csv'
WITH (FORMAT csv, HEADER true, DELIMITER ',', ENCODING 'UTF8');



