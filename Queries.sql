-- SINGLE TABLES

-- Student List
SELECT SId AS ID, FName AS Name, LName AS Surname, Addr AS Address
FROM student
ORDER BY Fname;

-- Faculty Members of Department
SELECT *
FROM faculty_member
WHERE DCode = 30;

-- All Keywords
SELECT DISTINCT Keyword
FROM keywords;


-- DOUBLE TABLES

-- Department With Types
SELECT DName, DOffice, DPhone, TName
FROM dept, dept_type
WHERE DTypeId = TId;

-- College and Departments
SELECT CName, CONCAT(DOffice, ' - ', COffice) AS Office, DCode, DName
FROM college, dept
WHERE CName = AdmCName;

-- Courses With Their Keywords
SELECT DISTINCT CoName, (
	SELECT GROUP_CONCAT(keyword SEPARATOR ', ')
	FROM keywords AS kw
	WHERE kw.CCode = k.CCode
) AS All_Keywords
FROM course AS c, keywords AS k
WHERE c.CCode = k.CCode;

-- Faculty Members With Their Research Areas
SELECT FName, DCode, (
	SELECT GROUP_CONCAT(RArea SEPARATOR ", ")
    FROM research_areas AS res
    WHERE res.FId = ra.FId
) AS Research_Areas
FROM faculty_member AS fm, research_areas AS ra
WHERE fm.FId = ra.FId;


-- TRIPLE TABLES

-- Students With Their Notes
SELECT stu.SId, FName, LName, Grade, CoName
FROM student AS stu, takes AS t, section AS sec, course AS c
WHERE stu.SId = t.SId AND t.SecId = sec.SecId AND sec.SecCCode = c.CCode;

-- Colleges Deans and Chairs
SELECT c.CName, fd.FName AS Dean_Name, c.COffice, d.DName, f.FName AS Chair_Name
FROM college AS c, faculty_member AS f, dept AS d, faculty_member AS fd
WHERE c.CName = d.AdmCName AND d.ChairId = f.FId AND fd.FId = c.DeanId;

-- Curriculum With Their Courses
SELECT cu.CurId, cu.CLang, cu.EndDate, GROUP_CONCAT(CoName SEPARATOR ", ") AS Courses
FROM curriculum AS cu, include AS i, course AS co
WHERE cu.CurId = i.CurId AND i.CCode = co.CCode
GROUP BY cu.CurId;


-- CRITICAL

-- Faculty Members With Types
SELECT fm.FId, fm.FName, CASE
	WHEN t = 1 THEN "Research Assistant"
    WHEN t = 2 THEN "Instructor - Professor"
    WHEN t = 3 THEN "Instructor - Associate Professor"
    WHEN t = 4 THEN "Instructor - Assistant Professor"
END AS "Type", FOffice, FPhone
FROM (
(SELECT ResAsId AS FId, 1 as t FROM res_assistant)
UNION
(SELECT PId AS FId, 2 as t FROM prof)
UNION
(SELECT AssocPId AS FId, 3 as t FROM associate_prof)
UNION
(SELECT AssistPId AS FId, 4 as t FROM assistant_prof)
) AS u, faculty_member AS fm
WHERE u.FId = fm.FId
ORDER BY u.FId;

-- Courses With Types
SELECT c.CCode, c.CoName, c.Credits, CASE
	WHEN t = 1 THEN "Mandatory"
    WHEN t = 2 THEN "Technical Optional"
    WHEN t = 3 THEN "Non-Technical Optional"
END AS "Type"
FROM (
(SELECT ManCCode AS CCode, 1 as t FROM mandatory)
UNION
(SELECT TOptCcode AS CCode, 2 as t FROM tech_opt)
UNION
(SELECT NTOptCcode AS CCode, 3 as t FROM non_tech_opt)
) AS u, course AS c
WHERE u.CCode = c.CCode
ORDER BY u.CCode;


-- Indicates the validity of the course taken by the student in it's department.

SET @studentID = 1;
SET @SecID = 50;
SELECT EXISTS (
	SELECT *
    FROM (
		SELECT c.DCode
 		FROM curriculum AS c
 		WHERE EXISTS (
 			SELECT i.CurId
 			FROM include AS i
 			WHERE (
 				SELECT SecCCode
 				FROM section AS sec
 				WHERE @SecID = sec.SecId
             ) = i.CCode AND c.CurId = i.CurId
 		)
     ) AS x
     WHERE x.DCode = (
 		SELECT DCode
 		FROM student AS s
 		WHERE @studentId = s.SId
 		)
) AS isValid;












-- SET @test = 5;
-- SELECT @test;



