Alter Table mitarbeiter
drop constraint mitarbeiter_arbeitet_in_fkey,
add FOREIGN KEY (arbeitet_in) REFERENCES Abteilung on Delete set null;