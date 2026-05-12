Create Table Training_Institut
(inst_Nr serial primary key,
institut varchar Not Null,
ort varchar Not Null,
strasse varchar Not Null,
hausnummer int ,
Infos varchar)
;

-- Änderen der Tabelle Kurs
ALTER TABLE  Kurs
Drop Institut Cascade,
ADD inst_nr int
;
Insert Into Training_Institut
Values(default, 'Lern-Fix GmbH', 'Tübingen', 'Hahnstraße', 8, 'Altgedient'),
      (default, 'Besser Lernen', 'Leinfelden', 'Bismarkstraße', 25,Null),
      (default, 'IT-Training GmbH', 'Stuttgart', 'Adenauerallee',null,Null )
;

Update Kurs 
Set Inst_Nr = 1 
Where Kurs_Nr = 1312
;
Update Kurs 
Set Inst_Nr =2 
Where Kurs_Nr = 1520
;
Update Kurs 
Set Inst_Nr =3 
Where Kurs_Nr = 4712
;

-- Änderen der Tabelle Kurs
ALTER TABLE  Kurs
ADD FOREIGN KEY(Inst_Nr) REFERENCES Training_Institut
;