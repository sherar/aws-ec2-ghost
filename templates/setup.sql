

-- Setup a password for root user
ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY '${var.db_pass}';

-- Creates a MySQL user for ghostadmin and allow only ghost database access for security reasons.
CREATE USER ghost@localhost IDENTIFIED BY '${var.db_pass}';
CREATE DATABASE ghost; 
GRANT ALL ON ghost.* TO ghost@localhost;
