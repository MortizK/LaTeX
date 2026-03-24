DROP TABLE IF EXISTS Abteilung;
CREATE TABLE IF EXISTS  Abteilung
(
	Abt_Bez_kurz	varchar(8),
	Abt_Bez_lang	text,
	Standrt			varchar,
		PRIMARY KEY (Abt_Bez_kurz)
);