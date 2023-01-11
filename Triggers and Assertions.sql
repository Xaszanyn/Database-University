
USE university;

-- -- Chair ID Uniqueness Assertion with Trigger - BEFORE INSERT 
-- DELIMITER $$
-- CREATE TRIGGER ChairIdTrigger BEFORE INSERT
-- ON `dept` FOR EACH ROW
-- BEGIN
-- 	IF EXISTS(
-- 		SELECT *
--         FROM dept
--         WHERE New.ChairId = ChairId
--     )
--     THEN
-- 		SIGNAL SQLSTATE '45000' 
--         SET MESSAGE_TEXT = "INSERT ERROR - Chair ID can't contain duplicate values! ";
--     END IF;
-- END
-- $$ DELIMITER ;


-- -- Dean ID Uniqueness Assertion with Trigger - BEFORE INSERT 
-- DELIMITER $$
-- CREATE TRIGGER DeanIdTrigger BEFORE INSERT
-- ON `college` FOR EACH ROW
-- BEGIN
-- 	IF EXISTS(
-- 		SELECT *
--         FROM college
--         WHERE New.DeanId = DeanId
--     )
--     THEN
-- 		SIGNAL SQLSTATE '45000' 
--         SET MESSAGE_TEXT = "INSERT ERROR - Dean ID can't contain duplicate values! ";
--     END IF;
-- END
-- $$ DELIMITER ;


-- EndDate Assertion with Trigger BEFORE INSERT - EndDate Can't be in Future Time
DELIMITER $$
CREATE TRIGGER EndDateAssertionFutureInsert BEFORE INSERT
ON `curriculum` FOR EACH ROW
BEGIN
	IF (NEW.EndDate > NOW())
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - End Date Can't be in Future Time";
    END IF;
END
$$ DELIMITER ;


-- EndDate Assertion with Trigger BEFORE INSERT - Only one NULL EndDate (Only one Active Curriculum for each Department)
DELIMITER $$
CREATE TRIGGER EndDateAssertionNullInsert BEFORE INSERT
ON `curriculum` FOR EACH ROW
-- If there is a Null End Date for Department - Do not allow insert operation
BEGIN
	IF (EXISTS(
		SELECT EndDate
        FROM curriculum
        WHERE EndDate IS NULL AND NEW.DCode = DCode
    )) AND (NEW.EndDate IS NULL)
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Only one NULL Value is allowed for each department! There would be only one active curriculum for each department! ";
    END IF;
END
$$ DELIMITER ;

-- EndDate Assertion with Trigger BEFORE UPDATE - EndDate Can't be in Future Time
DELIMITER $$
CREATE TRIGGER EndDateAssertionFutureUpdate BEFORE UPDATE
ON `curriculum` FOR EACH ROW
BEGIN
	IF (NEW.EndDate > NOW())
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - End Date Can't be in Future Time";
    END IF;
END
$$ DELIMITER ;


-- EndDate Assertion with Trigger BEFORE UPDATE- Only one NULL EndDate (Only one Active Curriculum for each Department)
DELIMITER $$
CREATE TRIGGER EndDateAssertionNullUpdate BEFORE UPDATE
ON `curriculum` FOR EACH ROW
-- If there is a Null End Date for Department - Do not allow insert operation
-- We assume that a department can have only one active curriculum with one language.
BEGIN
	IF (EXISTS(
		SELECT EndDate
        FROM curriculum
        WHERE EndDate IS NULL AND NEW.DCode = DCode
    )) AND (NEW.EndDate IS NULL)
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Only one NULL Value is allowed for each department! There would be only one active curriculum for each department! ";
    END IF;
END
$$ DELIMITER ;

-- ChairStartDate Assertion with Trigger BEFORE INSERT - Chair Start Date Can't be in Future Time
DELIMITER $$
CREATE TRIGGER ChairStartDateAssertionFutureInsert BEFORE INSERT
ON `dept` FOR EACH ROW
BEGIN
	IF (NEW.CStartDate > NOW())
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Chair Start Date Can't be in Future Time";
    END IF;
END
$$ DELIMITER ;


-- ChairStartDate Assertion with Trigger BEFORE UPDATE - Chair Start Date Can't be in Future Time
DELIMITER $$
CREATE TRIGGER ChairStartDateAssertionFutureUpdate BEFORE UPDATE
ON `dept` FOR EACH ROW
BEGIN
	IF (NEW.CStartDate > NOW())
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Chair Start Date Can't be in Future Time";
    END IF;
END
$$ DELIMITER ;


USE university;

-- DeanID Assertion with Trigger BEFORE INSERT - Dean Must be Selected From Same University
DELIMITER $$
CREATE TRIGGER DeanAssertionSelectionSameDeptInsert BEFORE INSERT
ON `college` FOR EACH ROW
BEGIN
	IF (New.Cname) <> (SELECT AdmCName
                      FROM dept,  faculty_member, prof
                      WHERE dept.DCode = faculty_member.DCode 
                      AND faculty_member.FId = prof.PId 
                      AND New.DeanID = prof.PId) 
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Dean can't be selected from different college";
    END IF;
END
$$ DELIMITER ;


-- DeanID Assertion with Trigger BEFORE UPDATE - Dean Must be Selected From Same University
DELIMITER $$
CREATE TRIGGER DeanAssertionSelectionSameDeptUpdate BEFORE UPDATE
ON `college` FOR EACH ROW
BEGIN
	IF (New.Cname) <> (SELECT AdmCName
                      FROM dept,  faculty_member, prof
                      WHERE dept.DCode = faculty_member.DCode 
                      AND faculty_member.FId = prof.PId 
                      AND New.DeanID = prof.PId) 
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Dean can't be selected from different college";
    END IF;
END
$$ DELIMITER ;


-- ChairID Assertion with Trigger BEFORE INSERT - Chair Must be Selected From Same Dept
DELIMITER $$
CREATE TRIGGER ChairAssertionSameDeptInsert BEFORE INSERT
ON `dept` FOR EACH ROW
BEGIN
	IF (New.Dname) <> (SELECT Dname
                      FROM dept,  faculty_member, prof
                      WHERE dept.DCode = faculty_member.DCode 
                      AND faculty_member.FId = prof.PId 
                      AND New.ChairId = prof.PId) 
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Chair can't be selected from different college";
    END IF;
END
$$ DELIMITER ;

-- ChairID Assertion with Trigger BEFORE UPDATE - Chair Must be Selected From Same Dept
DELIMITER $$
CREATE TRIGGER ChairAssertionSameDeptUpdate BEFORE UPDATE
ON `dept` FOR EACH ROW
BEGIN
	IF (New.Dname) <> (SELECT Dname
                      FROM dept,  faculty_member, prof
                      WHERE dept.DCode = faculty_member.DCode 
                      AND faculty_member.FId = prof.PId 
                      AND New.ChairId = prof.PId) 
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Chair can't be selected from different college";
    END IF;
END
$$ DELIMITER ;

-- ChairID Assertion with Trigger BEFORE INSERT - Chair can't be dean.
DELIMITER $$
CREATE TRIGGER ChairAssertionInDeanCheckInsert BEFORE INSERT
ON `dept` FOR EACH ROW
BEGIN
	IF EXISTS (SELECT DeanId
               FROM College
               WHERE New.ChairId = DeanId) 
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Chair can't be dean.";
    END IF;
END
$$ DELIMITER ;

-- ChairID Assertion with Trigger BEFORE UPDATE - Chair can't be dean.
DELIMITER $$
CREATE TRIGGER ChairAssertionInDeanCheckUpdate BEFORE UPDATE
ON `dept` FOR EACH ROW
BEGIN
	IF EXISTS (SELECT DeanId
               FROM College
               WHERE New.ChairId = DeanId) 
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Chair can't be dean.";
    END IF;
END
$$ DELIMITER ;


-- DeanId Assertion with Trigger BEFORE INSERT - Dean can't be Chair.
DELIMITER $$
CREATE TRIGGER DeanAssertionInChairCheckInsert BEFORE INSERT
ON `college` FOR EACH ROW
BEGIN
	IF EXISTS (SELECT ChairId
               FROM Dept
               WHERE New.DeanId = ChairId) 
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Dean can't be Chair.";
    END IF;
END
$$ DELIMITER ;

-- DeanId Assertion with Trigger BEFORE UPDATE - Dean can't be Chair.
DELIMITER $$
CREATE TRIGGER DeanAssertionInChairCheckUpdate BEFORE UPDATE
ON `college` FOR EACH ROW
BEGIN
	IF EXISTS (SELECT ChairId
               FROM Dept
               WHERE New.DeanId = ChairId) 
    THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Dean can't be Chair.";
    END IF;
END
$$ DELIMITER ;


-- Instructor Specialization Assertion - INSERT Trigger

DELIMITER $$ 
CREATE TRIGGER InsAssertionSpecializationInsert BEFORE INSERT
ON `instructor` FOR EACH ROW
BEGIN
	IF EXISTS (SELECT ResAsId
			   FROM Res_Assistant
               WHERE NEW.InsId = Res_Assistant.ResAsId)
	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Research Assistant Can't be Instructor.";
    END IF;
END
$$ DELIMITER ;

-- Instructor Specialization Assertion - UPDATE Trigger

DELIMITER $$ 
CREATE TRIGGER InsAssertionSpecializationUpdate BEFORE UPDATE
ON `instructor` FOR EACH ROW
BEGIN
	IF EXISTS (SELECT ResAsId
			   FROM Res_Assistant
               WHERE NEW.InsId = Res_Assistant.ResAsId)
	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Research Assistant Can't be Instructor.";
    END IF;
END
$$ DELIMITER ;

-- Research Assistant Specialization Assertion - INSERT Trigger

DELIMITER $$ 
CREATE TRIGGER ResAssistAssertionSpecializationInsert BEFORE INSERT
ON `res_assistant` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT InsId
			   FROM Instructor
               WHERE NEW.ResAsId = Instructor.InsId)
	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Instructor can't be a research assistant.";
    END IF;
END
$$ DELIMITER ;

-- Research Assistant Specialization Assertion - UPDATE Trigger

DELIMITER $$ 
CREATE TRIGGER ResAssistAssertionSpecializationUpdate BEFORE UPDATE
ON `res_assistant` FOR EACH ROW
BEGIN
	IF EXISTS (SELECT InsId
			   FROM Instructor
               WHERE NEW.ResAsId = Instructor.InsId)
	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Instructor can't be a research assistant.";
    END IF;
END
$$ DELIMITER ;

-- Prof Specialization Assertion - INSERT Trigger

DELIMITER $$ 
CREATE TRIGGER ProfAssertionSpecializationInsert BEFORE INSERT
ON `prof` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT InsId
			   FROM instructor, associate_prof, assistant_prof
               WHERE (assistant_prof.AssistPId = instructor.InsId
               OR associate_prof.AssocPId = instructor.InsId) 
               AND NEW.PId = instructor.InsId)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR -  Associate Prof or Assistant Prof can't be Prof.";
    END IF;
END
$$ DELIMITER;

-- Prof Specialization Assertion - UPDATE Trigger

DELIMITER $$ 
CREATE TRIGGER ProfAssertionSpecializationUpdate BEFORE UPDATE
ON `prof` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT InsId
			   FROM instructor, associate_prof, assistant_prof
               WHERE (assistant_prof.AssistPId = instructor.InsId
               OR associate_prof.AssocPId = instructor.InsId) 
               AND NEW.PId = instructor.InsId)
	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR -  Associate Prof or Assistant Prof can't be Prof.";
    END IF;
END
$$ DELIMITER;


/* 
 TOTALITY !! !! !! 
           OR
       NOT EXISTS ( SELECT InsID 
                    FROM instructor
                    WHERE NEW.Pid = instructor.insId)
*/

/* Donanım sorusu çizimli 
   Stringlerle ilgili problem. => LABA BENZER => Assembly Kodu ???
   Sorting ??? -> Şimdilik sormayı düşünmüyor.
   Test & Klasik
   MAKİNE DİLİ ÇEVİRİMİ YOK
*/


-- Associate Prof Specialization Assertion - INSERT Trigger

DELIMITER $$ 
CREATE TRIGGER AssocProfAssertionSpecializationInsert BEFORE INSERT
ON `associate_prof` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT InsId
			   FROM instructor, prof, assistant_prof
               WHERE (assistant_prof.AssistPId = instructor.InsId
               OR prof.PId = instructor.InsId) 
               AND NEW.AssocPId = instructor.InsId)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Prof or Assistant Prof can't be Associate Prof.";
    END IF;
END
$$ DELIMITER;


-- Associate Prof Specialization Assertion - UPDATE Trigger

DELIMITER $$ 
CREATE TRIGGER AssocProfAssertionSpecializationUpdate BEFORE UPDATE
ON `associate_prof` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT InsId
			   FROM instructor, prof, assistant_prof
               WHERE (assistant_prof.AssistPId = instructor.InsId
               OR prof.PId = instructor.InsId) 
               AND NEW.AssocPId = instructor.InsId)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Prof or Assistant Prof can't be Associate Prof.";
    END IF;
END
$$ DELIMITER;

-- Assitant Prof Specialization Assertion - INSERT Trigger

DELIMITER $$ 
CREATE TRIGGER AssistProfAssertionSpecializationInsert BEFORE INSERT
ON `assistant_prof` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT InsId
			   FROM instructor, prof, associate_prof
               WHERE (associate_prof.AssocPId = instructor.InsId
               OR prof.PId = instructor.InsId) 
               AND NEW.AssistPId = instructor.InsId)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Associate Prof or Prof can't be Assitant Prof.";
    END IF;
END
$$ DELIMITER;

-- Assitant Prof Specialization Assertion - UPDATE Trigger

DELIMITER $$ 
CREATE TRIGGER AssistProfAssertionSpecializationUpdate BEFORE UPDATE
ON `assistant_prof` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT InsId
			   FROM instructor, prof, associate_prof
               WHERE (associate_prof.AssocPId = instructor.InsId
               OR prof.PId = instructor.InsId) 
               AND NEW.AssistPId = instructor.InsId)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Associate Prof or Prof can't be Assitant Prof.";
    END IF;
END
$$ DELIMITER;


-- Mandatory Course Specialization Assertion - INSERT Trigger

DELIMITER $$ 
CREATE TRIGGER ManCourseAssertionSpecializationInsert BEFORE INSERT
ON `mandatory` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT OptCcode
			   FROM optional
               WHERE NEW.ManCCode = OptCcode)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Optional Course can't be a mandatory course.";
    END IF;
END
$$ DELIMITER;

-- Mandatory Course Specialization Assertion - UPDATE Trigger

DELIMITER $$ 
CREATE TRIGGER ManCourseAssertionSpecializationUpdate BEFORE UPDATE
ON `mandatory` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT OptCcode
			   FROM optional
               WHERE NEW.ManCCode = OptCcode)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Optional Course can't be a mandatory course.";
    END IF;
END
$$ DELIMITER;

-- Optional Course Specialization Assertion - INSERT Trigger

DELIMITER $$ 
CREATE TRIGGER OptCourseAssertionSpecializationInsert BEFORE INSERT
ON `optional` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT ManCCode
			   FROM mandatory
               WHERE NEW.OptCcode = ManCCode)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Mandatory Course can't be an optional course.";
    END IF;
END
$$ DELIMITER;

-- Optional Course Specialization Assertion - UPDATE Trigger

DELIMITER $$ 
CREATE TRIGGER OptCourseAssertionSpecializationUpdate BEFORE UPDATE
ON `optional` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT ManCCode
			   FROM mandatory
               WHERE NEW.OptCcode = ManCCode)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Mandatory Course can't be an optional course.";
    END IF;
END
$$ DELIMITER;

-- Technichal Optional Course Specialization Assertion - INSERT Trigger

DELIMITER $$ 
CREATE TRIGGER TechOptCourseAssertionSpecializationInsert BEFORE INSERT
ON `tech_opt` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT NTOptCcode
			   FROM non_tech_opt
               WHERE NEW.TOptCcode = NTOptCcode)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Non Technichal Optional Course can't be a Technichal Optional Course.";
    END IF;
END
$$ DELIMITER;

-- Non Technichal Optional Course Specialization Assertion - UPDATE Trigger

DELIMITER $$ 
CREATE TRIGGER TechOptCourseAssertionSpecializationUpdate BEFORE UPDATE
ON `tech_opt` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT NTOptCcode
			   FROM non_tech_opt
               WHERE NEW.TOptCcode = NTOptCcode)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Non Technichal Optional Course can't be a Technichal Optional Course.";
    END IF;
END
$$ DELIMITER;


-- Non Technichal Optional Course Specialization Assertion - INSERT Trigger

DELIMITER $$ 
CREATE TRIGGER NonTechOptCourseAssertionSpecializationInsert BEFORE INSERT
ON `non_tech_opt` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT TOptCcode
			   FROM tech_opt
               WHERE NEW.NTOptCcode = TOptCcode)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "INSERT ERROR - Technichal Optional Course can't be a Non Technichal Optional Course.";
    END IF;
END
$$ DELIMITER;

-- Non Technichal Optional Course Specialization Assertion - UPDATE Trigger

DELIMITER $$ 
CREATE TRIGGER NonTechOptCourseAssertionSpecializationUpdate BEFORE UPDATE
ON `non_tech_opt` FOR EACH ROW 
BEGIN
	IF EXISTS (SELECT TOptCcode
			   FROM tech_opt
               WHERE NEW.NTOptCcode = TOptCcode)

	THEN SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = "UPDATE ERROR - Technichal Optional Course can't be a Non Technichal Optional Course.";
    END IF;
END
$$ DELIMITER ;

-- Not Same Course for Instructor on Active Curriculum

DELIMITER $$ 
CREATE TRIGGER CourseAndInsSameInsert BEFORE INSERT
ON `section` FOR EACH ROW 
BEGIN
	IF (SELECT AdmCName
	FROM section, include, curriculum, dept
	WHERE section.SecCCode = include.CCode
	AND include.CurId = curriculum.CurId
	AND curriculum.Dcode = dept.Dcode
	AND EndDate IS NULL
	AND Ccode = New.SecCCode
	GROUP BY CCode) <> (SELECT AdmCname
	FROM section, faculty_member, dept
	WHERE section.SecInsId = faculty_member.Fid
	AND faculty_member.DCode = dept.DCode
	AND Fid = New.SecInsId)
    THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'ERRROR ';
END IF;
END
$$ DELIMITER ;








