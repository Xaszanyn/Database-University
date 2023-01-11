SET SQL_SAFE_UPDATES = 0;

-- Updating faculty members information
UPDATE faculty_member
SET FPhone = "05537306080", FOffice = "Buca"
WHERE FId = 15;

-- Updating keyword for correction
UPDATE keywords
SET Keyword = "Front-end"
WHERE Keyword = "Frontend";

-- Changing dean
UPDATE college
SET DeanId = 3
WHERE CName = "Ege Üniversitesi Mühendislik Fakültesi";


SET SQL_SAFE_UPDATES = 1;