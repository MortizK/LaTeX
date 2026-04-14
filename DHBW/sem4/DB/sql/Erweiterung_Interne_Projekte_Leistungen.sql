-- Erweiterung des Softwarehaus-ERM um interne Projekte und interne Leistungen
-- Ausfuehrung: nach Baseline_On_Delete_Plain.sql

BEGIN;

-- 1) ERM-Erweiterung: interne Kennzeichnung getrennt je Entitaet
ALTER TABLE public.projekt
    ADD COLUMN IF NOT EXISTS ist_intern boolean NOT NULL DEFAULT false;

ALTER TABLE public.leistung
    ADD COLUMN IF NOT EXISTS ist_intern boolean NOT NULL DEFAULT false;

-- 2) Auswertungs-Sichten: interne Projekte und interne Leistungen separat
CREATE OR REPLACE VIEW public.vw_interne_projekte AS
SELECT
    p.projekt_nr,
    p.bezeichung,
    p.beginn,
    p.ende,
    p.plan_std,
    p.ist_std,
    p.geleitet_von
FROM public.projekt p
WHERE p.ist_intern = true;

CREATE OR REPLACE VIEW public.vw_interne_leistungen AS
SELECT
    l.auftrag_nr,
    l.leistung_nr,
    l.bezeichung,
    l.start_termin,
    l.ende_termin,
    l.gepl_std,
    l.zu_projekt,
    p.ist_intern AS projekt_ist_intern
FROM public.leistung l
LEFT JOIN public.projekt p
    ON p.projekt_nr = l.zu_projekt
WHERE l.ist_intern = true;

-- 3) Beispielstammdaten fuer ein internes Projekt mit internen Leistungen
-- Interner "Kunde" fuer die bestehende Auftragsstruktur
INSERT INTO public.kunde (kunden_nr, vorname, nachname, firma)
VALUES (9001, 'Intern', 'Softwarehaus', 'Softwarehaus intern')
ON CONFLICT (kunden_nr) DO NOTHING;

INSERT INTO public.auftrag (auftrag_nr, auftrags_datum, bezeichnung, abrechnungsart, erteilt_von)
VALUES (9001, DATE '2026-04-14', 'Internes Plattform-Refactoring', 'FP', 9001)
ON CONFLICT (auftrag_nr) DO NOTHING;

INSERT INTO public.projekt (projekt_nr, bezeichung, beginn, ende, plan_std, ist_std, geleitet_von, ist_intern)
VALUES (9001, 'Interne Modernisierung Datenplattform', DATE '2026-04-15', NULL, 420, 0, 6, true)
ON CONFLICT (projekt_nr) DO NOTHING;

INSERT INTO public.leistung (auftrag_nr, leistung_nr, bezeichung, start_termin, ende_termin, gepl_std, zu_projekt, ist_intern)
VALUES
    (9001, 1, 'Anforderungsworkshops intern', DATE '2026-04-16', DATE '2026-04-30', 80, 9001, true),
    (9001, 2, 'Architektur-Blueprint', DATE '2026-05-01', DATE '2026-05-20', 110, 9001, true),
    (9001, 3, 'Implementierung Kernmodule', DATE '2026-05-21', NULL, 180, 9001, true),
    (9001, 4, 'Qualitaetssicherung und Rollout', DATE '2026-06-20', NULL, 50, 9001, true)
ON CONFLICT (auftrag_nr, leistung_nr) DO NOTHING;

-- 4) Projektmitarbeiter arbeiten in Kleingruppen an den Leistungen
INSERT INTO public.arbeitet_an (pers_nr, auftrag_nr, leistung_nr, std)
VALUES
    -- Kleingruppe 1: Analyse
    (1, 9001, 1, 40),
    (2, 9001, 1, 40),

    -- Kleingruppe 2: Architektur
    (5, 9001, 2, 55),
    (6, 9001, 2, 55),

    -- Kleingruppe 3: Implementierung
    (2, 9001, 3, 70),
    (4, 9001, 3, 60),
    (7, 9001, 3, 50),

    -- Kleingruppe 4: Test/Rollout
    (1, 9001, 4, 20),
    (3, 9001, 4, 20),
    (4, 9001, 4, 10)
ON CONFLICT (pers_nr, auftrag_nr, leistung_nr) DO NOTHING;

COMMIT;

-- Beispielauswertungen:
-- SELECT * FROM public.vw_interne_projekte ORDER BY projekt_nr;
-- SELECT * FROM public.vw_interne_leistungen ORDER BY auftrag_nr, leistung_nr;
