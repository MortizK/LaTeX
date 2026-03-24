DROP TABLE IF EXISTS  Kurs;
CREATE TABLE IF EXISTS  Kurs
(
	Kurs_Nr		integer,
	Kurs_Bez	text,
	Anzahl_teilnehmer	integer,
PRIMARY KEY (Kurs_Nr),
CHECK (Anzahl_teilnehmer >= 5)
)