# Datenbanken I - Aufgabentypen und Fragenkatalog

## Übersicht

Dieses Verzeichnis enthält umfangreiche Materialien zur Vorbereitung auf Klausuren in Datenbanken I.

### Dateien

#### 1. **fragenkatalog_komplett.tex**
Erweitert mit zusätzlichen Grundlagen-Aufgaben (Probeklausur-Stil)

**Inhalte:**
- Original Fragenkatalog mit ~100+ Fragen zu Konzepten, Normalisierung, SQL, etc.
- **NEU**: Zusätzliche 12 Grundlagen-Aufgaben am Ende des Dokuments
  - Diese folgen dem Muster von "Aufgabenteil 1" der Probeklausur
  - Themen: DBMS-Architektur, Datenmodelle, ERM, Normalisierung, Relationale Algebra, etc.
  - Ideal zur Vorbereitung auf konzeptionelle Fragen in der Klausur

**Verwendung:**
```bash
pdflatex fragenkatalog_komplett.tex
```

---

#### 2. **Aufgabentypen.tex** (NEU)
Umfassender Leitfaden zu allen Aufgabentypen mit Lösungsmethoden

**Inhalte:**

##### Aufgabenteil 2 - ERM-Modellierung
- **Szenario aus Probeklausur**: PC-Verkauf mit Komponentenkonfiguration
- **Vorgehen (7 Schritte)**:
  1. Szenario analysieren
  2. Beziehungen definieren
  3. Attribute festlegen
  4. Primärschlüssel wählen
  5. Kardinalitäten notieren
  6. Existenzabhängigkeiten identifizieren
  7. ER-Diagram zeichnen
- **Lösungsansatz**: Mit Tabellen und Chen-Notation
- **Wichtige Tipps**: Wie man Entitäten identifiziert und Kardinalitäten korrekt notiert

##### Aufgabenteil 3 - Relationale Algebra
- **Aufgabenszenario**: Abfrage nach Artikeln, die Kunde "Maier" bestellt hat
- **Vorgehen (3 Schritte)**:
  1. Abfrage verstehen
  2. Entities und Beziehungen identifizieren
  3. Logische Schritte aufgliedern
- **Lösung in Relationaler Algebra**: Mit Kreuzprodukt
- **SQL-Statement**: Ohne JOIN-Syntax
- **Operator-Referenz**: σ, π, ×, ⋈, ∪, −, ∩

##### Aufgabenteil 4 - Normalisierung
- **Aufgabenszenario**: Relationsschema mit funktionalen Abhängigkeiten analysieren
- **4 Teilaufgaben mit Lösungsmethode**:
  1. **Schlüsselkandidaten bestimmen** (5 Schritte)
     - Linke Seite der FA analysieren
     - Attribute klassifizieren
     - Kandidatenschlüssel suchen
     - Minimalität prüfen
  2. **Normalform bestimmen** (mit Definitionen: 1NF, 2NF, 3NF, BCNF)
  3. **Zerlegung durchführen** (mit Beispielen)
  4. **Verlustlosigkeit und Abhängigkeitsbewahrung prüfen**
- **Synthese-Algorithmus**: Für komplexe Normalisierungsaufgaben

**Verwendung:**
```bash
pdflatex Aufgabentypen.tex
```

---

## Klausur-Vorbereitung - Schritt für Schritt

### Phase 1: Konzeptionelle Grundlagen
- Arbeite durch den **Fragenkatalog** (original)
- Stelle Fragen zu: Datenmodellen, Architektur, Normalisierung

### Phase 2: Vertiefung und Probeklausur
- Lerne die **zusätzlichen Grundlagen-Aufgaben** (neuer Abschnitt)
- Diese entsprechen der Art von Fragen in der Probeklausur Aufgabenteil 1

### Phase 3: Aufgabentypen trainieren
- Arbeite systematisch durch **Aufgabentypen.tex**
- **Aufgabenteil 2**: Trainiere ERM-Modellierung
- **Aufgabenteil 3**: Trainiere Relationale Algebra + SQL
- **Aufgabenteil 4**: Trainiere Normalisierung

### Phase 4: Probeklausur lösen
Nutze die Dateien als Referenz während du die Probeklausur durcharbeitest:
```
Probe_Klausur Ges_ohne.pdf
```

---

## Aufgabentypen im Überblick

| Typ | Thema | Datei | Schwierigkeit |
|-----|-------|-------|--------------|
| 1 | Grundlagen-Fragen | fragenkatalog_komplett.tex | ⭐⭐ |
| 2 | ERM-Modellierung | Aufgabentypen.tex | ⭐⭐⭐ |
| 3 | Relationale Algebra | Aufgabentypen.tex | ⭐⭐⭐ |
| 4 | Normalisierung | Aufgabentypen.tex | ⭐⭐⭐⭐ |

---

## Tipps und Tricks

### Für ERM-Aufgaben:
- Lest das Szenario mehrmals gründlich durch
- Markiert alle Substantive → potenzielle Entities
- Markiert alle Verben → potenzielle Beziehungen
- Fragt euch: "Kann dieses Entity ohne das andere existieren?"

### Für Relationale Algebra-Aufgaben:
- Denkt in Schritten: Erst filtern (σ), dann projizieren (π)
- Kreuzprodukt kombiniert alle Tupel - oft ist ein Join besser
- Schreibt alle benötigten Tabellen auf, bevor ihr anfangt

### Für Normalisierungs-Aufgaben:
- Bestimmt zuerst **alle** Schlüsselkandidaten
- Überprüft systematisch auf 1NF → 2NF → 3NF
- Merkt euch: 2NF problematisch, wenn PK aus mehreren Attributen besteht
- Transitive Abhängigkeiten sind der Grund für Zerlegung zu 3NF

---

## Zusätzliche Ressourcen

- **Vollvorlesung**: Datenbanken I komplett.pdf
- **Probeklausur**: Probe_Klausur Ges_ohne.pdf
- **Diese Dateien**: Fragenkatalog und Aufgabentypen

---

## Fragen und Feedback

Falls weitere Aufgaben hinzugefügt oder Erklärungen verbessert werden sollen, können die Dateien 
problemlos erweitert werden. Die Struktur ist modular aufgebaut.

---

**Viel Erfolg bei der Klausur! 📚**
