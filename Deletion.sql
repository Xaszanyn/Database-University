SET FOREIGN_KEY_CHECKS = 0;
SET SQL_SAFE_UPDATES = 0;

-- Deleting student by its ID
DELETE FROM student
WHERE SId = 13;

-- Deleting faculty member in all tables
DELETE FROM faculty_member WHERE FId = 1;
DELETE FROM instructor WHERE InsId = 1;
DELETE FROM res_assistant WHERE ResAsId = 1;
DELETE FROM prof WHERE PId = 1;
DELETE FROM associate_prof WHERE AssocPId = 1;
DELETE FROM assistant_prof WHERE AssistPId = 1;

-- Deleting courses with less than 4 credits
DELETE FROM course
WHERE Credits < 4;


SET SQL_SAFE_UPDATES = 1;
SET FOREIGN_KEY_CHECKS = 1;