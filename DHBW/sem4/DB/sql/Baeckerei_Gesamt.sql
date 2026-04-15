-- Baeckerei Datenbankschema aus project.tex (markierter Kontext)
-- Ein Skript mit 3 Teilen:
-- 1) Tabellen (ohne Foreign Keys)
-- 2) Foreign Keys per ALTER TABLE
-- 3) Beispieldaten

-- --------------------------------------------------
-- 1) TABELLEN (OHNE FOREIGN KEYS)
-- --------------------------------------------------

DROP TABLE if exists vorhanden cascade;
DROP TABLE if exists verkauft cascade;
DROP TABLE if exists angeleitet cascade;
DROP TABLE if exists beinhaltet cascade;
DROP TABLE if exists durchgefuehrt_von cascade;
DROP TABLE if exists Verkauf cascade;
DROP TABLE if exists Produkt cascade;
DROP TABLE if exists Rezept cascade;
DROP TABLE if exists Zutat cascade;
DROP TABLE if exists ZuliefererTelefonnummer cascade;
DROP TABLE if exists MitarbeiterTelefonnummer cascade;
DROP TABLE if exists Azubi cascade;
DROP TABLE if exists Schicht cascade;
DROP TABLE if exists Filiale cascade;
DROP TABLE if exists Mitarbeiter cascade;
DROP TABLE if exists Zulieferer cascade;
DROP TABLE if exists Status cascade;

CREATE TABLE IF NOT EXISTS Status
(
    StatusID integer,
    Name varchar,
    Description varchar,
    PRIMARY KEY (StatusID)
);

CREATE TABLE IF NOT EXISTS Zulieferer
(
    ZuliefererID integer,
    Name varchar,
    Adresse varchar,
    PRIMARY KEY (ZuliefererID)
);

CREATE TABLE IF NOT EXISTS Mitarbeiter
(
    MitarbeiterID integer,
    Gehalt integer,
    Adresse varchar,
    Geburtsdatum date,
    Nachname varchar,
    Vorname varchar,
    PRIMARY KEY (MitarbeiterID)
);

CREATE TABLE IF NOT EXISTS Filiale
(
    FilialeID integer,
    Adresse varchar,
    Name varchar,
    LeiterID integer,
    PRIMARY KEY (FilialeID)
);

CREATE TABLE IF NOT EXISTS Schicht
(
    SchichtID integer,
    Startzeit date,
    Endzeit date,
    FilialeID integer,
    PRIMARY KEY (SchichtID)
);

CREATE TABLE IF NOT EXISTS Azubi
(
    MitarbeiterID integer,
    Start date,
    VerantwortlicherID integer,
    PRIMARY KEY (MitarbeiterID)
);

CREATE TABLE IF NOT EXISTS MitarbeiterTelefonnummer
(
    Vorwahl integer,
    Telefonnummer integer,
    MitarbeiterID integer,
    PRIMARY KEY (Vorwahl, Telefonnummer)
);

CREATE TABLE IF NOT EXISTS ZuliefererTelefonnummer
(
    Vorwahl integer,
    Telefonnummer integer,
    ZuliefererID integer,
    PRIMARY KEY (Vorwahl, Telefonnummer)
);

CREATE TABLE IF NOT EXISTS Zutat
(
    ZutatID integer,
    ZuliefererID integer,
    Name varchar,
    Bestand integer,
    Einheit varchar,
    PRIMARY KEY (ZutatID, ZuliefererID),
    CONSTRAINT zutat_id_unique UNIQUE (ZutatID)
);

CREATE TABLE IF NOT EXISTS Rezept
(
    RezeptID integer,
    Name varchar,
    Anleitung text,
    Basis integer,
    PRIMARY KEY (RezeptID)
);

CREATE TABLE IF NOT EXISTS Produkt
(
    ProduktID integer,
    Name varchar,
    Preis integer,
    StatusID integer,
    Lagerbestand integer,
    PRIMARY KEY (ProduktID)
);

CREATE TABLE IF NOT EXISTS Verkauf
(
    VerkaufID integer,
    Datum date,
    Gesamtbetrag integer,
    FilialeID integer,
    MitarbeiterID integer,
    PRIMARY KEY (VerkaufID)
);

CREATE TABLE IF NOT EXISTS durchgefuehrt_von
(
    SchichtID integer,
    MitarbeiterID integer,
    PRIMARY KEY (SchichtID, MitarbeiterID)
);

CREATE TABLE IF NOT EXISTS beinhaltet
(
    RezeptID integer,
    ZutatID integer,
    PRIMARY KEY (RezeptID, ZutatID)
);

CREATE TABLE IF NOT EXISTS angeleitet
(
    ProduktID integer,
    RezeptID integer,
    PRIMARY KEY (ProduktID, RezeptID)
);

CREATE TABLE IF NOT EXISTS verkauft
(
    ProduktID integer,
    VerkaufID integer,
    Menge integer,
    PRIMARY KEY (ProduktID, VerkaufID)
);

CREATE TABLE IF NOT EXISTS vorhanden
(
    ProduktID integer,
    FilialeID integer,
    StatusID integer,
    Lagerbestand integer,
    PRIMARY KEY (ProduktID, FilialeID)
);

-- --------------------------------------------------
-- 2) ALTER TABLE: FOREIGN KEYS
-- --------------------------------------------------

ALTER TABLE Filiale
ADD FOREIGN KEY (LeiterID) REFERENCES Mitarbeiter
;

ALTER TABLE Schicht
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale
;

ALTER TABLE Azubi
ADD FOREIGN KEY (MitarbeiterID) REFERENCES Mitarbeiter,
ADD FOREIGN KEY (VerantwortlicherID) REFERENCES Mitarbeiter
;

ALTER TABLE MitarbeiterTelefonnummer
ADD FOREIGN KEY (MitarbeiterID) REFERENCES Mitarbeiter
;

ALTER TABLE ZuliefererTelefonnummer
ADD FOREIGN KEY (ZuliefererID) REFERENCES Zulieferer
;

ALTER TABLE Zutat
ADD FOREIGN KEY (ZuliefererID) REFERENCES Zulieferer
;

ALTER TABLE Rezept
ADD FOREIGN KEY (Basis) REFERENCES Rezept
;

ALTER TABLE Produkt
ADD FOREIGN KEY (StatusID) REFERENCES Status
;

ALTER TABLE Verkauf
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale,
ADD FOREIGN KEY (MitarbeiterID) REFERENCES Mitarbeiter
;

ALTER TABLE durchgefuehrt_von
ADD FOREIGN KEY (SchichtID) REFERENCES Schicht,
ADD FOREIGN KEY (MitarbeiterID) REFERENCES Mitarbeiter
;

ALTER TABLE beinhaltet
ADD FOREIGN KEY (RezeptID) REFERENCES Rezept,
ADD FOREIGN KEY (ZutatID) REFERENCES Zutat (ZutatID)
;

ALTER TABLE angeleitet
ADD FOREIGN KEY (ProduktID) REFERENCES Produkt,
ADD FOREIGN KEY (RezeptID) REFERENCES Rezept
;

ALTER TABLE verkauft
ADD FOREIGN KEY (ProduktID) REFERENCES Produkt,
ADD FOREIGN KEY (VerkaufID) REFERENCES Verkauf
;

ALTER TABLE vorhanden
ADD FOREIGN KEY (ProduktID) REFERENCES Produkt,
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale,
ADD FOREIGN KEY (StatusID) REFERENCES Status
;

-- --------------------------------------------------
-- 3) BEISPIELDATEN
-- --------------------------------------------------

INSERT INTO Status
VALUES (1, 'herstellbar', 'Produkt ist verfuegbar'),
       (2, 'nicht herstellbar', 'Zutaten fehlen')
;

INSERT INTO Zulieferer
VALUES (1, 'Muehle Sued', 'Industriestrasse 10'),
       (2, 'Bio Lieferant West', 'Marktplatz 5')
;

INSERT INTO Mitarbeiter
VALUES (1, 35000, 'Hauptstrasse 1', '2002-04-10', 'Meyer', 'Lena'),
       (2, 42000, 'Nebenstrasse 4', '1998-09-22', 'Schulz', 'Tom'),
       (3, 52000, 'Bahnhofstrasse 7', '1990-01-15', 'Klein', 'Sara'),
       (4, 61000, 'Ringweg 3', '1985-11-03', 'Becker', 'Jan')
;

INSERT INTO Filiale
VALUES (1, 'Markt 1, Stuttgart', 'Filiale Mitte', 3),
       (2, 'Allee 9, Esslingen', 'Filiale Nord', 4)
;

INSERT INTO Schicht
VALUES (1, '2026-04-16', '2026-04-16', 1),
       (2, '2026-04-17', '2026-04-17', 2)
;

INSERT INTO Azubi
VALUES (1, '2025-09-01', 3)
;

INSERT INTO MitarbeiterTelefonnummer
VALUES (49, 71110001, 1),
       (49, 71110002, 2),
       (49, 71110003, 3)
;

INSERT INTO ZuliefererTelefonnummer
VALUES (49, 73120001, 1),
       (49, 73120002, 2)
;

INSERT INTO Zutat
VALUES (1, 1, 'Mehl', 500, 'kg'),
       (2, 2, 'Hefe', 120, 'kg'),
       (3, 2, 'Salz', 80, 'kg')
;

INSERT INTO Rezept
VALUES (1, 'Standardbrot', 'Mischen, gehen lassen, backen', NULL),
       (2, 'Brot Variante Dinkel', 'Dinkelmehl verwenden, sonst identisch', 1)
;

INSERT INTO Produkt
VALUES (1, 'Bauernbrot', 4, 1, 40),
       (2, 'Dinkelbrot', 5, 1, 25)
;

INSERT INTO Verkauf
VALUES (1, '2026-04-16', 120, 1, 2),
       (2, '2026-04-17', 85, 2, 1)
;

INSERT INTO durchgefuehrt_von
VALUES (1, 2),
       (1, 3),
       (2, 1)
;

INSERT INTO beinhaltet
VALUES (1, 1),
       (1, 2),
       (1, 3),
       (2, 1),
       (2, 2)
;

INSERT INTO angeleitet
VALUES (1, 1),
       (2, 2)
;

INSERT INTO verkauft
VALUES (1, 1, 20),
       (2, 1, 8),
       (2, 2, 17)
;

INSERT INTO vorhanden
VALUES (1, 1, 1, 30),
       (2, 1, 1, 20),
       (1, 2, 2, 0),
       (2, 2, 1, 15)
;
