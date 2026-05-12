
Create View Projektmitarbeiter As
Select * from Mitarbeiter
n

Create View mitarbeiter_besucht_kurs As
Select pers_nr, vorname, nachname, kurs_bez, termin_kurs, institut 
from Mitarbeiter natural join besucht_kurs
natural join Kurs

Create View V_kurs AS
Select * from Kurs

-- Bei * Könnten später probleme auftreten. Lieber Explezit bleiben mit kurs_nr, kurs_bez, institut

Insert into v_kurs
Values (2223, 'Testkurs', 'Testinstitut')

SELECT * from V_Kurs

SELECT * from Kurs

-- Neue Views nachdem Institut eingefügt wurde
-- Wir haben die Architektur im Hintergrund (Ebene Intern) geändert,
-- wollen aber auf der Ebene Extern keine Sichtbare Änderung haben.
-- somit müssen bei internen änderungen nicht die UI der oberen Ebenen ändern.

Create View mitarbeiter_besucht_kurs As
Select pers_nr, vorname, nachname, kurs_bez, termin_kurs, institut 
from Mitarbeiter natural join besucht_kurs
natural join Kurs
natural join training_institut

Create VIEW V_Kurs As
SELECT kurs_nr, kurs_bez, institut
from Kurs natural join training_institut