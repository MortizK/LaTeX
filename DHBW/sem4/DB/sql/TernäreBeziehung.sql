DROP TABLE IF EXISTS Mitarbeiter;

CREATE TABLE IF NOT EXISTS Mitarbeiter
(
	Pers_Nr integer,
	Vorname varchar,
	Nachname varchar NOT NULL,
	PRIMARY KEY (Pers_Nr)
);

DROP TABLE IF EXISTS Projekt;

CREATE TABLE IF NOT EXISTS Projekt
(
	Projekt_Nr integer,
	PRIMARY KEY (Projekt_Nr)	 
);

DROP TABLE IF EXISTS Ort;

CREATE TABLE IF NOT EXISTS Ort
(
	Ort_Nr integer,
	PRIMARY KEY (Ort_Nr)
);

-- Nun zur arbeitet

DROP TABLE IF EXISTS arbeitet;

CREATE TABLE IF NOT EXISTS arbeitet
(
	Pers_Nr integer NOT NULL,
	Projekt_Nr integer NOT NULL,
	Ort_Nr integer,
	PRIMARY KEY (Pers_Nr, Projekt_Nr),
	FOREIGN KEY (Pers_Nr) REFERENCES Mitarbeiter,
	FOREIGN KEY (Projekt_Nr) REFERENCES Projekt,
	FOREIGN KEY (Ort_Nr) REFERENCES Ort,
	CONSTRAINT PersOrt UNIQUE (Pers_Nr, Ort_Nr) 
);