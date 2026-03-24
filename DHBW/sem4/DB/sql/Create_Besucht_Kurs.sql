DROP TABLE IF EXISTS  Besucht_Kurs;
CREATE TABLE IF EXISTS  Besucht_Kurs
(
	Pers_Nr		integer,
	Kurs_Nr		integer,
PRIMARY KEY (Pers_Nr, Kurs_Nr),
FOREIGN KEY (Pers_Nr) REFERENCES Mitarbeiter,
FOREIGN KEY (Kurs_Nr) REFERENCES Kurs
);