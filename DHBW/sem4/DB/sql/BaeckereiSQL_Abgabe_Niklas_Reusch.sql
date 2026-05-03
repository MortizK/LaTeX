-- Tabellenloeschung der Baeckerei

DROP TABLE IF EXISTS ProduktRezeptFiliale CASCADE;
DROP TABLE IF EXISTS vorhanden CASCADE;
DROP TABLE IF EXISTS verkauft CASCADE;
DROP TABLE IF EXISTS Verkauf CASCADE;
DROP TABLE IF EXISTS Produkt CASCADE;
DROP TABLE IF EXISTS beinhaltet CASCADE;
DROP TABLE IF EXISTS Rezept CASCADE;
DROP TABLE IF EXISTS liefert CASCADE;
DROP TABLE IF EXISTS ZutatBestand CASCADE;
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
    Aktiv boolean default true, --Boolean falls Filiale geschlossen wird (Standardmaeßig wahr)
    PRIMARY KEY (FilialeID)
);

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
    Gehalt integer, --Gehalt wird in Cent gespeichert (Stundenlohn)
    Adresse varchar(100),
    Geburtsdatum date,
    Nachname varchar(50),
    Vorname varchar(50),
    PRIMARY KEY (MitarbeiterID)
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
    Vorwahl varchar(5), --Telefonnummer und Vorwahl werden als Strings gespeichert damit Pluszeichen und fuehrende Nullen gespeichert werden koennen
    Telefonnummer varchar(15),
    MitarbeiterID integer,
    PRIMARY KEY (Vorwahl, Telefonnummer)
);

CREATE TABLE IF NOT EXISTS ZuliefererTelefonnummer
(
    Vorwahl varchar(5), 
    Telefonnummer varchar(15), 
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
    Einheit varchar(20),
    PRIMARY KEY (ZutatID)
);

CREATE TABLE IF NOT EXISTS ZutatBestand
(
    ZutatID integer,
    FilialeID integer,
    Bestand integer,
    PRIMARY KEY (ZutatID, FilialeID)
);

CREATE TABLE IF NOT EXISTS liefert
(
    ZuliefererID integer,
    ZutatID integer,
    FilialeID integer,
    Preis integer, --Festpreis in Cent
    BestellMenge integer, --Mindestbestellmenge
    PRIMARY KEY (ZuliefererID, ZutatID, FilialeID)
);

CREATE TABLE IF NOT EXISTS Rezept
(
    RezeptID integer,
    Name varchar(100),
    Anleitung varchar, --Keine Begrenzung, da Anleitung beliebig groß werden koennen soll
    Basis integer,
    PRIMARY KEY (RezeptID)
);

CREATE TABLE IF NOT EXISTS Produkt
(
    ProduktID integer,
    Name varchar(100),
    Preis integer, --Preis wird in Cent gespeichert
    PRIMARY KEY (ProduktID)
);

CREATE TABLE IF NOT EXISTS ProduktRezeptFiliale 
(
    ProduktID integer,
    FilialeID integer,
    RezeptID integer,
    PRIMARY KEY (ProduktID, FilialeID) -- Bedeutet: ein Produkt hat pro Filiale genau ein Rezept
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

CREATE TABLE IF NOT EXISTS Status
(
    StatusID integer, 
    Name varchar(50),
    Beschreibung varchar(255),
    PRIMARY KEY (StatusID)
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
    Menge integer, --Benötigte Menge der Zutat
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
    StatusID integer, --Status als Zusatzinformation wie beispielsweise "Produkt ist in ein paar Tagen wieder verfuegbar"
    Lagerbestand integer,
    PRIMARY KEY (ProduktID, FilialeID)
);


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
ADD FOREIGN KEY (Basis) REFERENCES Rezept(RezeptID) ON DELETE CASCADE; --Rezept-Varianten sind nur eine Abweichung vom Basisrezept, deshalb sollen diese geloescht werden falls Basisrezept geloescht wird

ALTER TABLE Rezept
ALTER COLUMN Name SET NOT NULL;

ALTER TABLE Schicht
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale(FilialeID) ON DELETE RESTRICT, --Filialen sollen grunsaetzlich nicht geloescht werden können, da Daten wie Verkaufszahlen auch nach Schließen einer Filiale einsehbar sein sollen
ADD CONSTRAINT check_Zeit CHECK (Endzeit > Startzeit);

ALTER TABLE Schicht
ALTER COLUMN Startzeit SET NOT NULL,
ALTER COLUMN Endzeit SET NOT NULL,
ALTER COLUMN FilialeID SET NOT NULL;

ALTER TABLE MitarbeiterTelefonnummer
ADD FOREIGN KEY (MitarbeiterID) REFERENCES Mitarbeiter(MitarbeiterID) ON DELETE CASCADE,
ADD CONSTRAINT check_mitarbeiter_vorwahl CHECK (Vorwahl ~ '^\+?[0-9]+$'),
ADD CONSTRAINT check_mitarbeiter_nummer CHECK (Telefonnummer ~ '^[0-9]+$');

ALTER TABLE MitarbeiterTelefonnummer
ALTER COLUMN MitarbeiterID SET NOT NULL;

ALTER TABLE ZuliefererTelefonnummer
ADD FOREIGN KEY (ZuliefererID) REFERENCES Zulieferer(ZuliefererID) ON DELETE CASCADE,
ADD CONSTRAINT check_zulieferer_vorwahl CHECK (Vorwahl ~ '^\+?[0-9]+$'),
ADD CONSTRAINT check_zulieferer_nummer CHECK (Telefonnummer ~ '^[0-9]+$');

ALTER TABLE ZuliefererTelefonnummer
ALTER COLUMN ZuliefererID SET NOT NULL;

ALTER TABLE Produkt
ADD CONSTRAINT check_preis CHECK (Preis >= 0);

ALTER TABLE Produkt
ALTER COLUMN Name SET NOT NULL,
ALTER COLUMN Preis SET NOT NULL;

ALTER TABLE ProduktRezeptFiliale
ADD FOREIGN KEY (ProduktID) REFERENCES Produkt(ProduktID) ON DELETE CASCADE,
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale(FilialeID) ON DELETE RESTRICT,
ADD FOREIGN KEY (RezeptID) REFERENCES Rezept(RezeptID) ON DELETE RESTRICT;

ALTER TABLE ProduktRezeptFiliale
ALTER COLUMN ProduktID SET NOT NULL,
ALTER COLUMN FilialeID SET NOT NULL,
ALTER COLUMN RezeptID SET NOT NULL;

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
ADD FOREIGN KEY (ZutatID) REFERENCES Zutat(ZutatID) ON DELETE CASCADE,
ADD CONSTRAINT check_Menge_beinhaltet CHECK (Menge > 0);

ALTER TABLE beinhaltet
ALTER COLUMN Menge SET NOT NULL;

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
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale(FilialeID) ON DELETE RESTRICT,
ADD CONSTRAINT check_Preis CHECK (Preis > 0),
ADD CONSTRAINT check_BestellMenge CHECK (BestellMenge > 0);

ALTER TABLE liefert
ALTER COLUMN Preis SET NOT NULL,
ALTER COLUMN BestellMenge SET NOT NULL;

ALTER TABLE Zutat
ALTER COLUMN Name SET NOT NULL,
ALTER COLUMN Einheit SET NOT NULL;

ALTER TABLE ZutatBestand
ADD FOREIGN KEY (ZutatID) REFERENCES Zutat(ZutatID) ON DELETE CASCADE,
ADD FOREIGN KEY (FilialeID) REFERENCES Filiale(FilialeID) ON DELETE RESTRICT,
ADD CONSTRAINT check_ZutatBestand CHECK (Bestand >= 0);

ALTER TABLE ZutatBestand
ALTER COLUMN Bestand SET NOT NULL;

ALTER TABLE Status
ALTER COLUMN Name SET NOT NULL,
ALTER COLUMN Beschreibung SET NOT NULL;

ALTER TABLE Zulieferer
ALTER COLUMN Name SET NOT NULL,
ALTER COLUMN Adresse SET NOT NULL;


-- Part 3

INSERT INTO Status VALUES
(1, 'verfuegbar', 'Produkt ist in der Filiale verfuegbar'),
(2, 'nicht verfuegbar', 'Produkt ist aktuell nicht verfuegbar');

INSERT INTO Mitarbeiter VALUES
(1, 380000, 'Nagold, Marktstrasse 3', '1987-04-12', 'Meier', 'Laura'),
(2, 360000, 'Herrenberg, Bahnhofstrasse 8', '1985-09-03', 'Schulz', 'Tim'),
(3, 290000, 'Nagold, Iselshaeuser Strasse 15', '1998-02-17', 'Becker', 'Anna'),
(4, 120000, 'Nagold, Gartenweg 6', '2005-11-21', 'Klein', 'Max'),
(5, 300000, 'Calw, Hauptstrasse 2', '1995-06-10', 'Weber', 'Lukas'),
(6, 310000, 'Nagold, Waldstrasse 9', '1992-03-18', 'Fischer', 'Eva');

INSERT INTO Filiale VALUES
(1, 'Marktplatz 1, Nagold', 'Filiale Nagold Zentrum', 1, true),
(2, 'Bahnhofstrasse 5, Herrenberg', 'Filiale Herrenberg Bahnhof', 2, true);

INSERT INTO Azubi VALUES
(4, '2023-09-01', 1);

INSERT INTO Schicht VALUES
(1, '2024-01-10 06:00:00', '2024-01-10 14:00:00', 1),
(2, '2024-01-10 05:30:00', '2024-01-10 13:30:00', 2),
(3, '2024-01-10 14:00:00', '2024-01-10 20:00:00', 1),
(4, '2024-01-11 06:00:00', '2024-01-11 14:00:00', 1),
(5, '2024-01-11 14:00:00', '2024-01-11 20:00:00', 2);

INSERT INTO durchgefuehrt_von VALUES
(1, 1),
(1, 3),
(2, 2),
(3, 4),
(4, 5),
(5, 6);

INSERT INTO Zutat VALUES
(1, 'Mehl', 'kg'),
(2, 'Butter', 'kg'),
(3, 'Zucker', 'kg'),
(4, 'Hefe', 'kg'),
(5, 'Schokolade', 'kg'),
(6, 'Dinkelmehl', 'kg');

INSERT INTO Zulieferer VALUES
(1, 'Muehle Sued', 'Industriestrasse 10, Nagold'),
(2, 'Milchhof Schwarzwald', 'Dorfstrasse 5, Freudenstadt'),
(3, 'Cacao Import GmbH', 'Hafenstrasse 8, Karlsruhe');

INSERT INTO ZutatBestand VALUES
(1, 1, 250),
(2, 1, 90),
(3, 1, 60),
(4, 1, 35),
(5, 1, 40),
(6, 1, 70),
(1, 2, 200),
(2, 2, 80),
(3, 2, 50),
(4, 2, 30),
(5, 2, 35),
(6, 2, 60);

INSERT INTO liefert VALUES
(1, 1, 1, 5000, 100),
(1, 6, 1, 6000, 80),
(2, 2, 1, 8500, 50),
(2, 4, 1, 3000, 20),
(3, 5, 1, 12000, 25),
(1, 1, 2, 4900, 100),
(2, 2, 2, 8400, 50),
(2, 4, 2, 2900, 20),
(3, 5, 2, 11900, 25);

INSERT INTO Rezept VALUES
(1, 'Grundteig', 'Teig herstellen und ruhen lassen', NULL),
(2, 'Buttercroissant', 'Teig tourieren, formen und backen', 1),
(3, 'Schoko-Croissant', 'Schokolade einrollen und backen', 2),
(4, 'Dinkelbrot', 'Dinkelteig herstellen und backen', 1),
(5, 'Zimtcroissant', 'Zimt einarbeiten und backen', 2),
(6, 'Baguette', 'Teig formen und backen', 1);

INSERT INTO beinhaltet VALUES
(1, 1, 500),
(1, 4, 100),
(2, 1, 350),
(2, 2, 200),
(2, 4, 50),
(3, 1, 350),
(3, 2, 150),
(3, 4, 50),
(3, 5, 100),
(4, 6, 600),
(4, 4, 80),
(5, 3, 100),
(6, 1, 400),
(6, 4, 50);

INSERT INTO Produkt VALUES
(1, 'Buttercroissant', 180),
(2, 'Schoko-Croissant', 230),
(3, 'Dinkelbrot', 450),
(4, 'Zimtcroissant', 250),
(5, 'Baguette', 200);

INSERT INTO ProduktRezeptFiliale VALUES
(1, 1, 2),
(1, 2, 2),
(2, 1, 3),
(2, 2, 3),
(3, 1, 4),
(3, 2, 4),
(4, 1, 5),
(4, 2, 5),
(5, 1, 6),
(5, 2, 6);

INSERT INTO Verkauf VALUES
(1, 1, 3, '2024-01-10', 1180),
(2, 2, 2, '2024-01-10', 1350),
(3, 1, 1, '2024-01-10', 810),
(4, 1, 3, '2024-01-11', 950),
(5, 2, 2, '2024-01-11', 1120),
(6, 1, 1, '2024-01-11', 760);

INSERT INTO verkauft VALUES
(1, 1, 4),
(2, 1, 2),
(3, 2, 3),
(1, 3, 2),
(3, 3, 1),
(4, 4, 3),
(5, 4, 2),
(1, 5, 5),
(2, 6, 2);

INSERT INTO vorhanden VALUES
(1, 1, 1, 35),
(2, 1, 1, 18),
(3, 1, 1, 12),
(1, 2, 2, 0),
(2, 2, 1, 10),
(3, 2, 1, 8),
(4, 1, 1, 20),
(5, 1, 1, 25),
(4, 2, 2, 0),
(5, 2, 1, 15);

INSERT INTO MitarbeiterTelefonnummer VALUES
('+49', '711123456', 1),
('+49', '711234567', 2),
('+49', '745212345', 3),
('+49', '45223456', 4),
('+49', '712345678', 5),
('+49', '713456789', 6);

INSERT INTO ZuliefererTelefonnummer VALUES
('+49', '731111111', 1),
('+49', '744122222', 2),
('+49', '721333333', 3);

