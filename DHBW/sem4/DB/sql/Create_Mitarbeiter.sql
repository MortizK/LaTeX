DROP TABLE IF EXISTS  Mitarbeiter;
CREATE TABLE IF EXISTS  Mitarbeiter
(
    Pers_Nr         integer,
    Vorname         varchar,
    Nachname        varchar,
    Geb_Name        varchar,
    Geb_Datum       date,
    Geschlecht      char(1),
    Eintrittsdatum  date,
	Skill			varchar(5) default 'PR',
	Gehalt			int,
	arbeitet_in		varchar(8),
	chef_von		integer,
PRIMARY KEY (Pers_Nr),
CHECK (Geschlecht IN ('m', 'w', 'd')),
CHECK (Gehalt > 20000 and Gehalt < 150000),
FOREIGN KEY(arbeitet_in) REFERENCES Abteilung,
FOREIGN KEY(chef_von) REFERENCES Mitarbeiter
);