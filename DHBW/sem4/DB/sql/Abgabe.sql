-- Tabellenlöschung der Bäckerei

DROP TABLE IF EXISTS vorhanden CASCADE;
DROP TABLE IF EXISTS verkauft CASCADE;
DROP TABLE IF EXISTS Verkauf CASCADE;
DROP TABLE IF EXISTS Produkt CASCADE;
DROP TABLE IF EXISTS beinhaltet CASCADE;
DROP TABLE IF EXISTS Rezept CASCADE;
DROP TABLE IF EXISTS liefert CASCADE;
DROP TABLE IF EXISTS Zulieferer CASCADE;
DROP TABLE IF EXISTS Zutat CASCADE;
DROP TABLE IF EXISTS durchgefuehrt_von CASCADE;
DROP TABLE IF EXISTS Schicht CASCADE;
DROP TABLE IF EXISTS Azubi CASCADE;
DROP TABLE IF EXISTS Filiale CASCADE;
DROP TABLE IF EXISTS MitarbeiterTelefonnummer CASCADE;
DROP TABLE IF EXISTS ZuliefererTelefonnummer CASCADE;
DROP TABLE IF EXISTS Mitarbeiter CASCADE;
DROP TABLE IF EXISTS Status CASCADE;

-- Part 1

CREATE TABLE IF NOT EXISTS Filiale
(
    FilialeID integer,
    Adresse varchar(100),
    Name varchar(100),
    LeiterID integer,
    Aktiv boolean, --Boolean falls Filiale geschlossen wird
    PRIMARY KEY (FilialeID)
);
-- Aktiv könnte ein standard wert bekommen (True)

CREATE TABLE IF NOT EXISTS Schicht
(
    SchichtID integer,
    Startzeit timestamp,
    Endzeit timestamp,
    FilialeID integer,
    PRIMARY KEY (SchichtID)
);

CREATE TABLE IF NOT EXISTS Mitarbeiter
(
    MitarbeiterID integer,
    Gehalt integer, --Gehalt wird in Cent gespeichert
    Adresse varchar(100),
    Geburtsdatum date,
    Nachname varchar(50),
    Vorname varchar(50),
    PRIMARY KEY (MitarbeiterID)
);
-- Gehalt: ist es Monatlich oder Stundenlohn?

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

CREATE TABLE IF NOT EXISTS Zulieferer
(
    ZuliefererID integer,
    Name varchar(100),
    Adresse varchar(100),
    PRIMARY KEY (ZuliefererID)
);

CREATE TABLE IF NOT EXISTS Zutat 
(
    ZutatID integer,
    Name varchar(50),
    Bestand integer,
    Einheit varchar(20),
    PRIMARY KEY (ZutatID)
);

CREATE TABLE IF NOT EXISTS liefert
(
    ZuliefererID integer,
    ZutatID integer,
    FilialeID integer,
    PRIMARY KEY (ZuliefererID, ZutatID, FilialeID)
);

CREATE TABLE IF NOT EXISTS Rezept
(
    RezeptID integer,
    Name varchar(100),
    Anleitung varchar(255),
    Basis integer,
    PRIMARY KEY (RezeptID)
);
-- varchar(255) ist wahrscheinlich zu kurz für manche Anleitungen. 
-- Kannst hier sehr groß werden oder einen anderen Datentypen verwender

CREATE TABLE IF NOT EXISTS Produkt
(
    ProduktID integer,
    RezeptID integer,
    Name varchar(100),
    Preis integer, --Preis wird in Cent gespeichert
    PRIMARY KEY (ProduktID)
);

CREATE TABLE IF NOT EXISTS Verkauf
(
    VerkaufID integer, 
    FilialeID integer,
    MitarbeiterID integer,
    Datum date,
    Gesamtbetrag integer, --Gesamtbetrag wird in Cent gespeichert
    PRIMARY KEY (VerkaufID)
);
-- Gesamtbetrag wird doch ausgerechnet. Ich glaube das wir das weglassen können.

CREATE TABLE IF NOT EXISTS Status
(
    StatusID integer, 
    Name varchar(50),
    Beschreibung varchar(255),
    PRIMARY KEY (StatusID)
);
-- Hier passt varchar(255)
-- Kannst du mit Beispielen unten belegen

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
-- was genau wollen wir mit Status ausdrücken?


-- Part 2

ALTER TABLE Mitarbeiter
ADD CONSTRAINT check_Gehalt CHECK (Gehalt > 0);

ALTER TABLE Filiale
ADD FOREIGN KEY (LeiterID) REFERENCES Mitarbeiter(MitarbeiterID) ON DELETE SET NULL;

ALTER TABLE Filiale
ALTER COLUMN Adresse SET NOT NULL,
ALTER COLUMN Name SET NOT NULL,
ALTER COLUMN Aktiv SET NOT NULL;

ALTER TABLE Azubi
ADD FOREIGN KEY (VerantwortlicherID) REFERENCES Mitarbeiter(MitarbeiterID) ON DELETE SET NULL,
ADD FOREIGN KEY (MitarbeiterID) REFERENCES Mitarbeiter(MitarbeiterID) ON DELETE CASCADE;

ALTER TABLE Azubi
ALTER COLUMN Start SET NOT NULL;

ALTER TABLE Rezept
ADD FOREIGN KEY (Basis) REFERENCES Rezept(RezeptID) ON DELETE CASCADE; --Rezept-Varianten sind nur eine Abweichung vom Basisrezept, deshalb sollen diese gelöscht werden falls Basisrezept gelöscht wird

ALTER TABLE Rezept
ALTER COLUMN Name SET NOT NULL;

ALTER TABLE Schicht
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale(FilialeID) ON DELETE RESTRICT, --Filialen sollen grunsätzlich nicht gelöscht werden können, da Daten wie Verkaufszahlen auch nach Schließen einer Filiale einsehbar sein sollen
ADD CONSTRAINT check_Zeit CHECK (Endzeit >= Startzeit);

ALTER TABLE Schicht
ALTER COLUMN Startzeit SET NOT NULL,
ALTER COLUMN Endzeit SET NOT NULL,
ALTER COLUMN FilialeID SET NOT NULL;

ALTER TABLE MitarbeiterTelefonnummer
ADD FOREIGN KEY (MitarbeiterID) REFERENCES Mitarbeiter(MitarbeiterID) ON DELETE CASCADE,
ADD CONSTRAINT check_mitarbeiter_vorwahl CHECK (Vorwahl > 0),
ADD CONSTRAINT check_mitarbeiter_nummer CHECK (Telefonnummer > 0);
-- gibt es bessere Checks für Telvonummern?

ALTER TABLE MitarbeiterTelefonnummer
ALTER COLUMN MitarbeiterID SET NOT NULL;

ALTER TABLE ZuliefererTelefonnummer
ADD FOREIGN KEY (ZuliefererID) REFERENCES Zulieferer(ZuliefererID) ON DELETE CASCADE,
ADD CONSTRAINT check_zulieferer_vorwahl CHECK (Vorwahl > 0),
ADD CONSTRAINT check_zulieferer_nummer CHECK (Telefonnummer > 0);

ALTER TABLE ZuliefererTelefonnummer
ALTER COLUMN ZuliefererID SET NOT NULL;

ALTER TABLE Produkt
ADD FOREIGN KEY (RezeptID) REFERENCES Rezept(RezeptID) ON DELETE RESTRICT,
ADD CONSTRAINT check_preis CHECK (Preis >= 0);

ALTER TABLE Produkt
ALTER COLUMN Name SET NOT NULL,
ALTER COLUMN RezeptID SET NOT NULL,
ALTER COLUMN Preis SET NOT NULL;

ALTER TABLE Verkauf
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale(FilialeID) ON DELETE RESTRICT,
ADD FOREIGN KEY (MitarbeiterID) REFERENCES Mitarbeiter(MitarbeiterID) ON DELETE SET NULL,
ADD CONSTRAINT check_Gesamtbetrag CHECK (Gesamtbetrag > 0);

ALTER TABLE Verkauf
ALTER COLUMN Datum SET NOT NULL,
ALTER COLUMN Gesamtbetrag SET NOT NULL,
ALTER COLUMN FilialeID SET NOT NULL;

ALTER TABLE durchgefuehrt_von
ADD FOREIGN KEY (SchichtID) REFERENCES Schicht(SchichtID) ON DELETE CASCADE,
ADD FOREIGN KEY (MitarbeiterID) REFERENCES Mitarbeiter(MitarbeiterID) ON DELETE CASCADE;

ALTER TABLE beinhaltet
ADD FOREIGN KEY (RezeptID) REFERENCES Rezept(RezeptID) ON DELETE CASCADE,
ADD FOREIGN KEY (ZutatID) REFERENCES Zutat(ZutatID) ON DELETE CASCADE;

ALTER TABLE verkauft
ADD FOREIGN KEY (ProduktID) REFERENCES Produkt(ProduktID) ON DELETE CASCADE,
ADD FOREIGN KEY (VerkaufID) REFERENCES Verkauf(VerkaufID) ON DELETE CASCADE,
ADD CONSTRAINT check_Menge CHECK (Menge > 0);

ALTER TABLE verkauft
ALTER COLUMN Menge SET NOT NULL;

ALTER TABLE vorhanden
ADD FOREIGN KEY (ProduktID) REFERENCES Produkt(ProduktID) ON DELETE CASCADE,
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale(FilialeID) ON DELETE RESTRICT,
ADD FOREIGN KEY (StatusID) REFERENCES Status(StatusID) ON DELETE SET NULL,
ADD CONSTRAINT check_Lagerbestand CHECK (Lagerbestand >= 0);

ALTER TABLE vorhanden
ALTER COLUMN Lagerbestand SET NOT NULL;

ALTER TABLE liefert
ADD FOREIGN KEY (ZuliefererID) REFERENCES Zulieferer(ZuliefererID) ON DELETE CASCADE,
ADD FOREIGN KEY (ZutatID) REFERENCES Zutat(ZutatID) ON DELETE CASCADE,
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale(FilialeID) ON DELETE RESTRICT;

ALTER TABLE Zutat
ADD CONSTRAINT check_Bestand CHECK (Bestand >= 0);

ALTER TABLE Zutat
ALTER COLUMN Name SET NOT NULL,
ALTER COLUMN Bestand SET NOT NULL,
ALTER COLUMN Einheit SET NOT NULL;

ALTER TABLE Status
ALTER COLUMN Name SET NOT NULL,
ALTER COLUMN Beschreibung SET NOT NULL;

ALTER TABLE Zulieferer
ALTER COLUMN Name SET NOT NULL,
ALTER COLUMN Adresse SET NOT NULL;


-- Part 3

-- =========================
-- STATUS
-- =========================
INSERT INTO Status VALUES
(1, 'verfuegbar', 'Produkt ist in der Filiale verfuegbar'),
(2, 'nicht verfuegbar', 'Produkt ist aktuell nicht verfuegbar');
-- update sonderzeichen wie 'ue' zu 'ü'

-- =========================
-- MITARBEITER
-- =========================
INSERT INTO Mitarbeiter VALUES
(1, 380000, 'Nagold, Marktstrasse 3', '1987-04-12', 'Meier', 'Laura'),
(2, 360000, 'Herrenberg, Bahnhofstrasse 8', '1985-09-03', 'Schulz', 'Tim'),
(3, 290000, 'Nagold, Iselshaeuser Strasse 15', '1998-02-17', 'Becker', 'Anna'),
(4, 120000, 'Nagold, Gartenweg 6', '2005-11-21', 'Klein', 'Max');

-- =========================
-- FILIALE
-- =========================
INSERT INTO Filiale VALUES
(1, 'Marktplatz 1, Nagold', 'Filiale Nagold Zentrum', 1, true),
(2, 'Bahnhofstrasse 5, Herrenberg', 'Filiale Herrenberg Bahnhof', 2, true);

-- =========================
-- AZUBI
-- =========================
INSERT INTO Azubi VALUES
(4, '2023-09-01', 1);

-- =========================
-- SCHICHT
-- =========================
INSERT INTO Schicht VALUES
(1, '2024-01-10 06:00:00', '2024-01-10 14:00:00', 1),
(2, '2024-01-10 05:30:00', '2024-01-10 13:30:00', 2),
(3, '2024-01-10 14:00:00', '2024-01-10 20:00:00', 1);

-- =========================
-- DURCHGEFUEHRT_VON
-- =========================
INSERT INTO durchgefuehrt_von VALUES
(1, 1),
(1, 3),
(2, 2),
(3, 4);

-- =========================
-- ZUTAT
-- =========================
INSERT INTO Zutat VALUES
(1, 'Mehl', 250, 'kg'),
(2, 'Butter', 90, 'kg'),
(3, 'Zucker', 60, 'kg'),
(4, 'Hefe', 35, 'kg'),
(5, 'Schokolade', 40, 'kg'),
(6, 'Dinkelmehl', 70, 'kg');

-- =========================
-- ZULIEFERER
-- =========================
INSERT INTO Zulieferer VALUES
(1, 'Muehle Sued', 'Industriestrasse 10, Nagold'),
(2, 'Milchhof Schwarzwald', 'Dorfstrasse 5, Freudenstadt'),
(3, 'Cacao Import GmbH', 'Hafenstrasse 8, Karlsruhe');

-- =========================
-- LIEFERT
-- jetzt mit FilialeID
-- =========================
INSERT INTO liefert VALUES
(1, 1, 1), -- Muehle Sued liefert Mehl an Filiale 1
(1, 6, 1), -- Muehle Sued liefert Dinkelmehl an Filiale 1
(2, 2, 1), -- Milchhof liefert Butter an Filiale 1
(2, 4, 1), -- Milchhof liefert Hefe an Filiale 1
(3, 5, 1), -- Cacao liefert Schokolade an Filiale 1
(1, 1, 2), -- Muehle Sued liefert Mehl an Filiale 2
(2, 2, 2), -- Milchhof liefert Butter an Filiale 2
(2, 4, 2), -- Milchhof liefert Hefe an Filiale 2
(3, 5, 2); -- Cacao liefert Schokolade an Filiale 2

-- =========================
-- REZEPT
-- =========================
INSERT INTO Rezept VALUES
(1, 'Grundteig', 'Teig herstellen und ruhen lassen', NULL),
(2, 'Buttercroissant', 'Teig tourieren, formen und backen', 1),
(3, 'Schoko-Croissant', 'Schokolade einrollen und backen', 2),
(4, 'Dinkelbrot', 'Dinkelteig herstellen und backen', 1);

-- =========================
-- BEINHALTET
-- =========================
INSERT INTO beinhaltet VALUES
(1, 1), -- Grundteig -> Mehl
(1, 4), -- Grundteig -> Hefe
(2, 1), -- Buttercroissant -> Mehl
(2, 2), -- Buttercroissant -> Butter
(2, 4), -- Buttercroissant -> Hefe
(3, 1), -- Schoko-Croissant -> Mehl
(3, 2), -- Schoko-Croissant -> Butter
(3, 4), -- Schoko-Croissant -> Hefe
(3, 5), -- Schoko-Croissant -> Schokolade
(4, 6), -- Dinkelbrot -> Dinkelmehl
(4, 4); -- Dinkelbrot -> Hefe

-- =========================
-- PRODUKT
-- Preis in Cent
-- =========================
INSERT INTO Produkt VALUES
(1, 2, 'Buttercroissant', 180),
(2, 3, 'Schoko-Croissant', 230),
(3, 4, 'Dinkelbrot', 450);

-- =========================
-- VERKAUF
-- Gesamtbetrag in Cent
-- =========================
-- Verkauf 1:
-- 4 Buttercroissants = 4 * 180 = 720
-- 2 Schoko-Croissants = 2 * 230 = 460
-- Gesamt = 1180
INSERT INTO Verkauf VALUES
(1, 1, 3, '2024-01-10', 1180);

-- Verkauf 2:
-- 3 Dinkelbrote = 3 * 450 = 1350
INSERT INTO Verkauf VALUES
(2, 2, 2, '2024-01-10', 1350);

-- Verkauf 3:
-- 2 Buttercroissants = 360
-- 1 Dinkelbrot = 450
-- Gesamt = 810
INSERT INTO Verkauf VALUES
(3, 1, 1, '2024-01-10', 810);

-- =========================
-- VERKAUFT
-- =========================
INSERT INTO verkauft VALUES
(1, 1, 4),
(2, 1, 2),
(3, 2, 3),
(1, 3, 2),
(3, 3, 1);

-- =========================
-- VORHANDEN
-- =========================
INSERT INTO vorhanden VALUES
(1, 1, 1, 35), -- Buttercroissant in Nagold verfuegbar
(2, 1, 1, 18), -- Schoko-Croissant in Nagold verfuegbar
(3, 1, 1, 12), -- Dinkelbrot in Nagold verfuegbar
(1, 2, 2, 0),  -- Buttercroissant in Herrenberg aktuell nicht verfuegbar
(2, 2, 1, 10), -- Schoko-Croissant in Herrenberg verfuegbar
(3, 2, 1, 8);  -- Dinkelbrot in Herrenberg verfuegbar

-- =========================
-- MITARBEITERTELEFONNUMMER
-- =========================
INSERT INTO MitarbeiterTelefonnummer VALUES
(49, 711123456, 1),
(49, 711234567, 2),
(49, 745212345, 3),
(49, 745223456, 4);

-- =========================
-- ZULIEFERERTELEFONNUMMER
-- =========================
INSERT INTO ZuliefererTelefonnummer VALUES
(49, 731111111, 1),
(49, 744122222, 2),
(49, 721333333, 3);

