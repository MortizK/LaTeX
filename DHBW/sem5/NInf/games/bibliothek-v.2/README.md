# Escape the Library

## 1. Kurzbeschreibung

**Escape the Library** ist ein kleines Horror-Escape-Spiel im Pixel-Art-Stil. Die
Spielerin oder der Spieler bleibt nach Feierabend in der Bibliothek zurück und
muß drei zufällig ausgewählte Bücher aus dem Buchkatalog finden, während sich leicht rot dargestellte
Studierende durch die Regalreihen bewegen. Nach dem Einsammeln aller Bücher muß
der grüne Ausgang erreicht werden, bevor die Nacht vorbei ist oder ein NPC den
Spieler berührt.

## 2. Ziel und Spielende

### Hauptziel

1. Das aktuell gesuchte Buch finden.
2. Die richtige Regalreihe über das Schild identifizieren.
3. Das zugehörige Regalfach öffnen.
4. Im Fach mit den Pfeiltasten durch die Bücher blättern.
5. Das korrekte Buch mit `E` einsammeln.
6. Dies für alle drei Bücher wiederholen.
7. Den Ausgang unten rechts erreichen.

### Sieg

Das Spiel ist gewonnen, wenn alle drei Bücher eingesammelt wurden und der
Spieler den Ausgang erreicht.

### Game Over

Das Spiel endet mit Game Over, wenn:

- ein NPC den Spieler berührt,
- die Uhrzeit das Ende der Nacht erreicht,
- oder eine andere ausdrücklich als gefährlich definierte NPC-Interaktion
  hinzugefügt wird.

Nach Sieg oder Game Over kann mit `Enter` oder `R` ein neues Spiel gestartet
werden.

## 3. Buchkatalog und Fachbereiche

Die vollständige Buchsammlung liegt in [books.csv](./books.csv). Die Datei
enthält genau 100 exemplarische Bücher mit der verbindlichen Struktur:

```csv
Titel,Fachbereich,Regalfach,Modul
```

Jede Datenzeile beschreibt ein Buch. Ein Regalfach darf mehrfach vorkommen und
enthält dann mehrere Bücher. Die CSV ist die zentrale Datenquelle für die
Buchauswahl.

Es gibt genau vier Fachbereiche:

| Fachbereich | Kürzel | Regalreihen |
|---|---|---:|
| Informatik | INF | 2 |
| Medien | MED | 1 |
| Wirtschaft | WIR | 1 |
| Technik | TEC | 2 |

Ein Fachbereich wird durch eine oder zwei Regalreihen repräsentiert. Die
Regalfach-IDs im CSV, zum Beispiel `INF-A01` oder `TEC-A17`, ordnen jedes Buch
einem einzelnen Fach zu.

Beim Start einer neuen Runde werden aus allen 100 CSV-Einträgen drei
verschiedene Bücher ohne Ersatz ausgewählt. Diese drei Bücher werden
nacheinander gesucht. Die Auswahl darf keine doppelten Einträge erzeugen und
muß ausschließlich aus gültigen CSV-Datensätzen bestehen.

Das HUD zeigt das aktuelle Ziel und den Fortschritt im Format
`GESUCHT: <Titel> [gesammelt/3]`.

## 4. Steuerung

| Eingabe | Funktion |
|---|---|
| `W`, `A`, `S`, `D` | Spieler bewegen |
| Pfeiltasten | Spieler bewegen |
| `E` | Schild lesen oder Regalfach öffnen bzw. Buch einsammeln |
| `Pfeil links` / `Pfeil rechts` | Im geöffneten Regalfach durch Bücher blättern |
| `Enter` | Spiel starten bzw. nach Spielende neu starten |
| `R` | Spiel neu starten |
| `Esc` | Schild- oder Fachansicht schließen |

Die Bewegung erfolgt tilebasiert. Der Spieler kann nicht durch Wände oder
Regale laufen.

## 5. Bibliothek und Regalstruktur

Die Karte besteht aus einem Tile-Raster mit einer Auflösung von `25 x 17`
Tiles. Das Canvas hat eine logische Größe von `800 x 600` Pixeln und wird
responsive mit `Phaser.Scale.FIT` skaliert.

Die Regalreihen sind dicht angeordnet:

- Zwischen zwei Regalreihen liegen genau zwei freie Tiles.
- Regale blockieren die Bewegung.
- Die Regalreihen bestehen aus einzelnen Regal-Tiles.
- Jedes Regal-Tile entspricht genau einem Regalfach.
- Jedes Fach ist interaktiv und enthält ein oder mehrere Bücher aus der CSV.
- Jedes Regal-Tile zeigt einen braunen Rahmen, dunkle Fächer, Bretter und
  kleine Buchrücken.

### Schilder und Regalfächer

Schilder und Regalfächer sind zwei getrennte interaktive Elemente.

#### Schild

- Ein Schild steht am Ende beziehungsweise am oberen Anfang einer
  Regalreihe.
- Das Schild trägt das Kürzel oder die fachliche Richtung der Reihe.
- Die Interaktion mit `E` öffnet `SignScene`.
- Das Schild informiert über den fachlichen Inhalt der Regalreihe.
- Das Lesen des Schildes ist nicht erforderlich, um das Fach zu öffnen.

#### Regalfach

- Jedes Fach ersetzt genau ein Tile innerhalb der zugehörigen Regalreihe.
- Die Interaktion mit `E` öffnet direkt `BookSearchScene` und zeigt alle Bücher,
  deren CSV-Eintrag dasselbe `Regalfach` besitzt.
- Das Fach ist direkt sowie von den vier orthogonal benachbarten Tiles aus
  erreichbar:
  - oben,
  - unten,
  - links,
  - rechts.
- Diagonale Tiles zählen nicht als gültige Interaktionsposition.
- Im Fach wird mit den linken und rechten Pfeiltasten geblättert.
- Das richtige Buch wird mit `E` eingesammelt.
- Ein falsches Buch kann nicht eingesammelt werden; die Fachansicht bleibt
  geöffnet.

Die Schilder stehen an den jeweiligen Enden ihrer Regalreihen und beschreiben
den Fachbereich oder die fachliche Richtung der Reihe. Das Schild beschreibt
nicht nur ein einzelnes Buch und muß nicht gelesen werden, um ein Regalfach zu
öffnen.

## 6. NPCs und Schwierigkeit

Die Bibliothek enthält mehrere leicht rot dargestellte NPCs. Die NPCs:

- kollidieren mit Wänden und Regalen,
- bewegen sich nur auf freien Tiles,
- wählen zufällige Ziele in ihrer Umgebung,
- können den Spieler aus kurzer Distanz verfolgen,
- bewegen sich mit steigender Uhrzeit häufiger,
- lösen bei Berührung sofort Game Over aus.

Die Schwierigkeit steigt außerdem mit jedem eingesammelten Buch:

- die Bewegungsgeschwindigkeit des Spielers sinkt,
- die NPCs werden aktiver,
- die verbleibende Gefahr nimmt dadurch zu.

Die Wegsuche muß die blockierten Regal-Tiles berücksichtigen. Für die kleine
Karte ist eine gridbasierte Wegsuche, zum Beispiel BFS oder A*, ausreichend.

## 7. Sicht und Gefahr

### Fog of War

Der Spieler kann nur einen begrenzten Radius um die eigene Position sehen.
Außerhalb dieses Radius wird die Karte durch einen dunklen, abgestuften Fog of
War verdeckt. Der sichtbare Bereich folgt dem Spieler bei jeder Bewegung.

Der Fog of War darf folgende Elemente nicht verdecken:

- die HUD-Leiste,
- Dialoge und Overlay-Szenen,
- die aktuelle Interaktionsansicht.

### Rote Gefahrenvignette

Wenn sich ein NPC dem Spieler nähert, wird eine transparente rote Vignette
eingeblendet. Je näher der NPC kommt, desto stärker wird die Vignette. Bei
Berührung endet das Spiel sofort.

## 8. Zeit und HUD

Das Spiel startet um `21:00`. Die Uhr läuft während des Spiels weiter. Die
Bewegungshäufigkeit der NPCs steigt mit fortschreitender Uhrzeit. Das Spiel
endet spätestens am definierten Ende der Nacht.

Die HUD-Struktur besteht aus zwei Reihen:

### Erste Reihe

- **oben links:** Steuerungshinweis
- **oben rechts:** aktuelle Uhrzeit im festen Format `HH:MM`, zum Beispiel
  `21:00`

### Zweite Reihe

- **horizontal zentriert:** aktuell gesuchtes Buch und Sammelfortschritt,
  beispielsweise `GESUCHT: Datenbanken [0/3]`

Nach dem Einsammeln aller Bücher zeigt die zweite Reihe stattdessen an, dass
der Ausgang gesucht wird.

## 9. Art-Style und Audio

### Grafik

- Pixel-Art mit kleinen, klaren Formen
- kleine Assets beziehungsweise Pixelstrukturen
- überwiegend Schwarz, Weiß und Grautöne
- Braun für Regale und Fächer
- Hellrot für NPCs
- Rot als Gefahrensignal
- Grün für den Ausgang
- keine externen Bild-Assets erforderlich

Die Spielfiguren, Regale, Fächer, Schilder und der Ausgang werden direkt im
Browser mit Phaser-Geometrien und Text gezeichnet.

### Audio

Kurze Soundeffekte werden über WebAudio erzeugt, unter anderem für:

- Bewegung,
- falsche Buchauswahl,
- erfolgreiches Einsammeln,
- Spielstart.

Audiofehler dürfen das Spiel nicht beenden; in diesem Fall wird der Sound
deaktiviert und das Spiel läuft weiter.

## 10. Technische Vorgaben

- Phaser 3 wird über CDN eingebunden.
- Das Spiel besteht aus `index.html` und der Datenquelle `books.csv`.
- HTML, CSS und JavaScript befinden sich inline in `index.html`.
- `books.csv` liegt im selben Verzeichnis und wird als UTF-8-CSV gelesen.
- Es werden keine Build-Schritte und keine externen Bild-Assets benötigt.
- Die Canvas-Größe beträgt logisch `800 x 600`.
- Die Skalierung erfolgt responsiv mit `Phaser.Scale.FIT`.
- Die Darstellung verwendet Pixel-Art-Rendering.
- Der Code muß kommentiert, lesbar und in klar getrennte Szenen gegliedert
  sein.

### Verbindliche Szenenstruktur

| Szene | Verantwortung |
|---|---|
| `BootScene` | Titelbildschirm und Spielstart |
| `GameScene` | Karte, Spieler, NPCs, Zeit, HUD und Hauptspiel |
| `GameOverScene` | Sieg- und Game-Over-Anzeige |
| `SignScene` | Lesen der fachlichen Regalbeschriftung |
| `BookSearchScene` | Anzeigen aller Bücher eines Fachs und Einsammeln eines Buches |

## 11. Qualitäts- und Abnahmekriterien

Die Implementierung ist vollständig, wenn alle folgenden Punkte erfüllt sind:

- Die Datei lässt sich direkt im Browser öffnen und startet ohne Build-Prozess.
- Die Datei `books.csv` enthält genau 100 Datenzeilen plus Kopfzeile.
- Jede CSV-Zeile enthält genau die Felder `Titel`, `Fachbereich`, `Regalfach`
  und `Modul`.
- Alle vier Fachbereiche sind im Katalog vertreten.
- Aus dem Katalog werden pro Runde genau drei verschiedene Suchbücher gewählt.
- `Enter` führt vom Titelbildschirm in das Spiel.
- Der Spieler kann mit WASD und Pfeiltasten laufen.
- Wände und Regale sind nicht durchlaufbar.
- Die Uhr wird immer im Format `HH:MM` angezeigt.
- Das gesuchte Buch steht zentriert in der zweiten HUD-Zeile.
- Schilder und Regalfächer sind getrennte Interaktionsziele.
- Ein Schild zeigt die Fachrichtung seiner Regalreihe.
- Ein Regalfach öffnet die Buchsuche direkt, ohne vorheriges Schildlesen.
- Die Buchsuche zeigt alle Bücher des jeweiligen `Regalfach`-Werts.
- Ein Regalfach ist von allen vier orthogonalen Nachbartiles erreichbar.
- Das richtige Buch kann gefunden und eingesammelt werden.
- Falsche Bücher können nicht eingesammelt werden.
- Alle drei Bücher müssen vor dem Ausgang gesammelt werden.
- NPCs bewegen sich nicht durch Regale.
- Der Fog of War folgt dem Spieler.
- Die rote Vignette reagiert auf die Distanz zu NPCs.
- Berührung mit einem NPC führt zu Game Over.
- Der Ausgang führt nach dem Einsammeln aller Bücher zum Sieg.

## 12. Erweiterungsideen

1. Verschiedene NPC-Typen mit unterschiedlichen Sichtweiten,
   Geschwindigkeiten und Verhaltensmustern.
2. Power-ups wie Taschenlampe, Versteck oder kurzzeitige Unsichtbarkeit.
3. Zufällig erzeugte Bibliothekslayouts und wechselnde Buchpositionen.
4. Zusätzliche Soundkulisse mit Schritten, Türgeräuschen und Umgebungsrauschen.
5. Ein Hauptmenü mit Schwierigkeitsgraden und Bestzeiten.
