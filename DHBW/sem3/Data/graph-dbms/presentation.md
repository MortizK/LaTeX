# 🎓 **Folienskizze – Graphenorientierte Datenbanksysteme**

---

## **Folie 1 – Titel & Einführung**

**Titel:**
*Graphenorientierte Datenbanksysteme (Graph DBMS)*

**Inhalt:**

* Kurs: *Datenbanken I*
* Gruppe: [Gruppennummer / Namen]
* Datum: [Datum einsetzen]
* Hochschule / Dozent: [optional]
* Kurzer Leitsatz:
  *„Beziehungen sind genauso wichtig wie Daten selbst.“*

**Sprechernotiz:**
Begrüßung, kurze Vorstellung der Gruppe und des Themas. Ziel: den Zuhörern zeigen, warum Graphdatenbanken heute so relevant sind.

---

## **Folie 2 – Einordnung: Datenbanksystem-Klassifizierungen**

**Titel:**
*Wo stehen Graphdatenbanken?*

**Inhalt (grafisch/diagrammgeeignet):**

* Überblick über gängige Datenbanktypen:

  * Relationale DBMS → Tabellen, Joins
  * Dokumentenorientierte DBMS → JSON-Dokumente
  * Key-Value-Stores → einfache Paare
  * Spaltenorientierte DBMS → Big Data / Analytics
  * **Graphenorientierte DBMS → Knoten & Kanten**
* Einordnungsdiagramm (z. B. NoSQL-Karte)

**Sprechernotiz:**
Erklären, dass es verschiedene Datenbankmodelle gibt, je nach Datenstruktur. Graphdatenbanken sind Teil der NoSQL-Familie und auf Beziehungen spezialisiert.

---

## **Folie 3 – Klassifizierung: Graphenorientierte DBMS**

**Titel:**
*Was ist ein Graphenorientiertes DBMS?*

**Inhalt:**

* Speichern Daten als **Knoten (Entities)** und **Kanten (Beziehungen)**
* Beziehungen sind **erstklassige Objekte**
* Typische Eigenschaften:

  * Flexible Schemata
  * Effiziente Traversierung von Beziehungen
  * Intuitive Modellierung realer Netzwerke
* Unterschied zu RDBMS: keine Tabellen, keine Joins

**Visualisierungsvorschlag:**
Ein einfacher Beispielgraph (z. B. „Alice kennt Bob“, „Bob arbeitet bei Firma X“)

**Sprechernotiz:**
Kurz die Idee vermitteln: Graphdatenbanken speichern Beziehungen direkt – kein Umweg über Tabellen oder Joins.

---

## **Folie 4 – Architektur & Konzepte**

**Titel:**
*Wie funktioniert eine Graphdatenbank?*

**Inhalt:**

* **Knoten (Nodes):** Entitäten, z. B. Person, Produkt
* **Kanten (Edges):** Beziehungen zwischen Knoten
* **Eigenschaften (Properties):** Schlüssel-Wert-Paare
* **Modelle:** Property Graph / RDF
* **Abfragesprachen:**

  * Cypher (Neo4j)
  * Gremlin (JanusGraph)
  * SPARQL (RDF-Daten)
  * GQL (Standard in Entwicklung)

**Grafikvorschlag:**
Schematische Darstellung eines Property Graphs + Beispiel einer Cypher-Abfrage.

**Sprechernotiz:**
Betonen, dass diese Struktur komplexe Verknüpfungen effizient abbildet und Abfragen wie „Freunde von Freunden“ in einem Schritt ermöglicht.

---

## **Folie 5 – Ausgewählte Produkte**

**Titel:**
*Bekannte Graphdatenbanksysteme*

**Inhalt (Kurzsteckbriefe):**

1. **Neo4j** – Marktführer, Cypher, GQL
2. **ArangoDB** – Multi-Modell (Graph, Dokument, Key-Value)
3. **Amazon Neptune** – Cloud-basiert (SPARQL, Gremlin)
4. **TigerGraph** – Hochperformant, GSQL
5. **JanusGraph** – Open Source, skalierbar
6. **OrientDB** – Multi-Modell, SQL-ähnlich
7. **RedisGraph** – In-Memory, leichtgewichtig

**Sprechernotiz:**
Jedes System kurz erwähnen – Fokus auf Unterschiede im Einsatz: Open Source vs. kommerziell, Cloud vs. On-Premise.

---

## **Folie 6 – Vergleichstabelle**

**Titel:**
*Vergleich ausgewählter Systeme*

**Inhalt (Tabelle):**

| System         | Lizenz          | Sprache         | SQL-Bezug | Stärken     | Schwächen          |
| -------------- | --------------- | --------------- | --------- | ----------- | ------------------ |
| **Neo4j**      | OS / Enterprise | Cypher          | Teilweise | Reif, GQL   | Lizenzkosten       |
| **ArangoDB**   | OS              | AQL             | Teilweise | Flexibel    | Weniger performant |
| **Neptune**    | Kommerziell     | SPARQL, Gremlin | Nein      | Cloud-nativ | AWS-gebunden       |
| **TigerGraph** | Kommerziell     | GSQL            | Nein      | Schnell     | Proprietär         |
| **JanusGraph** | OS              | Gremlin         | Nein      | Skalierbar  | Komplex            |
| **RedisGraph** | OS              | Cypher          | Nein      | Schnell     | Eingeschränkt      |

**Sprechernotiz:**
Die Tabelle zeigt auf einen Blick: Es gibt kein „bestes“ System, sondern das passende hängt vom Einsatzgebiet ab. Neo4j ist Standard, TigerGraph für Leistung, JanusGraph für Skalierung.

---

## **Folie 7 – Anwendungsfälle**

**Titel:**
*Wo kommen Graphdatenbanken zum Einsatz?*

**Inhalt (mit Symbolen oder Piktogrammen):**

* **Soziale Netzwerke:** Freundesbeziehungen, Community Detection
* **Empfehlungssysteme:** Produkte, Filme, Kontakte
* **Betrugserkennung:** Transaktionsmuster, Identitätsnetzwerke
* **Wissensgraphen:** semantische Verknüpfungen
* **IT-Netzwerke:** Systemabhängigkeiten, Monitoring

**Grafikidee:**
Kleine Icons + Stichworte in einem Netzwerkdiagramm.

**Sprechernotiz:**
Zeigen, dass Graphdatenbanken in der Praxis echte Mehrwerte schaffen, wenn Beziehungen im Vordergrund stehen.

---

## **Folie 8 – Fazit & Empfehlung**

**Titel:**
*Wann lohnt sich ein Graph-DBMS?*

**Inhalt:**
✅ Wenn **Beziehungen** im Mittelpunkt stehen
✅ Wenn Datenmodelle **komplex und dynamisch** sind
✅ Wenn **Performance bei Pfadabfragen** entscheidend ist

❌ Nicht ideal für klassische **Transaktionssysteme**
❌ Höhere Lernkurve bei Abfragesprachen

**Empfehlungen:**

* **Neo4j**: Einstieg & Standardlösung
* **TigerGraph / Neptune**: Enterprise-Anwendungen
* **JanusGraph / ArangoDB**: Open-Source-Projekte

**Sprechernotiz:**
Den Zuhörern eine klare Orientierung geben: Wann lohnt sich eine Graphdatenbank – und wann nicht.

---

## **Folie 9 – Quellen & weiterführende Literatur**

**Titel:**
*Quellen / Referenzen*

**Inhalt:**

* Neo4j Inc. (2024): *Neo4j Documentation*.
* DB-Engines Ranking (2025): *Popularity of Graph DBMS*.
* Amazon Web Services (2024): *Amazon Neptune Overview*.
* TigerGraph Inc. (2024): *Product Documentation*.
* Robinson, I. et al. (2020): *Graph Databases (O’Reilly Media).*

**Sprechernotiz:**
Kurz auf die Quellen verweisen und Studierende ermutigen, mit Neo4j oder ArangoDB selbst zu experimentieren.

---

# 🗣️ **Gesamte Sprechernotizen – Kurzüberblick**

| **Folie** | **Kernbotschaft / Betonung beim Vortrag**                         |
| --------- | ----------------------------------------------------------------- |
| 1         | Begrüßung, Thema vorstellen, Relevanz betonen                     |
| 2         | Graphdatenbanken als Teil der DB-Klassifikationen einordnen       |
| 3         | Definition und Abgrenzung – was ist das Besondere an Graph-DBs    |
| 4         | Funktionsweise (Knoten, Kanten, Traversierung) erklären           |
| 5         | Überblick über Produkte geben – Vielfalt zeigen                   |
| 6         | Vergleich der Systeme – betonen, dass Auswahl kontextabhängig ist |
| 7         | Praxisnahe Anwendungen aufzeigen – Relevanz verdeutlichen         |
| 8         | Fazit ziehen – wann lohnt sich ein Graph-DBMS, wann nicht         |
| 9         | Literatur nennen – zum Weiterlesen anregen                        |
