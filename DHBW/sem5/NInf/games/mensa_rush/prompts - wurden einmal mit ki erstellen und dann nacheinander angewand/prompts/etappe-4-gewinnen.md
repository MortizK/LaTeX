# Etappe 4 – Essen & Gewinnen

## Prompt (kopieren & einfügen, aktuelle HTML-Datei anhängen)

```
Hier ist meine bisherige Phaser-3-HTML-Datei (Mensa-Rush: Arena, Spieler, Schnitzel, Rempeln). Erweitere sie, weiterhin alles in EINER HTML-Datei mit Phaser 3.

Baue jetzt die Siegbedingung ein – das Aufessen am eigenen Tisch:

1. Der Schnitzel-Träger muss das Schnitzel zu SEINEM Heimattisch (seine Farbe) tragen
2. Erreicht der Träger seinen Tisch, beginnt automatisch das Essen:
   - Der Spieler kann sich während des Essens NICHT bewegen
   - Ein Fortschrittsbalken erscheint über dem Tisch
   - MASH-MECHANIK: Der essende Spieler muss seine Bewegungstasten im Wechsel drücken (z. B. Spieler 1: abwechselnd A und D, Spieler 2: abwechselnd Pfeil links und rechts). Jeder gültige Wechsel füllt den Balken. Voll nach ca. 25 schnellen Wechseln (Wert im CONFIG). Gleiche Taste zweimal hintereinander zählt nicht.
   - Beim Essen wird ein Ess-Geräusch-Text wie "MAMPF!" oder ein Chomp-Emoji über dem Spieler angezeigt
3. Wird der Essende angerempelt → dropSchnitzel() und der Fortschrittsbalken ist komplett weg
4. Verlässt ein Träger den Tisch ohne fertig zu essen (falls möglich), bleibt er Träger
5. Ist der Balken voll → RUNDE GEWONNEN:
   - Großer Gewinner-Text: "🏆 SCHNITZELKÖNIG: [Spielername/Farbe]!"
   - Hinweis: "Leertaste = Revanche"
   - Leertaste startet eine komplett neue Runde (alle Positionen, Schnitzel, Ausdauer zurückgesetzt)

Liefere die komplette aktualisierte HTML-Datei.
```

## ✅ Abnahmetest
- Kompletter Pfad: Schnitzel holen → zum Tisch → mampfen → Sieg → Revanche
- Rempler während des Essens bricht den Fortschritt korrekt ab
- Mash zählt nur echte Wechsel

## ⏱ Aufwand: ~20 Min
