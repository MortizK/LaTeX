SELECT * From Mitarbeiter;

Select * FROM Mitarbeiter_projekt;

Select * from arbeitet_an;

Select * from leistung;

/*Lösungsweg*/
Select Pers_nr, ende_termin
from arbeitet_an
natural join leistung
where ende_termin is null;

Select Pers_nr from mitarbeiter_projekt
where pers_nr not in
(
	Select Pers_nr
	from arbeitet_an
	natural join leistung
	where ende_termin is null
);

select pers_nr, vorname, nachname from mitarbeiter
where pers_nr in
(
	Select Pers_nr from mitarbeiter_projekt
	where pers_nr not in
	(
		Select Pers_nr
		from arbeitet_an
		natural join leistung
		where ende_termin is null
	)
);

select pers_nr, vorname, nachname, projekterfahrung
from mitarbeiter natural join mitarbeiter_projekt
where pers_nr in
(
	select pers_nr from mitarbeiter
	where pers_nr in
	(
		Select Pers_nr from mitarbeiter_projekt
		where pers_nr not in
		(
			Select Pers_nr
			from arbeitet_an
			natural join leistung
			where ende_termin is null
		)
	)
);