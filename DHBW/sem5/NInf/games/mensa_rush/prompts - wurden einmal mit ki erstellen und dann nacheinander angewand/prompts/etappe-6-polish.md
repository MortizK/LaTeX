# Etappe 6 – Polish (nach Zeitbudget auswählen)

Nicht alles auf einmal prompten – **einen Baustein pro Prompt**, testen, dann der nächste. Immer die aktuelle HTML-Datei anhängen und dazuschreiben: "Weiterhin alles in EINER HTML-Datei mit Phaser 3, bestehende Mechaniken nicht verändern."

## Baustein A – Hindernisse
```
Füge der Mensa bewegliche Hindernisse hinzu:
1. Eine Ersti-Gruppe (3–4 graue Emojis 🧑‍🎓 im Pulk), die langsam auf festen Wegen durch die Mensa läuft und den Weg blockiert (Kollision mit Spielern)
2. Eine Wischschild-Zone "Rutschgefahr ⚠️" als markierter Bodenbereich: Spieler, die darüber laufen, rutschen kurz unkontrolliert weiter (reduzierte Steuerung, erhöhte Geschwindigkeit)
3. Ein Professor 🧑‍🏫, der gemächlich kreuz und quer geht: Remple ihn an → BEIDE Spieler müssen 2 Sekunden "Entschuldigung sagen" (betäubt, Text über Kopf: "😳 Entschuldigung, Herr Professor!")
```

## Baustein B – Items
```
Füge zufällig spawnende Items hinzu (alle 8–12 Sekunden eines, max. 2 gleichzeitig auf dem Feld, aufheben durch Berühren, Nutzung mit der Aktionstaste statt Dash):
1. Kaffee ☕: 4 Sekunden Laufspeed +40 % (sofort aktiv bei Aufheben)
2. Bananenschale 🍌: Kann mit Aktionstaste abgelegt werden; wer darauftritt, rutscht aus und verliert ein evtl. getragenes Schnitzel
Wenn ein Spieler ein Item trägt, ersetzt die Aktionstaste den Dash (Item wird verbraucht). Zeige das aktuelle Item als kleines Icon über dem Spieler.
```

## Baustein C – Sounds & Juice
```
Füge Soundeffekte und Game-Feel hinzu, ohne externe Audiodateien (Phaser WebAudio: Töne per Synthesizer/Oszillator erzeugen oder kurze generierte Sounds):
1. Dash: kurzer Whoosh
2. Rempel-Treffer: dumpfer Schlag + kurzer Screen-Shake
3. Schnitzel aufheben: "Ding"
4. Mampfen: rhythmisches Kauen bei jedem Mash-Wechsel
5. Sieg: kleine Fanfare
Zusätzlich: Partikel beim Schnitzel-Aufheben und beim Sieg (Konfetti).
```

## Baustein D – Endspurt-Event (Sudden Death)
```
Füge ein Endspurt-Event hinzu: Läuft eine Runde länger als 60 Sekunden, erscheint "Die Mensa schließt! 🚪" und der begehbare Bereich schrumpft langsam von den Rändern her (sichtbare Wandzone). Spieler außerhalb der Zone werden langsam zur Mitte geschoben. So wird ein Endlos-Stalemate verhindert.
```

## ✅ Abnahmetest (je Baustein)
- Das Neue funktioniert, alles Alte läuft weiter

## ⏱ Aufwand: Restzeit (je Baustein ~15 Min)
