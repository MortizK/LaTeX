--
-- PostgreSQL database dump
--

\restrict rIedxCCwRHdTZDkWCgMO90w50IaF9U7n5wGensdt1aJzeBCiSNAj2dAGg6tkfWq

-- Dumped from database version 18.3
-- Dumped by pg_dump version 18.3

-- Started on 2026-04-07 15:24:42

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 224 (class 1259 OID 28195)
-- Name: abteilung; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.abteilung (
    abt_bez_kurz character varying(8) NOT NULL,
    abt_bez_lang character varying NOT NULL,
    standort character varying NOT NULL
);


ALTER TABLE public.abteilung OWNER TO postgres;

--
-- TOC entry 230 (class 1259 OID 28250)
-- Name: arbeitet_an; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.arbeitet_an (
    pers_nr integer NOT NULL,
    auftrag_nr integer NOT NULL,
    leistung_nr integer NOT NULL,
    std integer
);


ALTER TABLE public.arbeitet_an OWNER TO postgres;

--
-- TOC entry 228 (class 1259 OID 28232)
-- Name: auftrag; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.auftrag (
    auftrag_nr integer NOT NULL,
    auftrags_datum date,
    bezeichnung character varying,
    abrechnungsart character varying,
    erteilt_von integer NOT NULL,
    CONSTRAINT auftrag_abrechnungsart_check CHECK (((abrechnungsart)::text = ANY ((ARRAY['FP'::character varying, 'TM'::character varying])::text[])))
);


ALTER TABLE public.auftrag OWNER TO postgres;

--
-- TOC entry 226 (class 1259 OID 28215)
-- Name: besucht_kurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.besucht_kurs (
    pers_nr integer NOT NULL,
    kurs_nr integer NOT NULL,
    termin_kurs date
);


ALTER TABLE public.besucht_kurs OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 28222)
-- Name: kunde; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kunde (
    kunden_nr integer NOT NULL,
    vorname character varying,
    nachname character varying NOT NULL,
    firma character varying NOT NULL
);


ALTER TABLE public.kunde OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 28205)
-- Name: kurs; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.kurs (
    kurs_nr integer NOT NULL,
    kurs_bez character varying NOT NULL,
    institut character varying NOT NULL
);


ALTER TABLE public.kurs OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 28241)
-- Name: leistung; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.leistung (
    auftrag_nr integer NOT NULL,
    leistung_nr integer NOT NULL,
    bezeichung character varying,
    start_termin date,
    ende_termin date,
    gepl_std integer,
    zu_projekt integer
);


ALTER TABLE public.leistung OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 28149)
-- Name: mitarbeiter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mitarbeiter (
    pers_nr integer NOT NULL,
    vorname character varying,
    nachname character varying NOT NULL,
    geb_name character varying,
    geb_datum date,
    geschlecht character(1) NOT NULL,
    eintrittsdatum date NOT NULL,
    skill character varying(5) DEFAULT 'PR'::character varying,
    gehalt integer,
    arbeitet_in character varying(8),
    chef_nr integer,
    CONSTRAINT mitarbeiter_eintrittsdatum_check CHECK ((eintrittsdatum <= now())),
    CONSTRAINT mitarbeiter_gehalt_check CHECK (((gehalt > 20000) AND (gehalt < 150000))),
    CONSTRAINT mitarbeiter_geschlecht_check CHECK ((geschlecht = ANY (ARRAY['m'::bpchar, 'w'::bpchar])))
);


ALTER TABLE public.mitarbeiter OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 28172)
-- Name: mitarbeiter_finanzb; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mitarbeiter_finanzb (
    pers_nr integer NOT NULL,
    sachgebiet character varying,
    projektcontroling character varying(4),
    spezialerfahrung character varying,
    CONSTRAINT mitarbeiter_finanzb_projektcontroling_check CHECK (((projektcontroling)::text = ANY ((ARRAY['ja'::character varying, 'nein'::character varying])::text[])))
);


ALTER TABLE public.mitarbeiter_finanzb OWNER TO postgres;

--
-- TOC entry 222 (class 1259 OID 28181)
-- Name: mitarbeiter_projekt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mitarbeiter_projekt (
    pers_nr integer NOT NULL,
    stundensatz numeric(5,2),
    projekterfahrung smallint
);


ALTER TABLE public.mitarbeiter_projekt OWNER TO postgres;

--
-- TOC entry 220 (class 1259 OID 28164)
-- Name: mitarbeiter_sekr; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mitarbeiter_sekr (
    pers_nr integer NOT NULL,
    sachgebiet character varying,
    berufserfahrung smallint
);


ALTER TABLE public.mitarbeiter_sekr OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 28258)
-- Name: projekt; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projekt (
    projekt_nr integer NOT NULL,
    bezeichung character varying,
    beginn date,
    ende date,
    plan_std smallint,
    ist_std smallint,
    geleitet_von integer
);


ALTER TABLE public.projekt OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 28187)
-- Name: projektleiter; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projektleiter (
    pers_nr integer NOT NULL,
    stufe integer,
    pl_ausbildung character varying
);


ALTER TABLE public.projektleiter OWNER TO postgres;

--
-- TOC entry 5101 (class 0 OID 28195)
-- Dependencies: 224
-- Data for Name: abteilung; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.abteilung (abt_bez_kurz, abt_bez_lang, standort) FROM stdin;
EDM1	Abteilung für Spezialaufgaben	Leinfelden
EDM2	Testabteilung	Stuttgart
EDM3	Programmierung	Leinfelden
\.


--
-- TOC entry 5107 (class 0 OID 28250)
-- Dependencies: 230
-- Data for Name: arbeitet_an; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.arbeitet_an (pers_nr, auftrag_nr, leistung_nr, std) FROM stdin;
5	1	1	100
1	1	2	150
2	1	3	100
4	1	3	120
6	1	6	50
5	2	1	100
2	2	1	70
1	2	2	75
1	2	3	100
2	2	4	100
5	2	4	70
1	2	7	66
3	3	1	200
2	4	1	100
5	4	1	150
\.


--
-- TOC entry 5105 (class 0 OID 28232)
-- Dependencies: 228
-- Data for Name: auftrag; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.auftrag (auftrag_nr, auftrags_datum, bezeichnung, abrechnungsart, erteilt_von) FROM stdin;
1	2018-03-15	Personaldatenbank	FP	2
2	2018-02-01	Prüfstandsdaten	TM	3
3	2018-01-15	Schnittstelle Produktion	FP	1
4	2015-02-01	Konzeption Neuvernetzung	TM	4
\.


--
-- TOC entry 5103 (class 0 OID 28215)
-- Dependencies: 226
-- Data for Name: besucht_kurs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.besucht_kurs (pers_nr, kurs_nr, termin_kurs) FROM stdin;
1	4712	2019-06-13
2	1312	2019-10-01
4	1312	2019-10-01
5	1520	2019-05-15
\.


--
-- TOC entry 5104 (class 0 OID 28222)
-- Dependencies: 227
-- Data for Name: kunde; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kunde (kunden_nr, vorname, nachname, firma) FROM stdin;
1	Manfred	Schwarz	Rema GmbH Stuttgart
2	Claudia	Müller	Schrauben Würth Künzelsau
3	Klaus	Huber	Daimler AG Untertürkheim
4	Jan	Steiner	Stadtverwaltung Leinfelden
\.


--
-- TOC entry 5102 (class 0 OID 28205)
-- Dependencies: 225
-- Data for Name: kurs; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.kurs (kurs_nr, kurs_bez, institut) FROM stdin;
1312	C#-Programmierung	Lern-Fix GmbH
1520	Datenban-Entwurfs Methoden	Besser Lernen
4712	Datenbank Administration	IT-Training GmbH
\.


--
-- TOC entry 5106 (class 0 OID 28241)
-- Dependencies: 229
-- Data for Name: leistung; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.leistung (auftrag_nr, leistung_nr, bezeichung, start_termin, ende_termin, gepl_std, zu_projekt) FROM stdin;
1	1	Systemanalyse	2018-05-15	2018-06-12	100	3050
1	2	Datenbankentwurf	2018-06-20	2018-08-01	200	3050
1	3	Programmierung	2018-08-15	\N	450	3050
1	4	Test	\N	\N	120	3050
1	5	Integration	\N	\N	80	3050
1	6	Projektleitung	2018-05-13	\N	150	3050
2	1	Anforderungsanalyse	2018-09-01	2018-11-01	170	3091
2	2	Systemanalyse	2018-11-15	2018-12-31	80	3091
2	3	Datenbankentwurf	2019-01-15	2019-02-15	120	3091
2	4	Programmierung	2019-02-20	\N	290	3091
2	5	Test	\N	\N	80	3091
2	6	Integration	\N	\N	120	3091
2	7	Projektleitung	2018-09-01	\N	120	3091
3	1	Pflichtenheft	2018-02-15	2018-07-01	330	2020
4	1	Systemstudie	2015-03-01	2015-10-01	250	4711
\.


--
-- TOC entry 5096 (class 0 OID 28149)
-- Dependencies: 219
-- Data for Name: mitarbeiter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mitarbeiter (pers_nr, vorname, nachname, geb_name, geb_datum, geschlecht, eintrittsdatum, skill, gehalt, arbeitet_in, chef_nr) FROM stdin;
1	Paul	Müller	\N	1975-01-28	m	2014-05-28	DBA	61000	EDM1	\N
2	Rita	Schulze	Klein	1981-03-12	w	2016-07-01	Analy	48000	EDM3	5
3	Claudia	Franz	\N	1986-02-07	w	2017-10-01	Test	40000	EDM2	6
4	Karin	Schwarz	Breithans	1978-10-13	w	2011-10-01	PR	56000	EDM3	5
5	Werner	Meier	\N	1968-03-20	m	2010-02-01	Analy	80000	EDM3	\N
6	Klaus	Brecht	\N	1977-01-28	m	2011-06-01	PL	65000	EDM2	\N
7	Florian	Habrecht	\N	1985-01-28	m	2017-09-01	Test	46000	EDM2	6
8	Edith	Franz	Schmid	1982-03-17	w	2015-03-01	\N	38000	EDM1	6
9	Manfred	Klein	\N	1990-01-28	m	2018-12-01	\N	32000	EDM2	5
10	Paul	Kunze	\N	1975-01-28	m	2014-09-01	\N	55000	EDM1	\N
\.


--
-- TOC entry 5098 (class 0 OID 28172)
-- Dependencies: 221
-- Data for Name: mitarbeiter_finanzb; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mitarbeiter_finanzb (pers_nr, sachgebiet, projektcontroling, spezialerfahrung) FROM stdin;
10	Finanzwesen	ja	Steuerrecht
\.


--
-- TOC entry 5099 (class 0 OID 28181)
-- Dependencies: 222
-- Data for Name: mitarbeiter_projekt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mitarbeiter_projekt (pers_nr, stundensatz, projekterfahrung) FROM stdin;
2	80.00	8
3	62.00	7
4	70.00	5
5	80.00	10
7	65.00	3
6	95.00	12
1	90.00	10
\.


--
-- TOC entry 5097 (class 0 OID 28164)
-- Dependencies: 220
-- Data for Name: mitarbeiter_sekr; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mitarbeiter_sekr (pers_nr, sachgebiet, berufserfahrung) FROM stdin;
8	Produktion	5
9	Vertrieb	3
\.


--
-- TOC entry 5108 (class 0 OID 28258)
-- Dependencies: 231
-- Data for Name: projekt; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projekt (projekt_nr, bezeichung, beginn, ende, plan_std, ist_std, geleitet_von) FROM stdin;
4711	Neukonzeption der Vernetzung der gesamten Stadtverwaltung	2015-03-15	2016-03-15	312	300	1
3050	Erweiterung Personal-Datenbank Firma Würth	2018-05-13	\N	1100	500	6
2020	Analyse Schnittstellen zwischen Produktion und Verkauf Firma Rema	2018-02-01	2018-07-31	330	330	6
3091	Elektronische Erfassung der Prüfstandsdaten für Daimler	2018-09-01	\N	980	700	1
\.


--
-- TOC entry 5100 (class 0 OID 28187)
-- Dependencies: 223
-- Data for Name: projektleiter; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projektleiter (pers_nr, stufe, pl_ausbildung) FROM stdin;
1	2	PMI
6	4	PRINCE2
\.


--
-- TOC entry 4920 (class 2606 OID 28204)
-- Name: abteilung abteilung_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.abteilung
    ADD CONSTRAINT abteilung_pkey PRIMARY KEY (abt_bez_kurz);


--
-- TOC entry 4932 (class 2606 OID 28257)
-- Name: arbeitet_an arbeitet_an_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbeitet_an
    ADD CONSTRAINT arbeitet_an_pkey PRIMARY KEY (pers_nr, auftrag_nr, leistung_nr);


--
-- TOC entry 4928 (class 2606 OID 28240)
-- Name: auftrag auftrag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auftrag
    ADD CONSTRAINT auftrag_pkey PRIMARY KEY (auftrag_nr);


--
-- TOC entry 4924 (class 2606 OID 28221)
-- Name: besucht_kurs besucht_kurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.besucht_kurs
    ADD CONSTRAINT besucht_kurs_pkey PRIMARY KEY (pers_nr, kurs_nr);


--
-- TOC entry 4926 (class 2606 OID 28231)
-- Name: kunde kunde_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kunde
    ADD CONSTRAINT kunde_pkey PRIMARY KEY (kunden_nr);


--
-- TOC entry 4922 (class 2606 OID 28214)
-- Name: kurs kurs_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.kurs
    ADD CONSTRAINT kurs_pkey PRIMARY KEY (kurs_nr);


--
-- TOC entry 4930 (class 2606 OID 28249)
-- Name: leistung leistung_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leistung
    ADD CONSTRAINT leistung_pkey PRIMARY KEY (auftrag_nr, leistung_nr);


--
-- TOC entry 4914 (class 2606 OID 28180)
-- Name: mitarbeiter_finanzb mitarbeiter_finanzb_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter_finanzb
    ADD CONSTRAINT mitarbeiter_finanzb_pkey PRIMARY KEY (pers_nr);


--
-- TOC entry 4910 (class 2606 OID 28163)
-- Name: mitarbeiter mitarbeiter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter
    ADD CONSTRAINT mitarbeiter_pkey PRIMARY KEY (pers_nr);


--
-- TOC entry 4916 (class 2606 OID 28186)
-- Name: mitarbeiter_projekt mitarbeiter_projekt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter_projekt
    ADD CONSTRAINT mitarbeiter_projekt_pkey PRIMARY KEY (pers_nr);


--
-- TOC entry 4912 (class 2606 OID 28171)
-- Name: mitarbeiter_sekr mitarbeiter_sekr_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter_sekr
    ADD CONSTRAINT mitarbeiter_sekr_pkey PRIMARY KEY (pers_nr);


--
-- TOC entry 4934 (class 2606 OID 28265)
-- Name: projekt projekt_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projekt
    ADD CONSTRAINT projekt_pkey PRIMARY KEY (projekt_nr);


--
-- TOC entry 4918 (class 2606 OID 28194)
-- Name: projektleiter projektleiter_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projektleiter
    ADD CONSTRAINT projektleiter_pkey PRIMARY KEY (pers_nr);


--
-- TOC entry 4946 (class 2606 OID 28328)
-- Name: arbeitet_an arbeitet_an_leistung_nr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbeitet_an
    ADD CONSTRAINT arbeitet_an_leistung_nr_fkey FOREIGN KEY (auftrag_nr, leistung_nr) REFERENCES public.leistung(auftrag_nr, leistung_nr);


--
-- TOC entry 4947 (class 2606 OID 28333)
-- Name: arbeitet_an arbeitet_an_pers_nr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.arbeitet_an
    ADD CONSTRAINT arbeitet_an_pers_nr_fkey FOREIGN KEY (pers_nr) REFERENCES public.mitarbeiter_projekt(pers_nr);


--
-- TOC entry 4943 (class 2606 OID 28313)
-- Name: auftrag auftrag_erteilt_von_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.auftrag
    ADD CONSTRAINT auftrag_erteilt_von_fkey FOREIGN KEY (erteilt_von) REFERENCES public.kunde(kunden_nr);


--
-- TOC entry 4941 (class 2606 OID 28307)
-- Name: besucht_kurs besucht_kurs_kurs_nr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.besucht_kurs
    ADD CONSTRAINT besucht_kurs_kurs_nr_fkey FOREIGN KEY (kurs_nr) REFERENCES public.kurs(kurs_nr);


--
-- TOC entry 4942 (class 2606 OID 28302)
-- Name: besucht_kurs besucht_kurs_pers_nr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.besucht_kurs
    ADD CONSTRAINT besucht_kurs_pers_nr_fkey FOREIGN KEY (pers_nr) REFERENCES public.mitarbeiter(pers_nr);


--
-- TOC entry 4944 (class 2606 OID 28318)
-- Name: leistung leistung_auftrag_nr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leistung
    ADD CONSTRAINT leistung_auftrag_nr_fkey FOREIGN KEY (auftrag_nr) REFERENCES public.auftrag(auftrag_nr);


--
-- TOC entry 4945 (class 2606 OID 28323)
-- Name: leistung leistung_zu_projekt_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.leistung
    ADD CONSTRAINT leistung_zu_projekt_fkey FOREIGN KEY (zu_projekt) REFERENCES public.projekt(projekt_nr);


--
-- TOC entry 4935 (class 2606 OID 28267)
-- Name: mitarbeiter mitarbeiter_arbeitet_in_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter
    ADD CONSTRAINT mitarbeiter_arbeitet_in_fkey FOREIGN KEY (arbeitet_in) REFERENCES public.abteilung(abt_bez_kurz);


--
-- TOC entry 4936 (class 2606 OID 28272)
-- Name: mitarbeiter mitarbeiter_chef_nr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter
    ADD CONSTRAINT mitarbeiter_chef_nr_fkey FOREIGN KEY (chef_nr) REFERENCES public.mitarbeiter(pers_nr);


--
-- TOC entry 4938 (class 2606 OID 28282)
-- Name: mitarbeiter_finanzb mitarbeiter_finanzb_pers_nr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter_finanzb
    ADD CONSTRAINT mitarbeiter_finanzb_pers_nr_fkey FOREIGN KEY (pers_nr) REFERENCES public.mitarbeiter(pers_nr);


--
-- TOC entry 4939 (class 2606 OID 28287)
-- Name: mitarbeiter_projekt mitarbeiter_projekt_pers_nr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter_projekt
    ADD CONSTRAINT mitarbeiter_projekt_pers_nr_fkey FOREIGN KEY (pers_nr) REFERENCES public.mitarbeiter(pers_nr);


--
-- TOC entry 4937 (class 2606 OID 28277)
-- Name: mitarbeiter_sekr mitarbeiter_sekr_pers_nr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mitarbeiter_sekr
    ADD CONSTRAINT mitarbeiter_sekr_pers_nr_fkey FOREIGN KEY (pers_nr) REFERENCES public.mitarbeiter(pers_nr);


--
-- TOC entry 4948 (class 2606 OID 28297)
-- Name: projekt projekt_geleitet_von_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projekt
    ADD CONSTRAINT projekt_geleitet_von_fkey FOREIGN KEY (geleitet_von) REFERENCES public.projektleiter(pers_nr);


--
-- TOC entry 4940 (class 2606 OID 28292)
-- Name: projektleiter projektleiter_pers_nr_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projektleiter
    ADD CONSTRAINT projektleiter_pers_nr_fkey FOREIGN KEY (pers_nr) REFERENCES public.mitarbeiter(pers_nr);


-- Completed on 2026-04-07 15:24:42

--
-- PostgreSQL database dump complete
--

\unrestrict rIedxCCwRHdTZDkWCgMO90w50IaF9U7n5wGensdt1aJzeBCiSNAj2dAGg6tkfWq

