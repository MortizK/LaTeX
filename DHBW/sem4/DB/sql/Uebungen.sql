
-- DDL
-- CREATE TABLE ...

DROP TABLE IF EXISTS arbeitet_in;   -- Drop this first to avoid dependencies issues with foreign Keys
DROP TABLE IF EXISTS Mitarbeiter;
DROP TABLE IF EXISTS Abteilung;

CREATE Table Mitarbeiter (
    ID int,
    Vorname varchar(100),
    Nachname varchar(100),
    Gehalt int,
    PRIMARY KEY (ID)
);

CREATE Table Abteilung (
    ID int,
    Name varchar(100),
    PRIMARY KEY (ID)
);

CREATE Table arbeitet_in (
    MitarbeiterID int,
    AbteilungID int,
    PRIMARY KEY (MitarbeiterID, AbteilungID)
);

-- ALTER TABLE ...
ALTER Table arbeitet_in 
ADD CONSTRAINT
    MitarbeiterID_fkey FOREIGN KEY (MitarbeiterID) REFERENCES Mitarbeiter
    ON UPDATE CASCADE
    ON DELETE CASCADE
;
    
ALTER Table arbeitet_in 
ADD CONSTRAINT
    AbteilungID_fkey FOREIGN KEY (AbteilungID) REFERENCES Abteilung
    ON UPDATE CASCADE
    ON DELETE SET NULL
;


-- DML
-- INSERT INTO ...
INSERT INTO Mitarbeiter Values
(1, 'Moritz', 'Köhler', 400),
(2, 'Niklas', 'Reusch', 500),
(3, 'Rosalie', 'Fischer', 800),
(4, 'Leon', 'Salenbacher', 0)
;

INSERT INTO Abteilung Values
(1, 'DHBW'),
(2, 'Telekom'),
(3, 'Bosch')
;

INSERT INTO arbeitet_in Values
(1, 1),
(1, 2),
(2, 2),
(3, 1)
;

-- DQL
-- SELECT ...
SELECT * from Mitarbeiter;

SELECT * from Abteilung;

SELECT * from arbeitet_in;

SELECT ID, Vorname, Nachname from Mitarbeiter
WHERE ID IN (
    SELECT MitarbeiterID from arbeitet_in
    WHERE AbteilungID = 1
);

-- JOINS ...
-- 1.
SELECT m.ID, m.Vorname, m.Nachname
from Mitarbeiter m
INNER JOIN arbeitet_in ai ON m.ID = ai.MitarbeiterID
WHERE ai.AbteilungID = 1
;

-- 2.
SELECT ID, Name from Abteilung
WHERE ID IN (
    SELECT AbteilungID from arbeitet_in
);

-- 3.
SELECT ai.AbteilungID, a.Name, count(ai.MitarbeiterID) 
from arbeitet_in ai
INNER JOIN Abteilung a ON ai.AbteilungID = a.ID
GROUP BY ai.AbteilungID, a.Name;

SELECT a.ID, a.Name, count(ai.MitarbeiterID) 
from Abteilung a
INNER JOIN arbeitet_in ai ON ai.AbteilungID = a.ID
GROUP BY a.ID, a.Name;
-- Both do not return Abteilung (3, 'Bosch')

SELECT a.ID, a.Name, COUNT(ai.MitarbeiterID) as employee_count
FROM Abteilung a
LEFT JOIN arbeitet_in ai ON ai.AbteilungID = a.ID
GROUP BY a.ID, a.Name;

-- What JOINS are there and when do I use them?
-- INNER JOIN: Returns only rows where there is a match in both tables
-- LEFT JOIN: All from left + matches from right
-- RIGHT JOIN: All from right + matches from left
-- FULL OUTER JOIN: All from both + matches from both

-- 4.
SELECT m.id, m.Vorname, m.Nachname, a.Name 
from Mitarbeiter m
LEFT JOIN arbeitet_in ai ON m.id = ai.MitarbeiterID
LEFT JOIN Abteilung a ON ai.AbteilungID = a.ID
; 
-- Both LEFT JOINS to have Leon work in [null]

-- 5. I do not get it
SELECT m.id, m.Vorname, m.Nachname
from Mitarbeiter m
INNER JOIN arbeitet_in ai ON m.id = ai.MitarbeiterID
GROUP BY m.id
HAVING count(ai.AbteilungID) > 1
;

-- 6. 
SELECT a.ID, a.Name, COUNT(ai.MitarbeiterID) as employee_count
FROM Abteilung a
LEFT JOIN arbeitet_in ai ON ai.AbteilungID = a.ID
GROUP BY a.ID, a.Name;

-- 7. Extension of 6., which I did not get
-- Solution by CoPilot:
SELECT m.Vorname, m.Nachname, COUNT(ai.AbteilungID) as department_count
FROM Mitarbeiter m
INNER JOIN arbeitet_in ai ON m.id = ai.MitarbeiterID
GROUP BY m.id, m.Vorname, m.Nachname
ORDER BY department_count DESC
LIMIT 1;

-- Further edge Cases for Learnings:

-- EDGE CASE 1: NULL Handling in JOINs
-- Question: What happens if we have employees with NULL salary?
-- Try: Join and filter WHERE Gehalt > 600
SELECT m.Vorname, m.Gehalt
FROM Mitarbeiter m
WHERE m.Gehalt > 600;
-- Problem: Leon has Gehalt=0, but NULL values are tricky!

-- EDGE CASE 2: COUNT vs COUNT(*)
-- Question: What's the difference?
SELECT 
    COUNT(*) as total_rows,           -- Counts all rows including NULLs
    COUNT(ai.AbteilungID) as counted  -- Counts only non-NULL values
FROM arbeitet_in ai;

-- EDGE CASE 3: HAVING without GROUP BY
-- Question: Can you use HAVING without GROUP BY?
SELECT COUNT(*) as cnt
FROM Mitarbeiter
HAVING COUNT(*) > 1;  -- This works but rarely used

-- EDGE CASE 4: Multiple aggregations with HAVING
-- Question: Show departments with > 1 employee AND sum salary > 1000
SELECT 
    a.ID, 
    a.Name, 
    COUNT(ai.MitarbeiterID) as emp_count,
    SUM(m.Gehalt) as total_salary
FROM Abteilung a
LEFT JOIN arbeitet_in ai ON a.ID = ai.AbteilungID
LEFT JOIN Mitarbeiter m ON ai.MitarbeiterID = m.ID
GROUP BY a.ID, a.Name
HAVING COUNT(ai.MitarbeiterID) > 1 AND SUM(m.Gehalt) > 1000;

-- EDGE CASE 5: Filtering BEFORE vs AFTER JOIN
-- Question A: Filter before JOIN (affects which rows are joined)
SELECT m.Vorname, a.Name
FROM Mitarbeiter m
LEFT JOIN arbeitet_in ai ON m.ID = ai.MitarbeiterID
LEFT JOIN Abteilung a ON ai.AbteilungID = a.ID
WHERE m.Gehalt > 400;  -- Filters after join - Leon excluded

-- Question B: Filter in ON clause (different behavior!)
SELECT m.Vorname, a.Name
FROM Mitarbeiter m
LEFT JOIN arbeitet_in ai ON m.ID = ai.MitarbeiterID AND m.Gehalt > 400
LEFT JOIN Abteilung a ON ai.AbteilungID = a.ID;
-- Different result! LEFT JOIN still shows Leon with NULL dept

-- EDGE CASE 6: Self-JOIN with GROUP BY
-- Question: Find employees with same salary (group them)
SELECT m1.Vorname, m1.Gehalt, COUNT(*) as count_same_salary
FROM Mitarbeiter m1
INNER JOIN Mitarbeiter m2 ON m1.Gehalt = m2.Gehalt AND m1.ID <= m2.ID
GROUP BY m1.ID, m1.Vorname, m1.Gehalt
HAVING COUNT(*) > 1;

-- EDGE CASE 7: UNION to combine different queries
-- Question: Get all IDs from both tables (Mitarbeiter and Abteilung)
SELECT ID FROM Mitarbeiter
UNION  -- Removes duplicates
SELECT ID FROM Abteilung;

-- Question: Same but keep duplicates
SELECT ID FROM Mitarbeiter
UNION ALL  -- Keeps duplicates
SELECT ID FROM Abteilung;

-- EDGE CASE 8: Subquery in SELECT
-- Question: For each department, show count + percentage of total
SELECT 
    a.Name,
    COUNT(ai.MitarbeiterID) as emp_count,
    ROUND(100.0 * COUNT(ai.MitarbeiterID) / (SELECT COUNT(*) FROM arbeitet_in), 2) as percentage
FROM Abteilung a
LEFT JOIN arbeitet_in ai ON a.ID = ai.AbteilungID
GROUP BY a.ID, a.Name;

-- EDGE CASE 9: HAVING with subquery
-- Question: Show employees who work in more departments than the average
SELECT m.ID, m.Vorname, COUNT(ai.AbteilungID) as dept_count
FROM Mitarbeiter m
INNER JOIN arbeitet_in ai ON m.ID = ai.MitarbeiterID
GROUP BY m.ID, m.Vorname
HAVING COUNT(ai.AbteilungID) > (SELECT AVG(dept_count) FROM (
    SELECT COUNT(AbteilungID) as dept_count
    FROM arbeitet_in
    GROUP BY MitarbeiterID
) AS avg_calc);

-- EDGE CASE 10: LEFT JOIN chain order matters
-- Question A: Does order matter?
SELECT m.Vorname, ai.MitarbeiterID, a.Name
FROM Mitarbeiter m
LEFT JOIN arbeitet_in ai ON m.ID = ai.MitarbeiterID
LEFT JOIN Abteilung a ON ai.AbteilungID = a.ID;

-- Question B: Swapping order - different result!
SELECT m.Vorname, ai.MitarbeiterID, a.Name
FROM Abteilung a
LEFT JOIN arbeitet_in ai ON a.ID = ai.AbteilungID
LEFT JOIN Mitarbeiter m ON ai.MitarbeiterID = m.ID;
-- Result: Bosch is now included even with LEFT in different order!

-- EDGE CASE 11: DISTINCT with aggregates
-- Question: How many DIFFERENT departments exist?
SELECT COUNT(DISTINCT AbteilungID) as unique_depts
FROM arbeitet_in;

-- EDGE CASE 12: GROUP BY all non-aggregated columns
-- Question: This is REQUIRED SQL standard (some DB enforce it, others don't)
-- PostgreSQL/Oracle: MUST group by ALL non-aggregated columns
-- MySQL/SQLite: Looser rules - can select ungrouped columns
SELECT m.Vorname, m.Nachname, COUNT(*) as assignment_count
FROM Mitarbeiter m
INNER JOIN arbeitet_in ai ON m.ID = ai.MitarbeiterID
GROUP BY m.ID, m.Vorname, m.Nachname;  -- All non-agg columns grouped


-- Übungsklausur aufgabe 3
DROP TABLE IF EXISTS StationsPersonal CASCADE;
DROP TABLE IF EXISTS Aerzte CASCADE;
DROP TABLE IF EXISTS Patient CASCADE;
DROP TABLE IF EXISTS Zimmer CASCADE;
DROP TABLE IF EXISTS Station CASCADE;
DROP TABLE IF EXISTS behandelt CASCADE;

CREATE TABLE Station (
    StatNr int,
    Name varchar(100),
    PRIMARY KEY (StatNr)
);

CREATE TABLE Zimmer (
    RaumNr int,
    StatNr int,
    AnzBetter int,
    PRIMARY KEY (RaumNr),
    FOREIGN KEY (StatNr) REFERENCES Station(StatNr)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

CREATE TABLE StationsPersonal (
    PersNr int,
	Nachname varchar(100),
	Vorname varchar(100),
    PRIMARY KEY (PersNr)
);

CREATE TABLE Aerzte (
    PersNr int,
    Fachgebiet varchar(100),
    Rang int,
    PRIMARY KEY (PersNr),
	FOREIGN KEY (PersNR) REFERENCES StationsPersonal(PersNr)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

CREATE TABLE Patient (
    PatNr int,
    Name varchar(100),
    Krankheit varchar(255),
    Einlieferung date,
    Entlassung date,
    RaumNr int,
    PRIMARY KEY (PatNr),
    FOREIGN KEY (RaumNr) REFERENCES Zimmer(RaumNr)
		ON UPDATE CASCADE
		ON DELETE SET NULL
);

CREATE TABLE behandelt (
    PersNr int,
    PatNr int,
    PRIMARY KEY (PersNr, PatNr),
    FOREIGN KEY (PersNr) REFERENCES Aerzte(PersNr)
		ON UPDATE CASCADE
		ON DELETE SET NULL,
    FOREIGN KEY (PatNr) REFERENCES Patient(PatNr)
		ON UPDATE CASCADE
		ON DELETE CASCADE
);

-- Stationen
INSERT INTO Station (StatNr, Name) VALUES 
(1, 'Kardiologie'),
(2, 'Chirurgie'),
(3, 'Innere Medizin');

-- Zimmer
INSERT INTO Zimmer (RaumNr, StatNr, AnzBetter) VALUES 
(101, 1, 2),
(102, 1, 1),
(201, 2, 2),
(301, 3, 3),
(302, 3, 2);

-- StationsPersonal
INSERT INTO StationsPersonal(PersNr, Vorname, Nachname) VALUES
(1001, 'Moritz', 'Köhler'),
(1002, 'Niklas', 'Reusch'),
(1003, 'Leon', 'Salenbacher'),
(1004, 'Rosalie', 'Fischer'),
(1005, 'Felix', 'Weinert');

-- Ärzte
INSERT INTO Aerzte (PersNr, Fachgebiet, Rang) VALUES 
(1001, 'Kardiologie', 1),
(1002, 'Kardiologie', 2),
(1003, 'Chirurgie', 1),
(1004, 'Innere Medizin', 2);

-- Patienten
INSERT INTO Patient (PatNr, Name, Krankheit, Einlieferung, Entlassung, RaumNr) VALUES 
(5001, 'Meier, Hans', 'Herzinfarkt', '2026-05-20', NULL, 101),
(5002, 'Becker, Ursula', 'Bluthochdruck', '2026-05-22', NULL, 102),
(5003, 'König, Thomas', 'Blinddarmentzündung', '2026-05-25', NULL, 201),
(5004, 'Wagner, Sophia', 'Grippe', '2026-05-18', '2026-05-25', 301);

-- Behandlungen (wer behandelt wen)
INSERT INTO behandelt (PersNr, PatNr) VALUES 
(1001, 5001),
(1002, 5002),
(1003, 5003),
(1004, 5004);

SELECT * from Aerzte
WHERE PersNr IN (
	SELECT PersNR from behandelt
	WHERE PatNr IN (
		SELECT PatNr from Patient
		WHERE RaumNr IN (
			SELECT RaumNr from Zimmer
			WHERE StatNR = 3
		)
	)
);

SELECT a.persnr, a.fachgebiet, a.rang, s.vorname, s.nachname
from Aerzte a, behandelt b, Patient p, Zimmer z, StationsPersonal s
WHERE
	z.StatNr = 3 AND
	p.RaumNr = z.RaumNr AND
	b.PatNr = p.PatNr AND
	a.PersNr = b.PersNr AND
	s.PersNr = a.PersNr;

UPDATE StationsPersonal
SET PersNr = 2004
WHERE PersNr = 1004;