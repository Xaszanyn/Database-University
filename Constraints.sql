USE university;

-- College DeanID (Dean Relationship) Foreign KEY
ALTER TABLE college 
    ADD CONSTRAINT `College Dean FK`
    FOREIGN KEY(DeanId)
    REFERENCES prof(PId)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- Faculty Member DCode (Employs Relationship) Foreign KEY
ALTER TABLE faculty_member 
    ADD CONSTRAINT `FMember DCode FK`
    FOREIGN KEY(Dcode)
    REFERENCES dept(Dcode)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- Research Areas FId (Multivalued Attribute) Foreign KEY
ALTER TABLE research_areas 
    ADD CONSTRAINT `Research Area FId FK`
    FOREIGN KEY(FId)
    REFERENCES faculty_member(FId)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Thesis FID (Has Relationship) Foreign KEY
ALTER TABLE thesis 
    ADD CONSTRAINT `Thesis FID FK`
    FOREIGN KEY(FId)
    REFERENCES faculty_member(FId)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Instructor ID (Specialization) Foreign KEY 
ALTER TABLE instructor 
    ADD CONSTRAINT `instructor ID FK`
    FOREIGN KEY(InsId)
    REFERENCES faculty_member(FId)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Research Assistant ID (Specialization) Foreign KEY 
ALTER TABLE res_assistant
    ADD CONSTRAINT `Research Assistant ID FK`
    FOREIGN KEY(ResAsId)
    REFERENCES faculty_member(FId)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Prof ID (Specialization) Foreign KEY 
ALTER TABLE prof
    ADD CONSTRAINT `Prof ID FK`
    FOREIGN KEY(PId)
    REFERENCES instructor(InsId)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- Associate Prof ID (Specialization) Foreign KEY 
ALTER TABLE associate_prof
    ADD CONSTRAINT `Associate Prof ID FK`
    FOREIGN KEY(AssocPId)
    REFERENCES instructor(InsId)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Assistant Prof ID (Specialization) Foreign KEY 
ALTER TABLE assistant_prof
    ADD CONSTRAINT `Assitant Prof ID FK`
    FOREIGN KEY(AssistPId)
    REFERENCES instructor(InsId)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Dept Chair ID (Chair Relationship) Foreign KEY
ALTER TABLE dept 
    ADD CONSTRAINT `Chair ID FK`
    FOREIGN KEY(ChairId)
    REFERENCES prof(PId)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- Dept College Name (Admins Relationship) Foreign KEY
ALTER TABLE dept 
    ADD CONSTRAINT `Admins College FK`
    FOREIGN KEY(AdmCName)
    REFERENCES College(CName)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Dept Type (Become Relationship) Foreign KEY
ALTER TABLE dept
    ADD CONSTRAINT `Dept Type FK`
    FOREIGN KEY(DTypeId)
    REFERENCES dept_type(TId)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Student Dcode (Has Relationship) Foreign KEY
ALTER TABLE student
    ADD CONSTRAINT `Student Dcode FK`
    FOREIGN KEY(DCode)
    REFERENCES dept(Dcode)
    ON DELETE RESTRICT ON UPDATE CASCADE;

-- Curriculum Dcode (Offers Relationshio) Foreign KEY
ALTER TABLE curriculum
    ADD CONSTRAINT `Curriculum Dcode FK`
    FOREIGN KEY(DCode)
    REFERENCES dept(Dcode)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Include Curriculum ID (Many to Many Relationship) FK
ALTER TABLE include
    ADD CONSTRAINT `Include Curriculum ID FK`
    FOREIGN KEY(CurId)
    REFERENCES curriculum(CurId)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Include Course Code (Many to Many Relationship) FK
ALTER TABLE include
    ADD CONSTRAINT `Include Course Code FK`
    FOREIGN KEY(CCode)
    REFERENCES course(CCode)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Course Keywords (Multivalued Attribute) FK
ALTER TABLE keywords
    ADD CONSTRAINT `Course ID Keyword FK`
    FOREIGN KEY(CCode)
    REFERENCES course(CCode)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Mandatory Course Code (Specialization) FK
ALTER TABLE mandatory
    ADD CONSTRAINT `Mandatory Course Code FK`
    FOREIGN KEY(ManCCode)
    REFERENCES course(CCode)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Optional Course Code (Specialization) FK
ALTER TABLE optional
    ADD CONSTRAINT `Optional Course Code FK`
    FOREIGN KEY(OptCcode)
    REFERENCES course(CCode)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Technical Optional Course Code (Specialization) FK
ALTER TABLE tech_opt
    ADD CONSTRAINT `Technical Optional Course Code FK`
    FOREIGN KEY(TOptCcode)
    REFERENCES optional(OptCcode)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- NonTechnical Optional Course Code (Specialization) FK
ALTER TABLE non_tech_opt
    ADD CONSTRAINT `NonTechnical Optional Course Code FK`
    FOREIGN KEY(NTOptCcode)
    REFERENCES optional(OptCcode)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Section Course Code (Secs Relationship) FK
ALTER TABLE section
    ADD CONSTRAINT `Section Course Code FK`
    FOREIGN KEY(SecCCode)
    REFERENCES course(CCode)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Section Instructor ID (Secs Relationship) FK
ALTER TABLE section
    ADD CONSTRAINT `Section Instructor ID FK`
    FOREIGN KEY(SecInsId)
    REFERENCES instructor(InsId)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Takes Student ID (Many to Many Relationsip) FK
ALTER TABLE takes
    ADD CONSTRAINT `Takes Student ID FK`
    FOREIGN KEY(SId)
    REFERENCES student(SId)
    ON DELETE CASCADE ON UPDATE CASCADE;

-- Takes Section ID (Many to Many Relationsip) FK
ALTER TABLE takes
    ADD CONSTRAINT `Takes Section ID FK`
    FOREIGN KEY(SecId)
    REFERENCES section(SecId)
    ON DELETE CASCADE ON UPDATE CASCADE;









