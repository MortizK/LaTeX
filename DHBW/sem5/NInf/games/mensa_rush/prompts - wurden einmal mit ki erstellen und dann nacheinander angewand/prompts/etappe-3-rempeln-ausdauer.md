# Etappe 3 – Rempeln + Ausdauer

## Prompt (kopieren & einfügen, aktuelle HTML-Datei anhängen)

```
Hier ist meine bisherige Phaser-3-HTML-Datei (Mensa-Rush: Arena, 2 Spieler, Schnitzel-Tragen). Erweitere sie, weiterhin alles in EINER HTML-Datei mit Phaser 3.

Baue jetzt die Rempel-Mechanik mit Ausdauer ein:

1. Aktionstaste (befüllt das "action"-Feld im Input-Objekt): Spieler 1 = Shift (links), Spieler 2 = Enter
2. Drückt ein Spieler die Aktionstaste, macht er einen kurzen Dash in seine aktuelle Bewegungsrichtung (keine Richtung gedrückt → in die letzte Blickrichtung)
3. Trifft der Dash den gegnerischen Spieler:
   - Trägt der Getroffene das Schnitzel → dropSchnitzel() aufrufen
   - Der Getroffene bekommt einen kurzen Rückstoß
4. AUSDauer: Jeder Spieler hat eine Ausdauerleiste (sichtbar über dem Spieler oder am Bildschirmrand in seiner Farbe)
   - Ein Dash kostet 1/3 der Leiste
   - Leere Leiste → kein Dash möglich
   - Regeneration: volle Leiste nach ca. 2 Sekunden Nicht-Dashen (Werte im CONFIG)
5. KLAU-SCHUTZ: Nach jedem Schnitzel-Drop gibt es 1 Sekunde, in der NIEMAND dashen kann (Cooldown-Anzeige oder kurzer Hinweistext), damit kein Rempel-Ping-Pong entsteht
6. Kurzes visuelles Feedback beim Dash (z. B. kurzer Nachzieh-Effekt oder Scale-Puls)

Liefere die komplette aktualisierte HTML-Datei.
```

## ✅ Abnahmetest
- Dash funktioniert, Schnitzel kann geklaut werden
- Ausdauer verhindert Dauer-Spammen
- Nach einem Drop: 1 Sekunde kein Dash möglich

## ⏱ Aufwand: ~20 Min
