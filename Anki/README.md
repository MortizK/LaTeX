# Anki

## Ziel

Dieses Dokument beschreibt den reproduzierbaren Ablauf, um aus einem einzelnen Modulpfad exakt 50 importierbare Anki-Karten als JSON zu erzeugen.

## Scope und Prioritaet

- Primärquelle: alle PDFs in `module_path/doc` (rekursiv).
- Sekundärquelle: PDFs/TeX direkt in `module_path` nur ergänzend.
- Bei Widersprüchen gilt immer die PDF-Quelle.
- Ergebnisdatei (Standard): `Anki/decks/<module-name>.json`.

## Erwartetes Ergebnisformat

Die Ausgabe muss valides JSON sein mit:

- `deckName`
- `modulePath`
- `cards` (exakt 50 Einträge)

Pro Karte:

- `type`: `basic|reversed|qa|cloze|calculation`
- `modelName`: `Basic` oder `Cloze`
- `fields`:
  - Für `basic|reversed|qa|calculation`: `Front` und `Back` befüllt, `Text` optional
  - Für `cloze`: `Text` mit mindestens einer Cloze-Markierung (`{{c1::...}}`), `Front` und `Back` leer
- `tags`: mindestens `DHBW`, `basis`
- `source`: immer mit `file` und `page`

## Reproduzierbarer Ablauf

1. Modulpfad und Deckname verbindlich festlegen, z. B. `DHBW/sem4/Network` und `network_anki`.
2. Quellenkontext ausschließlich mit `Anki/python/prepare_context.py` erzeugen.
3. Kandidaten ausschließlich mit `Anki/python/generate_candidates.py` erzeugen.
4. Kandidaten ausschließlich mit `Anki/python/finalize_deck.py` finalisieren.
5. Regeln validieren:
    - Genau 50 Karten
    - Keine leeren Karten
    - Jede Karte hat valide `source.file` und `source.page`
    - Cloze-Regeln eingehalten
6. Finale JSON wird standardmäßig nach `Anki/decks/<module-name>.json` geschrieben.

## Minimale technische Schritte (Windows)

1. Python-Umgebung aktivieren/konfigurieren.
2. Paket installieren:

```powershell
c:/Users/moritz/Documents/LaTeX/.venv/Scripts/python.exe -m pip install pypdf
```

3. Quellenkontext erzeugen (nur Skript unter `Anki/python`):

```powershell
c:/Users/moritz/Documents/LaTeX/.venv/Scripts/python.exe c:/Users/moritz/Documents/LaTeX/Anki/python/prepare_context.py --module-path c:/Users/moritz/Documents/LaTeX/DHBW/sem4/Network
```

4. Kandidaten erzeugen (nur Skript unter `Anki/python`):

```powershell
c:/Users/moritz/Documents/LaTeX/.venv/Scripts/python.exe c:/Users/moritz/Documents/LaTeX/Anki/python/generate_candidates.py --module-path c:/Users/moritz/Documents/LaTeX/DHBW/sem4/Network
```

5. Kandidaten finalisieren (nur Skript unter `Anki/python`):

```powershell
c:/Users/moritz/Documents/LaTeX/.venv/Scripts/python.exe c:/Users/moritz/Documents/LaTeX/Anki/python/finalize_deck.py --module-path c:/Users/moritz/Documents/LaTeX/DHBW/sem4/Network --candidates c:/Users/moritz/Documents/LaTeX/DHBW/sem4/Network/doc/candidates.json --deck-name network_anki --target 50 --strict
```

6. Ergebnis prüfen (optional):

```powershell
c:/Users/moritz/Documents/LaTeX/.venv/Scripts/python.exe -c "import json; p=r'c:/Users/moritz/Documents/LaTeX/Anki/decks/Network.json'; d=json.load(open(p,encoding='utf-8')); print('cards',len(d['cards']))"
```

## Generischer Prompt (Copy-Paste)

Nutze den folgenden Prompt 1:1 und ersetze nur die Platzhalter in spitzen Klammern.

```text
Du bist ein Lernassistent fuer DHBW-Module und erzeugst importierbare Anki-Karteikarten als JSON.

Kontext:
- Arbeitsverzeichnis: <WORKSPACE_ROOT>
- Modulpfad: <MODULE_PATH> (PFLICHT, z. B. DHBW/sem4/Network)
- Deckname: <DECK_NAME> (PFLICHT)

Pflicht am Start:
1) Wenn <MODULE_PATH> fehlt: zuerst nachfragen und nicht fortfahren.
2) Wenn <DECK_NAME> fehlt: zuerst nachfragen und nicht fortfahren.

Nicht verhandelbare Regeln:
1) Nutze ausschliesslich die bestehende Pipeline unter Anki/python.
2) Keine eigene PDF-Extraktion ausserhalb dieser Skripte.
3) Primaerquelle sind PDFs unter <MODULE_PATH>/doc (rekursiv).
4) Sekundaerquellen (<MODULE_PATH>/*.pdf, <MODULE_PATH>/*.tex) nur ergaenzend.
5) Bei Widerspruechen hat PDF-Inhalt aus doc Prioritaet.
6) Es muessen mindesten 50 finale Karten entstehen.

Ziel der Karten:
- Niveau: Basis (pruefungsorientiert)
- Sprache: Deutsch
- Antworten: kurz und praezise (typisch 1 Satz)
- Kartentypen als weicher Mix:
  - basic
  - reversed
  - qa
  - cloze
  - calculation (nur wenn fachlich sinnvoll)

Schema-Regeln fuer Kandidatenkarten:
- Erlaubte Typen: basic|reversed|qa|cloze|calculation
- Bei cloze:
  - fields.Text muss mindestens eine Cloze enthalten, z. B. {{c1::...}}
  - fields.Front und fields.Back muessen leer sein
- Bei non-cloze (basic/reversed/qa/calculation):
  - fields.Front und fields.Back muessen befuellt sein
- source.file und source.page sind pro Karte Pflichtangaben
- tags sollen mindestens DHBW und basis enthalten

Ausgabeformat fuer Kandidaten:
- Entweder JSON-Objekt mit Key "cards" oder direkt JSON-Array von Karten.
- Keine Erklaertexte, kein Markdown, nur valides JSON.

Ablauf (verbindlich):
1) Fuehre prepare_context.py aus:
   python Anki/python/prepare_context.py --module-path <WORKSPACE_ROOT>/<MODULE_PATH>

2) Fuehre generate_candidates.py aus:
  python Anki/python/generate_candidates.py --module-path <WORKSPACE_ROOT>/<MODULE_PATH>

3) Lies <MODULE_PATH>/doc/candidates.json und validiere das Schema stichprobenartig.

4) Fuehre Finalisierung aus:
   python Anki/python/finalize_deck.py --module-path <WORKSPACE_ROOT>/<MODULE_PATH> --candidates <WORKSPACE_ROOT>/<MODULE_PATH>/doc/candidates.json --deck-name <DECK_NAME> --target 50 --strict

5) Liefere als Endergebnis ausschliesslich:
  <WORKSPACE_ROOT>/Anki/decks/<MODULE_NAME>.json

Qualitaetskriterien vor Abschluss:
- Genau 50 Karten in <MODULE_NAME>.json
- Keine leeren Karten
- Keine semantischen Duplikate
- Jede Karte hat source.file und source.page
- modelName ist konsistent (Cloze bei cloze, sonst Basic)

Kartenobjekt (Beispielstruktur):
{
  "cards": [
    {
      "type": "basic|reversed|qa|cloze|calculation",
      "modelName": "Basic|Cloze",
      "fields": {
        "Front": "",
        "Back": "",
        "Text": "",
        "Extra": ""
      },
      "tags": ["DHBW", "basis"],
      "source": {
        "file": "skript.pdf",
        "page": 12
      }
    }
  ]
}
```

## Lessons Learned aus diesem Chat

- In PowerShell keine Bash-Heredoc-Syntax `<<'PY'` verwenden.
- Bei exakt 50 Karten immer final zählen und hart validieren.
- Nach Undo/externen Änderungen Dateistand erneut prüfen, bevor weitergeschrieben wird.
- Bei Such-/Ignore-Problemen notfalls direkte Dateileseoperation statt Search-Index verwenden.
