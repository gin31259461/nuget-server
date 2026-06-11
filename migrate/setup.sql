CREATE USER bagetter WITH PASSWORD 'bagetter-test';
CREATE DATABASE nuget OWNER bagetter;
GRANT ALL PRIVILEGES ON DATABASE nuget TO bagetter;
