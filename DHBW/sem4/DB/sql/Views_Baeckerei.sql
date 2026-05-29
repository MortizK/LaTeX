-- View: Mitarbeiter mit Kontaktinformationen pro Filiale
CREATE OR REPLACE VIEW v_mitarbeiter_kontakt AS
SELECT 
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
ORDER BY f.FilialeID, m.Nachname, m.Vorname;

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
LEFT JOIN Azubi a ON m.MitarbeiterID = a.MitarbeiterID
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
    zt.Vorwahl,
    zt.Telefonnummer
FROM Zulieferer z
LEFT JOIN ZuliefererTelefonnummer zt ON z.ZuliefererID = zt.ZuliefererID
ORDER BY z.Name, zt.Vorwahl, zt.Telefonnummer;

-- View: Lieferverhältnisse pro Filiale
CREATE OR REPLACE VIEW v_lieferverhältnisse AS
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
CREATE OR REPLACE VIEW v_filialleiter_dashboard AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    f.Adresse,
    (
        SELECT COUNT(*) 
        FROM Mitarbeiter m 
        JOIN durchgefuehrt_von dv ON m.MitarbeiterID = dv.MitarbeiterID
        JOIN Schicht s ON dv.SchichtID = s.SchichtID
        WHERE s.FilialeID = f.FilialeID
    ) AS MitarbeiterAnzahl,
    (
        SELECT COUNT(*) 
        FROM Schicht s 
        WHERE s.FilialeID = f.FilialeID
    ) AS SchichtAnzahl,
    (
        SELECT COUNT(DISTINCT ProduktID) 
        FROM vorhanden v 
        WHERE v.FilialeID = f.FilialeID
    ) AS ProdukteAnzahl,
    ROUND((
        SELECT SUM(Gesamtbetrag)::DECIMAL 
        FROM Verkauf v 
        WHERE v.FilialeID = f.FilialeID
    ) / 100, 2) AS GesamtUmsatzEuro,
    (
        SELECT COUNT(*) 
        FROM Verkauf v 
        WHERE v.FilialeID = f.FilialeID
    ) AS VerkaufsanzahlGesamt
FROM Filiale f;

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
JOIN durchgefuehrt_von dv ON TRUE
JOIN Schicht s ON dv.SchichtID = s.SchichtID AND s.FilialeID = f.FilialeID
JOIN Mitarbeiter m ON dv.MitarbeiterID = m.MitarbeiterID
LEFT JOIN Azubi a ON m.MitarbeiterID = a.MitarbeiterID
LEFT JOIN MitarbeiterTelefonnummer mt ON m.MitarbeiterID = mt.MitarbeiterID
GROUP BY f.FilialeID, f.Name, m.MitarbeiterID, m.Vorname, m.Nachname, 
         m.Geburtsdatum, m.Gehalt, f.LeiterID, a.MitarbeiterID, a.Start
ORDER BY f.FilialeID, m.Nachname;

-- View: Eigentümer-Übersicht (alle Filialen im Überblick)
CREATE OR REPLACE VIEW v_eigentümer_übersicht AS
SELECT 
    f.FilialeID,
    f.Name AS FilialeName,
    f.Adresse,
    f.Aktiv,
    m.Vorname AS LeiterVorname,
    m.Nachname AS LeiterNachname,
    (
        SELECT COUNT(*) 
        FROM Mitarbeiter mi 
        JOIN durchgefuehrt_von dv ON mi.MitarbeiterID = dv.MitarbeiterID
        JOIN Schicht s ON dv.SchichtID = s.SchichtID
        WHERE s.FilialeID = f.FilialeID
    ) AS MitarbeiterAnzahl,
    (
        SELECT COUNT(*) 
        FROM Schicht s 
        WHERE s.FilialeID = f.FilialeID
    ) AS SchichtenGesamt,
    (
        SELECT COUNT(DISTINCT ProduktID) 
        FROM vorhanden v 
        WHERE v.FilialeID = f.FilialeID
    ) AS ProdukteSortiment,
    (
        SELECT SUM(Lagerbestand) 
        FROM vorhanden v 
        WHERE v.FilialeID = f.FilialeID
    ) AS TotalLagerbestand,
    ROUND((
        SELECT SUM(Gesamtbetrag)::DECIMAL 
        FROM Verkauf v 
        WHERE v.FilialeID = f.FilialeID
    ) / 100, 2) AS UmsatzGesamtEuro,
    (
        SELECT COUNT(*) 
        FROM Verkauf v 
        WHERE v.FilialeID = f.FilialeID
    ) AS VerkaufsanzahlGesamt
FROM Filiale f
LEFT JOIN Mitarbeiter m ON f.LeiterID = m.MitarbeiterID
ORDER BY f.Aktiv DESC, f.Name;

-- View: Tägliche Verkaufsstatistiken pro Filiale
CREATE OR REPLACE VIEW v_verkaufsstatistik_täglich AS
SELECT 
    v.Datum,
    f.FilialeID,
    f.Name AS FilialeName,
    COUNT(DISTINCT v.VerkaufID) AS VerkaufsanzahlTäglich,
    ROUND(SUM(v.Gesamtbetrag)::DECIMAL / 100, 2) AS UmsatzTäglichEuro,
    ROUND(AVG(v.Gesamtbetrag)::DECIMAL / 100, 2) AS DurchschnittVerkaufswertEuro,
    ROUND(MIN(v.Gesamtbetrag)::DECIMAL / 100, 2) AS MinVerkaufswertEuro,
    ROUND(MAX(v.Gesamtbetrag)::DECIMAL / 100, 2) AS MaxVerkaufswertEuro
FROM Verkauf v
JOIN Filiale f ON v.FilialeID = f.FilialeID
GROUP BY v.Datum, f.FilialeID, f.Name
ORDER BY v.Datum DESC, f.FilialeID;

-- View: Verkaufsstatistiken pro Produkt
CREATE OR REPLACE VIEW v_verkaufsstatistik_produkt AS
SELECT 
    p.ProduktID,
    p.Name AS ProduktName,
    ROUND(p.Preis::DECIMAL / 100, 2) AS PreisEuro,
    COUNT(DISTINCT vk.VerkaufID) AS VerkaufsanzahlGesamt,
    SUM(vk.Menge) AS MengeGesamt,
    ROUND((COUNT(DISTINCT vk.VerkaufID) * p.Preis)::DECIMAL / 100, 2) AS UmsatzGesamtEuro
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
CREATE OR REPLACE VIEW v_azubi_übersicht AS
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
