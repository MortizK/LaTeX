# Etappe 1 – Arena + 2 Spieler

## Prompt (kopieren & einfügen, aktuelle HTML-Datei anhängen)

```
Hier ist meine bisherige Phaser-3-HTML-Datei (Mensa-Rush). Erweitere sie, ohne das Bestehende kaputt zu machen. Weiterhin alles in EINER HTML-Datei mit Phaser 3.

Baue jetzt die Arena und zwei lokale Spieler:

1. Mensa als Draufsicht (alles mit einfachen Phaser-Formen/Rechtecken und Emojis, keine Bild-Assets):
   - Eine Ausgabetheke als breites Rechteck oben in der Mitte
   - Zwei Tische: einer unten links (Farbe Blau), einer unten rechts (Farbe Rot) – das sind die "Heimattische" der Spieler
   - Wände als Spielfeldrand
2. Zwei Spieler als farbige Kreise mit Emoji (🧑‍🎓): Spieler 1 (blau) startet unten links, Spieler 2 (rot) unten rechts
3. Steuerung: Spieler 1 = WASD, Spieler 2 = Pfeiltasten
4. Kollisionen: Spieler können sich gegenseitig, die Theke, Tische und Wände nicht durchdringen (Arcade Physics, collide)
5. WICHTIGE STRUKTUR-REGEL: Die Spieler-Logik darf die Tastatur NICHT direkt abfragen. Jeder Spieler besitzt ein Input-Objekt { up, down, left, right, action }, das pro Frame gesetzt wird. Die Tastatur ist nur EINE Quelle, die dieses Objekt befüllt (später kommt eine Netzwerk-Quelle dazu). Die Bewegungslogik liest ausschließlich das Input-Objekt.
6. Spieler werden dynamisch über eine Funktion addPlayer(id, name, color, inputSource) erzeugt – nicht fest verdrahtet, damit später bis zu 10 Spieler möglich sind.
7. Laufgeschwindigkeit als Konstante im CONFIG-Objekt.

Liefere die komplette aktualisierte HTML-Datei.
```

## ✅ Abnahmetest
- Beide Spieler laufen mit ihrer Tastaturbelegung
- Kollisionen mit Theke, Tischen, Wänden und untereinander funktionieren

## ⏱ Aufwand: ~20–30 Min
