-- View: Mitarbeiter mit Kontaktinformationen pro Filiale
-- FIXED: Verwendung von DISTINCT ON um Duplikate durch mehrere Schichten zu vermeiden
CREATE OR REPLACE VIEW v_mitarbeiter_kontakt AS
SELECT DISTINCT ON (m.MitarbeiterID, f.FilialeID)
    m.MitarbeiterID,
    m.Vorname,
    m.Nachname,
    m.Geburtsdatum,
    ROUND(m.Gehalt::DECIMAL / 100, 2) AS GehaltEuro,
    m.Adresse,
    f.FilialeID,
    f.Name AS FilialeName,
    mt.Vorwahl,
    mt.Telefonnummer
FROM Mitarbeiter m
LEFT JOIN durchgefuehrt_von dv ON m.MitarbeiterID = dv.MitarbeiterID
LEFT JOIN Schicht sc ON dv.SchichtID = sc.SchichtID
LEFT JOIN Filiale f ON sc.FilialeID = f.FilialeID
LEFT JOIN MitarbeiterTelefonnummer mt ON m.MitarbeiterID = mt.MitarbeiterID
ORDER BY m.MitarbeiterID, f.FilialeID, f.FilialeID, m.Nachname, m.Vorname;

-- View: Schicht-Plan pro Filiale mit Mitarbeitern
CREATE OR REPLACE VIEW v_schichtplan AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    s.SchichtID,
    s.Startzeit,
    s.Endzeit,
    (s.Endzeit - s.Startzeit) AS Dauer,
    m.MitarbeiterID,
    m.Vorname,
    m.Nachname
FROM Filiale f
JOIN Schicht s ON f.FilialeID = s.FilialeID
JOIN durchgefuehrt_von dv ON s.SchichtID = dv.SchichtID
JOIN Mitarbeiter m ON dv.MitarbeiterID = m.MitarbeiterID
ORDER BY f.FilialeID, s.Startzeit, m.Nachname;

-- View: Lagerbestände pro Filiale mit Zutatennamen
CREATE OR REPLACE VIEW v_lagerbestaende AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    z.ZutatID,
    z.Name AS ZutatName,
    z.Einheit,
    zb.Bestand
FROM Filiale f
JOIN ZutatBestand zb ON f.FilialeID = zb.FilialeID
JOIN Zutat z ON zb.ZutatID = z.ZutatID
ORDER BY f.FilialeID, z.Name;

-- View: Produktverfügbarkeit pro Filiale
CREATE OR REPLACE VIEW v_produktverfuegbarkeit AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    p.ProduktID,
    p.Name AS ProduktName,
    ROUND(p.Preis::DECIMAL / 100, 2) AS PreisEuro,
    v.Lagerbestand,
    st.Name AS Status,
    st.Beschreibung
FROM Filiale f
JOIN vorhanden v ON f.FilialeID = v.FilialeID
JOIN Produkt p ON v.ProduktID = p.ProduktID
JOIN Status st ON v.StatusID = st.StatusID
ORDER BY f.FilialeID, p.Name;

-- View: Rezept-Details mit Zutaten und Mengen
CREATE OR REPLACE VIEW v_rezept_details AS
SELECT 
    r.RezeptID,
    r.Name AS RezeptName,
    r.Anleitung,
    r.Basis AS BasisRezeptID,
    rb.Name AS BasisRezeptName,
    b.ZutatID,
    z.Name AS ZutatName,
    b.Menge,
    z.Einheit
FROM Rezept r
LEFT JOIN Rezept rb ON r.Basis = rb.RezeptID
LEFT JOIN beinhaltet b ON r.RezeptID = b.RezeptID
LEFT JOIN Zutat z ON b.ZutatID = z.ZutatID
ORDER BY r.RezeptID, z.Name;

-- View: Zulieferer mit Kontaktinformationen
CREATE OR REPLACE VIEW v_zulieferer_kontakt AS
SELECT 
    z.ZuliefererID,
    z.Name AS ZuliefererName,
    z.Adresse,
    STRING_AGG(CONCAT(zt.Vorwahl, zt.Telefonnummer), ', ') AS Telefonnummern
FROM Zulieferer z
LEFT JOIN ZuliefererTelefonnummer zt ON z.ZuliefererID = zt.ZuliefererID
GROUP BY z.ZuliefererID
ORDER BY z.Name;

-- View: Lieferverhältnisse pro Filiale
CREATE OR REPLACE VIEW v_lieferverhaeltnisse AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    z.ZuliefererID,
    z.Name AS ZuliefererName,
    z.Adresse AS ZuliefererAdresse,
    zta.ZutatID,
    zta.Name AS ZutatName,
    l.BestellMenge,
    zta.Einheit,
    ROUND(l.Preis::DECIMAL / 100, 2) AS PreisEuro
FROM Filiale f
JOIN liefert l ON f.FilialeID = l.FilialeID
JOIN Zulieferer z ON l.ZuliefererID = z.ZuliefererID
JOIN Zutat zta ON l.ZutatID = zta.ZutatID
ORDER BY f.FilialeID, z.Name, zta.Name;

-- View: Filialleiter-Dashboard für eine spezifische Filiale
-- Syntax aus https://www.postgresql.org/docs/current/queries-with.html
CREATE OR REPLACE VIEW v_filialleiter_dashboard AS
WITH mitarbeiter_count AS (
    SELECT s.FilialeID, COUNT(DISTINCT m.MitarbeiterID) as cnt
    FROM Schicht s
    LEFT JOIN durchgefuehrt_von dv ON s.SchichtID = dv.SchichtID
    LEFT JOIN Mitarbeiter m ON dv.MitarbeiterID = m.MitarbeiterID
    GROUP BY s.FilialeID
),
schicht_count AS (
    SELECT FilialeID, COUNT(DISTINCT SchichtID) as cnt
    FROM Schicht
    GROUP BY FilialeID
),
produkt_count AS (
    SELECT FilialeID, COUNT(ProduktID) as cnt
    FROM vorhanden
    GROUP BY FilialeID
),
verkauf_sum AS (
    SELECT f.FilialeID, COUNT(vk.VerkaufID) as anzahl, SUM(vk.Gesamtbetrag) as summe
    FROM Filiale f
    LEFT JOIN Verkauf vk ON f.FilialeID = vk.FilialeID
    GROUP BY f.FilialeID
)
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    f.Adresse,
    COALESCE(mc.cnt, 0) AS MitarbeiterAnzahl,
    COALESCE(sc.cnt, 0) AS SchichtAnzahl,
    COALESCE(pc.cnt, 0) AS ProdukteAnzahl,
    ROUND(COALESCE(vs.summe, 0)::DECIMAL / 100, 2) AS GesamtUmsatzEuro,
    COALESCE(vs.anzahl, 0) AS VerkaufsanzahlGesamt
FROM Filiale f
LEFT JOIN mitarbeiter_count mc ON f.FilialeID = mc.FilialeID
LEFT JOIN schicht_count sc ON f.FilialeID = sc.FilialeID
LEFT JOIN produkt_count pc ON f.FilialeID = pc.FilialeID
LEFT JOIN verkauf_sum vs ON f.FilialeID = vs.FilialeID;

-- View: Mitarbeiter-Übersicht für eine Filiale
CREATE OR REPLACE VIEW v_mitarbeiter_filiale AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    m.MitarbeiterID,
    m.Vorname,
    m.Nachname,
    m.Geburtsdatum,
    ROUND(m.Gehalt::DECIMAL / 100, 2) AS GehaltEuro,
    STRING_AGG(CONCAT(mt.Vorwahl, mt.Telefonnummer), ', ') AS Telefonnummern
FROM Filiale f
JOIN Schicht s ON f.FilialeID = s.FilialeID
JOIN durchgefuehrt_von dv ON s.SchichtID = dv.SchichtID
JOIN Mitarbeiter m ON dv.MitarbeiterID = m.MitarbeiterID
LEFT JOIN MitarbeiterTelefonnummer mt ON m.MitarbeiterID = mt.MitarbeiterID
GROUP BY f.FilialeID, f.Name, m.MitarbeiterID, m.Vorname, m.Nachname, 
         m.Geburtsdatum, m.Gehalt
ORDER BY f.FilialeID, m.Nachname;

-- View: Eigentümer-Übersicht (alle Filialen im Überblick - optimiert mit GROUP BY statt Subqueries)
-- FIXED: COUNT(DISTINCT mi.MitarbeiterID) um Mehrfachzählung durch mehrere Schichten zu vermeiden
CREATE OR REPLACE VIEW v_eigentuemer_uebersicht AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    f.Adresse,
    f.Aktiv,
    m.Vorname AS LeiterVorname,
    m.Nachname AS LeiterNachname,
    COUNT(DISTINCT mi.MitarbeiterID) AS MitarbeiterAnzahl,
    COUNT(s.SchichtID) AS SchichtenGesamt,
    COUNT(vh.ProduktID) AS ProdukteSortiment,
    COALESCE(SUM(vh.Lagerbestand), 0) AS TotalLagerbestand,
    ROUND(COALESCE(SUM(vk.VerkaufID)::DECIMAL, 0) / 100, 2) AS UmsatzGesamtEuro,
    COUNT(vk.VerkaufID) AS VerkaufsanzahlGesamt
FROM Filiale f
LEFT JOIN Mitarbeiter m ON f.LeiterID = m.MitarbeiterID
LEFT JOIN Schicht s ON f.FilialeID = s.FilialeID
LEFT JOIN durchgefuehrt_von dv ON s.SchichtID = dv.SchichtID
LEFT JOIN Mitarbeiter mi ON dv.MitarbeiterID = mi.MitarbeiterID
LEFT JOIN vorhanden vh ON f.FilialeID = vh.FilialeID
LEFT JOIN Verkauf vk ON f.FilialeID = vk.FilialeID
GROUP BY f.FilialeID, f.Name, f.Adresse, f.Aktiv, m.Vorname, m.Nachname
ORDER BY f.Aktiv DESC, f.Name;

-- View: Tägliche Verkaufsstatistiken pro Filiale
CREATE OR REPLACE VIEW v_verkaufsstatistik_taeglich AS
SELECT 
    v.Datum,
    f.FilialeID,
    f.Name AS FilialeName,
    COUNT(DISTINCT v.VerkaufID) AS VerkaufsanzahlTaeglich,
    ROUND(SUM(v.Gesamtbetrag)::DECIMAL / 100, 2) AS UmsatzTaeglichEuro,
    ROUND(AVG(v.Gesamtbetrag)::DECIMAL / 100, 2) AS DurchschnittVerkaufswertEuro,
    ROUND(MIN(v.Gesamtbetrag)::DECIMAL / 100, 2) AS MinVerkaufswertEuro,
    ROUND(MAX(v.Gesamtbetrag)::DECIMAL / 100, 2) AS MaxVerkaufswertEuro
FROM Verkauf v
JOIN Filiale f ON v.FilialeID = f.FilialeID
GROUP BY v.Datum, f.FilialeID, f.Name
ORDER BY v.Datum DESC, f.FilialeID;

-- View: Verkaufsstatistiken pro Produkt
-- FIXED: Umsatzberechnung mit SUM(vk.Menge) * p.Preis statt COUNT * p.Preis um Mengenattribut zu berücksichtigen
CREATE OR REPLACE VIEW v_verkaufsstatistik_produkt AS
SELECT 
    p.ProduktID,
    p.Name AS ProduktName,
    ROUND(p.Preis::DECIMAL / 100, 2) AS PreisEuro,
    COUNT(DISTINCT vk.VerkaufID) AS VerkaufsanzahlGesamt,
    SUM(vk.Menge) AS MengeGesamt,
    ROUND(SUM(vk.Menge) * p.Preis::DECIMAL / 100, 2) AS UmsatzGesamtEuro
FROM Produkt p
LEFT JOIN verkauft vk ON p.ProduktID = vk.ProduktID
GROUP BY p.ProduktID, p.Name, p.Preis
ORDER BY UmsatzGesamtEuro DESC NULLS LAST;

-- View: Verkaufsstatistiken pro Produkt und Filiale
CREATE OR REPLACE VIEW v_verkaufsstatistik_produkt_filiale AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    p.ProduktID,
    p.Name AS ProduktName,
    ROUND(p.Preis::DECIMAL / 100, 2) AS PreisEuro,
    COUNT(DISTINCT vk.VerkaufID) AS VerkaufsanzahlFiliale,
    SUM(vk.Menge) AS MengeFiliale,
    ROUND(SUM(vk.Menge) * p.Preis::DECIMAL / 100, 2) AS UmsatzFilialeEuro
FROM Filiale f
JOIN Verkauf v ON f.FilialeID = v.FilialeID
JOIN verkauft vk ON v.VerkaufID = vk.VerkaufID
JOIN Produkt p ON vk.ProduktID = p.ProduktID
GROUP BY f.FilialeID, f.Name, p.ProduktID, p.Name, p.Preis
ORDER BY f.FilialeID, UmsatzFilialeEuro DESC NULLS LAST;

-- View: Mitarbeiter Verkaufsleistung
CREATE OR REPLACE VIEW v_mitarbeiter_verkaufsleistung AS
SELECT 
    m.MitarbeiterID,
    m.Vorname,
    m.Nachname,
    f.FilialeID,
    f.Name AS FilialeName,
    COUNT(DISTINCT v.VerkaufID) AS VerkaufsanzahlGesamt,
    ROUND(SUM(v.Gesamtbetrag)::DECIMAL / 100, 2) AS UmsatzGesamtEuro,
    ROUND(AVG(v.Gesamtbetrag)::DECIMAL / 100, 2) AS DurchschnittsVerkaufswertEuro
FROM Mitarbeiter m
JOIN Verkauf v ON m.MitarbeiterID = v.MitarbeiterID
JOIN Filiale f ON v.FilialeID = f.FilialeID
GROUP BY m.MitarbeiterID, m.Vorname, m.Nachname, f.FilialeID, f.Name
ORDER BY f.FilialeID, UmsatzGesamtEuro DESC;

-- View: Produkt-Rezept-Zuordnung pro Filiale
CREATE OR REPLACE VIEW v_produkt_rezept_filiale AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    p.ProduktID,
    p.Name AS ProduktName,
    ROUND(p.Preis::DECIMAL / 100, 2) AS PreisEuro,
    prf.RezeptID,
    r.Name AS RezeptName,
    r.Anleitung
FROM ProduktRezeptFiliale prf
JOIN Filiale f ON prf.FilialeID = f.FilialeID
JOIN Produkt p ON prf.ProduktID = p.ProduktID
JOIN Rezept r ON prf.RezeptID = r.RezeptID
ORDER BY f.FilialeID, p.Name;

-- View: Azubi-Übersicht mit Verantwortlichen
CREATE OR REPLACE VIEW v_azubi_uebersicht AS
SELECT 
    a.MitarbeiterID AS AzubiID,
    m.Vorname AS AzubiVorname,
    m.Nachname AS AzubiNachname,
    m.Geburtsdatum,
    a.Start AS AzubiStart,
    a.VerantwortlicherID,
    mv.Vorname AS VerantwortlicherVorname,
    mv.Nachname AS VerantwortlicherNachname
FROM Azubi a
JOIN Mitarbeiter m ON a.MitarbeiterID = m.MitarbeiterID
LEFT JOIN Mitarbeiter mv ON a.VerantwortlicherID = mv.MitarbeiterID
ORDER BY a.Start;

-- View: Rezept-Varianten-Hierarchie
CREATE OR REPLACE VIEW v_rezept_varianten AS
SELECT 
    rb.RezeptID AS BasisRezeptID,
    rb.Name AS BasisRezeptName,
    rv.RezeptID AS VariantenRezeptID,
    rv.Name AS VariantenRezeptName,
    rv.Anleitung AS VariantenAnleitung
FROM Rezept rb
LEFT JOIN Rezept rv ON rb.RezeptID = rv.Basis
WHERE rv.RezeptID IS NOT NULL
ORDER BY rb.Name, rv.Name;

-- View: Filialen-Status Übersicht
CREATE OR REPLACE VIEW v_filialen_status AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    f.Adresse,
    f.Aktiv,
    m.Vorname AS LeiterVorname,
    m.Nachname AS LeiterNachname,
    COUNT(DISTINCT s.SchichtID) AS SchichtenAktuelleWoche,
    COUNT(DISTINCT dv.MitarbeiterID) AS MitarbeiterAktuell
FROM Filiale f
LEFT JOIN Mitarbeiter m ON f.LeiterID = m.MitarbeiterID
LEFT JOIN Schicht s ON f.FilialeID = s.FilialeID
LEFT JOIN durchgefuehrt_von dv ON s.SchichtID = dv.SchichtID
GROUP BY f.FilialeID, f.Name, f.Adresse, f.Aktiv, m.Vorname, m.Nachname
ORDER BY f.Aktiv DESC, f.Name;

-- ============================================================
-- SINNVOLLE ABFRAGEN AUF BASIS DER VIEWS
-- ============================================================

-- Alle Mitarbeiter einer spezifischen Filiale mit Kontaktdaten
SELECT * FROM v_mitarbeiter_kontakt 
WHERE FilialeID = 1
ORDER BY Nachname;

-- Schichtplan fuer die nächsten 7 Tage
SELECT * FROM v_schichtplan 
WHERE Startzeit >= CURRENT_DATE 
AND Startzeit < CURRENT_DATE + INTERVAL '7 days'
ORDER BY Startzeit;

-- Kritische Lagerbestände (niedrig: < 100 Einheiten)
SELECT * FROM v_lagerbestaende 
WHERE Bestand < 100
ORDER BY Bestand ASC;

-- Verfügbare Produkte pro Filiale mit Preisen
SELECT * FROM v_produktverfuegbarkeit 
WHERE Status = 'verfuegbar'
ORDER BY FilialeName, ProduktName;

-- Rezepte mit allen Zutaten und Mengen (komplette Zutatenliste)
SELECT * FROM v_rezept_details 
WHERE RezeptID = 1
ORDER BY ZutatName;

-- Kontaktdaten aller Zulieferer
SELECT * FROM v_zulieferer_kontakt 
ORDER BY ZuliefererName;

-- Lieferketten: Wer liefert was zu welchem Preis?
SELECT * FROM v_lieferverhaeltnisse 
WHERE FilialeName = 'Filiale Nagold Zentrum'
ORDER BY ZuliefererName, ZutatName;

-- Dashboard fuer Filialleiter: Überblick der Filiale
SELECT * FROM v_filialleiter_dashboard 
WHERE FilialeID = 1;

-- Team einer Filiale: Alle Mitarbeiter mit Gehalt und Kontakt
SELECT * FROM v_mitarbeiter_filiale 
WHERE FilialeID = 1;

-- Unternehmens-Überblick fuer Eigentuemer
SELECT * FROM v_eigentuemer_uebersicht 
WHERE Aktiv = TRUE
ORDER BY FilialeName;

-- Verkaufsstatistiken pro Tag und Filiale
SELECT * FROM v_verkaufsstatistik_taeglich 
WHERE Datum >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY Datum DESC, FilialeName;

-- Top-Produkte nach Umsatz (was verkauft sich am besten?)
SELECT * FROM v_verkaufsstatistik_produkt 
WHERE VerkaufsanzahlGesamt > 0
ORDER BY UmsatzGesamtEuro DESC
LIMIT 10;

-- Produktperformance pro Filiale (Verkauf nach Standort)
SELECT * FROM v_verkaufsstatistik_produkt_filiale 
WHERE VerkaufsanzahlFiliale > 0
ORDER BY FilialeName, UmsatzFilialeEuro DESC;

-- Mitarbeiter-Leistung: Verkaufsranking
SELECT * FROM v_mitarbeiter_verkaufsleistung 
ORDER BY UmsatzGesamtEuro DESC;

-- Produkt-Rezept-Zuordnung: Welche Rezepte für welche Produkte pro Filiale?
SELECT * FROM v_produkt_rezept_filiale 
WHERE FilialeName = 'Filiale Nagold Zentrum'
ORDER BY ProduktName;

-- Azubi-Übersicht: Wer sind die Azubis und wer betreut sie?
SELECT * FROM v_azubi_uebersicht 
ORDER BY AzubiStart;

-- Rezept-Varianten: Alle Varianten eines Basis-Rezepts
SELECT * FROM v_rezept_varianten 
WHERE BasisRezeptID = 1
ORDER BY BasisRezeptName;

-- Status aller Filialen: Wer ist aktiv, Leitung, Personalausstattung
SELECT * FROM v_filialen_status 
ORDER BY Aktiv DESC, FilialeName;

