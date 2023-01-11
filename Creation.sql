-- Schema Creation
CREATE SCHEMA `university`;

-- Use University Shema
USE university;

-- COLLEGE Table Creation
CREATE TABLE `college` (
  `CName` VARCHAR(45) NOT NULL,
  `COffice` VARCHAR(60) NOT NULL,
  `CPhone` CHAR(11) NOT NULL,
  `DeanId` INT NOT NULL,
  PRIMARY KEY (`CName`),
  -- Unique DeanId
  UNIQUE (`DeanId`),
  -- Unique CPhone
  UNIQUE (`CPhone`),
  -- CPhone Check Contraint - Phone length must be 11.
  CONSTRAINT CPhoneCheck CHECK (LENGTH(CPhone) = 11));


-- FACULTY_MEMBER Table Creation
CREATE TABLE `faculty_member` (
  `FId` INT NOT NULL,
  `FName` VARCHAR(45) NOT NULL,
  `FOffice` VARCHAR(45) NOT NULL,
  `FPhone` CHAR(11) NOT NULL,
  `DCode` INT NOT NULL,
  PRIMARY KEY (`FId`),
  -- Unique FPhone
  UNIQUE (`FPhone`),
  -- FPhone Check Contraint - Phone length must be 11.
  CONSTRAINT FPhoneCheck CHECK (LENGTH(FPhone) = 11));

--  DEPT Table Creation
CREATE TABLE `dept` (
  `DCode` INT NOT NULL,
  `DName` VARCHAR(60) NOT NULL,
  `DOffice` VARCHAR(45) NOT NULL,
  `DPhone` CHAR(11) NOT NULL,
  `AdmCName` VARCHAR(45) NOT NULL,
  `DTypeId` INT NOT NULL,
  `ChairId` INT NOT NULL,
  `CStartDate` DATE NOT NULL,
  PRIMARY KEY (`DCode`),
  UNIQUE (`DName`),
  -- Unique Chair ID 
  UNIQUE (`ChairId`),
  -- Unique DPhone
  UNIQUE (`DPhone`),
  -- DPhone Check Contraint - Phone length must be 11.
  CONSTRAINT DPhoneCheck CHECK (LENGTH(DPhone) = 11));

-- DEPT_TYPE Table Creation
CREATE TABLE `dept_type` (
  `TId` INT NOT NULL,
  `TName` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`TId`),
  UNIQUE (`TName`));

-- COURSE Table Creation
CREATE TABLE `course` (
  `CCode` INT NOT NULL,
  `CoName` VARCHAR(45) NOT NULL,
  `Credits` INT NOT NULL,
-- Level is only undergraduate.
  -- If designer wants to add graduate also, it can be designed as specialization.
  `Level` VARCHAR(45) NOT NULL,

  `CDesc` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CCode`),
  UNIQUE (`CoName`),
  -- Check Credists 0 - 10
  CONSTRAINT CheckCredits CHECK ((Credits >= 0) AND (Credits <= 10)),
  CONSTRAINT CheckLevel CHECK (Level = 'Lisans'));

-- CURRICULUM Table Creation
CREATE TABLE `curriculum` (
  `CurId` INT NOT NULL,
  `CLang` VARCHAR(45) NOT NULL,
  -- `CLang_rate` INT NULL,
  `EndDate` DATE NULL,
  `DCode` INT NOT NULL,
  PRIMARY KEY (`CurId`),
  -- Language Check - İngilizce or Türkçe
  CONSTRAINT LangCheck CHECK ((CLang = 'İngilizce') OR (CLang = 'Türkçe')));

-- SECTION Table Creation
CREATE TABLE `section` (
  `SecId` INT NOT NULL,
  `SecNo` INT NOT NULL,
  -- CHANGED INT to VARCHAR(6)
  `Sem` VARCHAR(5) NOT NULL,
  -- Year ??
  `Year` INT NOT NULL,
  `Bldg` VARCHAR(45) NOT NULL,
  `RoomNo` VARCHAR(45) NOT NULL,
  `DaysTime` VARCHAR(45) NOT NULL,
  `SecCCode` INT NOT NULL,
  `SecInsId` INT NOT NULL,
  PRIMARY KEY (`SecId`),
  CONSTRAINT SemCheck CHECK ((SEM = 'Bahar') OR (SEM = 'Güz')),
  CONSTRAINT YearCheck CHECK ((Year >= 1) AND (Year <= 4)),
  CONSTRAINT DaysTimeCheck CHECK ((DaysTime = "Pazartesi") OR (DaysTime = "Salı") OR (DaysTime = "Çarşamba") OR (DaysTime = "Perşembe") OR (DaysTime = "Cuma")));

-- STUDENT Table Creation
CREATE TABLE `student` (
  `SId` INT NOT NULL,
  `DOB` DATE NOT NULL,
  `FName` VARCHAR(45) NOT NULL,
  `MName` VARCHAR(45) NULL,
  `LName` VARCHAR(45) NOT NULL,
  `Addr` VARCHAR(45) NOT NULL,
  -- SPHONE !!!
  `SPhone` CHAR(11) NOT NULL,
  -- MAJOR ??
  `Major` VARCHAR(45) NOT NULL,
  `DCode` INT NULL,
  PRIMARY KEY (`SId`),
  -- Unique SPhone
  UNIQUE (`SPhone`),
  -- SPhone Check Contraint - Phone length must be 11.
  CONSTRAINT SPhoneCheck CHECK (LENGTH(SPhone) = 11),
  -- DOB Check Contraint - Minimum 1950
  CONSTRAINT DOBCheck CHECK (DATE("1950-01-01") < DOB));

-- THESIS Table Creation +
CREATE TABLE `thesis` (
  `FId` INT NOT NULL,
  `TType` VARCHAR(45) NOT NULL,
  `TTitle` VARCHAR(45) NOT NULL,
  `TSubject` VARCHAR(45) NOT NULL,
  `DegUni` VARCHAR(45) NOT NULL,
  `DegDept` VARCHAR(45) NOT NULL,
  -- Year ??? TDate ???
  `DegYear` INT NOT NULL,
  -- TType and FId PK ???
  PRIMARY KEY (`FId`, `TType`),
  -- DegYearChech Contraint - Minimum 1950
  CONSTRAINT DegYearCheck CHECK (1950 < DegYear) );
  -- TRIGGERS 
  -- 1.)  For Thesis Type WRITE IT !!!!
  -- 2.)  MSC Before PHD 
  -- 3.)  Year not future.
  -- 4.)  DegYear < YEAR(NOW())

-- INCLUDE Table Creation +
CREATE TABLE `include` (
  `CurId` INT NOT NULL,
  `CCode` INT NOT NULL,
  -- Name ??? 
  `SemNo` INT NOT NULL,
  PRIMARY KEY (`CurId`, `CCode`),
  CONSTRAINT SemNoCheck CHECK ((SemNo >= 1) AND (SemNo <= 8)));


-- TAKES Table Creation +
CREATE TABLE `takes` (
  `SId` INT NOT NULL,
  `SecId` INT NOT NULL,
  -- FLOAT ??? 2.00 - 4.00
  `Grade` CHAR(2) NULL,
  PRIMARY KEY (`SId`, `SecId`),
  -- Credits AA - FF
  -- Case ????? We have thought about that.
  CONSTRAINT CheckGrade CHECK ((Grade = "AA") OR (Grade = "BA") OR (Grade = "BB") OR (Grade = "CB") OR (Grade = "CC") OR (Grade = "DC") OR (Grade = "DD") OR (Grade = "FD") OR (Grade = "FF")));


-- RESEARCH_AREAS Table Creation +
CREATE TABLE `research_areas` (
  `FId` INT NOT NULL,
  `RArea` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`FId`, `RArea`));


-- KEYWORDS Table Creation +
CREATE TABLE `keywords` (
  `CCode` INT NOT NULL,
  `Keyword` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`CCode`, `Keyword`));

-- INSTRUCTOR Table Creation +
CREATE TABLE `instructor` (
  `InsId` INT NOT NULL,
  PRIMARY KEY (`InsId`));


-- RESEARCH_ASSISTANT Table Creation +
CREATE TABLE `res_assistant` (
  `ResAsId` INT NOT NULL,
  PRIMARY KEY (`ResAsId`));

  
-- MANDATORY Table Creation +
CREATE TABLE `mandatory` (
  `ManCCode` INT NOT NULL,
  PRIMARY KEY (`ManCCode`));

-- OPTIONAL Table Creation +
CREATE TABLE `optional` (
  `OptCcode` INT NOT NULL,
  PRIMARY KEY (`OptCcode`));  

-- PROF Table Creation +
CREATE TABLE `prof` (
  `PId` INT NOT NULL,
  PRIMARY KEY (`PId`));
  
-- ASSOCIATE_PROF Table Creation +
CREATE TABLE `associate_prof` (
  `AssocPId` INT NOT NULL,
  PRIMARY KEY (`AssocPId`));
  
-- ASSISTANT_PROF Table Creation +
CREATE TABLE `assistant_prof` (
  `AssistPId` INT NOT NULL,
  PRIMARY KEY (`AssistPId`));

-- NON_TECH_OPT Table Creation +
CREATE TABLE `non_tech_opt` (
  `NTOptCcode` INT NOT NULL,
  PRIMARY KEY (`NTOptCcode`));

-- TECH_OPT Table Creation +
CREATE TABLE `tech_opt` (
  `TOptCcode` INT NOT NULL,
  PRIMARY KEY (`TOptCcode`));

