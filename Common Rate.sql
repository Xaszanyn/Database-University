-- START BEFORE INSERTION! ========================================= --

CREATE TABLE common_rates (
	CurId int,
    CCode int,
    common_rate double
);
CREATE TABLE curriculum_common_rates (
	CurId int UNIQUE,
    common_rate double
);

DELIMITER //
CREATE FUNCTION common_rate (id int, cc int) -- common_rate(FId, CCode)
RETURNS double
DETERMINISTIC
BEGIN
	RETURN (SELECT 
  COUNT(RArea)
FROM 
  RESEARCH_AREAS
WHERE 
  FId = id 
  AND EXISTS (
    SELECT 
      keyword 
    FROM 
      KEYWORDS 
    WHERE 
      CCode = cc 
      AND keyword = RArea
  )) * 100 / (SELECT COUNT(keyword)
FROM KEYWORDS
WHERE CCode = cc);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION find_common_rate (cc int) -- find_common_rate(CCode)
RETURNS double
DETERMINISTIC
BEGIN
	RETURN (SELECT AVG(common_rate(s.SecInsId, s.SecCCode))
			FROM section AS s
			WHERE cc = SecCCode);
END //
DELIMITER ;





DELIMITER $$ 
CREATE TRIGGER ekin AFTER INSERT ON include FOR EACH ROW 
BEGIN
	INSERT INTO common_rates VALUES (NEW.CurId, NEW.CCode, (
		SELECT AVG(common_rate(s.SecInsId, s.SecCCode))
		FROM section AS s
		WHERE NEW.CCode = SecCCode
    ));
END
$$ DELIMITER ;

DELIMITER $$ 
CREATE TRIGGER ekinGeneral AFTER INSERT ON common_rates FOR EACH ROW 
BEGIN
	INSERT INTO curriculum_common_rates VALUES (NEW.CurId, (SELECT AVG(common_rate) FROM common_rates AS cr WHERE cr.CurId = NEW.CurId))
    ON DUPLICATE KEY UPDATE common_rate = (SELECT AVG(common_rate) FROM common_rates AS cr WHERE cr.CurId = NEW.CurId);
END
$$ DELIMITER ;




-- DEBUG SECTION ========================================= --
SET @ekinI = 1; -- section ve instructor id girilerek rate testleri yapılabilir.
SET @ekinC = 100;

SELECT SecInsId, common_rate(SecInsId, SecCCode) AS single_rate, find_common_rate(SecCCode) AS rate
FROM section
WHERE @ekinC = SecCCode;
