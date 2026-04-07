insert into abteilung
Values('EDM1','Abteilung für Spezialaufgaben', 'Leinfelden'),
      ('EDM2','Testabteilung', 'Stuttgart'),
      ('EDM3','Programmierung', 'Leinfelden')
;

INSERT INTO Mitarbeiter 
VALUES (1, 'Paul', 'Müller', Null, '1975-01-28','m', '2014-05-28','DBA',61000,'EDM1',NULL),
       (2, 'Rita', 'Schulze', 'Klein', '1981-03-12','w', '2016-07-01','Analy',48000,'EDM3',5),
       (3, 'Claudia', 'Franz', Null, '1986-02-07','w', '2017-10-01','Test',40000,'EDM2',6),
       (4, 'Karin', 'Schwarz', 'Breithans', '1978-10-13','w', '2011-10-01',default,56000,'EDM3',5),
       (5, 'Werner', 'Meier', Null, '1968-03-20','m', '2010-02-01','Analy',80000,'EDM3',NULL),
       (6, 'Klaus', 'Brecht', Null, '1977-01-28','m', '2011-06-01','PL',65000,'EDM2',Null),
       (7, 'Florian', 'Habrecht', Null, '1985-01-28','m', '2017-09-01','Test',46000,'EDM2',6),
       (8, 'Edith', 'Franz', 'Schmid', '1982-03-17','w', '2015-03-01',NULL,38000,'EDM1',6),
       (9, 'Manfred', 'Klein', Null, '1990-01-28','m', '2018-12-01',NULL,32000,'EDM2',5),
       (10,'Paul', 'Kunze', Null, '1975-01-28','m', '2014-09-01',NULL,55000,'EDM1',NULL)
;

insert into Kurs
Values(1312,'C#-Programmierung','Lern-Fix GmbH'),
      (1520,'Datenban-Entwurfs Methoden','Besser Lernen'),
      (4712,'Datenbank Administration','IT-Training GmbH')
;

insert into besucht_kurs
Values	(1, 4712, '2019-06-13'),
	(2, 1312, '2019-10-01'),
	(4, 1312, '2019-10-01'),
	(5, 1520, '2019-05-15')
;

insert into Mitarbeiter_Sekr 
Values	(8, 'Produktion', 5),
	(9, 'Vertrieb', 3)
;

insert into  Mitarbeiter_Finanzb  
Values	(10, 'Finanzwesen','ja','Steuerrecht')
;

insert into  Mitarbeiter_Projekt 
Values	(2, 80.00, 8),
	(3, 62.00, 7),
	(4, 70.00, 5),
	(5, 80.00, 10),
	(7, 65.00, 3),
	(6, 95.00, 12),
	(1, 90.00, 10)
;

insert into Projektleiter 
Values	(1, 2, 'PMI'),
	(6, 4, 'PRINCE2')
;

insert into Projekt
Values 	(4711, 'Neukonzeption der Vernetzung der gesamten Stadtverwaltung','2015-03-15', '2016-03-15', 312, 300, 1),
	(3050, 'Erweiterung Personal-Datenbank Firma Würth', '2018-05-13',NULL, 1100,500,6),
	(2020, 'Analyse Schnittstellen zwischen Produktion und Verkauf Firma Rema','2018-02-01', '2018-07-31', 330, 330, 6),
	(3091, 'Elektronische Erfassung der Prüfstandsdaten für Daimler', '2018-09-01', NULL, 980, 700,1)
;

insert into Kunde
Values	(1, 'Manfred', 'Schwarz', 'Rema GmbH Stuttgart'),
	(2, 'Claudia', 'Müller', 'Schrauben Würth Künzelsau'),
	(3, 'Klaus', 'Huber', 'Daimler AG Untertürkheim'),
	(4, 'Jan', 'Steiner', 'Stadtverwaltung Leinfelden')
;

insert into Auftrag
Values	(1,'2018-03-15', 'Personaldatenbank','FP',2),
	(2, '2018-02-01', 'Prüfstandsdaten', 'TM',3),
	(3, '2018-01-15', 'Schnittstelle Produktion', 'FP',1),
	(4, '2015-02-01', 'Konzeption Neuvernetzung', 'TM',4)
;

insert into Leistung
Values	(1,1, 'Systemanalyse','2018-05-15', '2018-06-12', 100,3050),
	(1,2, 'Datenbankentwurf','2018-06-20', '2018-08-01', 200,3050),
	(1,3, 'Programmierung','2018-08-15', NULL, 450,3050),
	(1,4, 'Test',NULL, NULL, 120,3050),
	(1,5, 'Integration',NULL, NULL, 80,3050),
	(1,6, 'Projektleitung','2018-05-13', NULL, 150,3050),
	(2,1, 'Anforderungsanalyse','2018-09-01', '2018-11-01', 170,3091),
	(2,2, 'Systemanalyse','2018-11-15', '2018-12-31', 80,3091),
	(2,3, 'Datenbankentwurf','2019-01-15', '2019-02-15', 120,3091),
	(2,4, 'Programmierung','2019-02-20', NULL, 290,3091),
	(2,5, 'Test',NULL, NULL, 80,3091),
	(2,6, 'Integration',NULL, NULL, 120,3091),
	(2,7, 'Projektleitung','2018-09-01', NULL, 120,3091),	
	(3,1, 'Pflichtenheft','2018-02-15', '2018-07-01', 330,2020),
	(4,1, 'Systemstudie','2015-03-01', '2015-10-01',250,4711)

;

insert into arbeitet_an
Values	(5,1,1,100),
	(1,1,2,150),
	(2,1,3,100),
	(4,1,3,120),
	(6,1,6,50),
	(5,2,1,100),
	(2,2,1,70),
	(1,2,2,75),
	(1,2,3,100),
	(2,2,4,100),
	(5,2,4,70),
	(1,2,7,66),
	(3,3,1,200),
	(2,4,1,100),
	(5,4,1,150)
;


