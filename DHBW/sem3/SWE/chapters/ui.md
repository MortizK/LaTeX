## UI-Struktur für genExam

### 1. Hauptlayout: Tabs

* **TabPane** (Hauptcontainer)

  * **Tab 1:** XML
  * **Tab 2:** PDF
  * **Button:** Import XML

---

### 2. Tab: XML

* **Layout:** `SplitPane` (horizontal)

  * **Linke Seite (Navigationsbereich)**

    * **TreeView**: Darstellung der Struktur

      * Root: Exam
      * Level 1: Kapitel / Task
      * Level 2: Subtask
    * **ContextMenu / Buttons:** Aktionen für ausgewähltes Element

      * Create new child
      * Edit / Delete (optional)
  * **Rechte Seite (Detailbereich)**

    * **VBox / BorderPane**

      * **Breadcrumb-Leiste:** Anzeige des Pfads der ausgewählten Node
        *(z.B. Exam > Kapitel 1 > Subtask 1 > Variante 1)*
      * **Formularbereich:** Bearbeitbare Attribute des ausgewählten Objektes

        * TextFields / ComboBoxes / CheckBoxes entsprechend der Attribute
        * Beispiel: Name, Punkte, Schwierigkeitsgrad, Sichtbarkeit
      * **Zusammenfassung (optional, nur bei Kapitel)**

        * Label oder TextArea mit Statistiken / Infos des Kapitels

          * Anzahl Subtasks
          * Gesamtpunktzahl
          * Schwierigkeit
      * **Tabelle der Kinderobjekte:** TableView

        * Spalten: Name, Typ, Punkte / Details je nach Objekttyp
        * **Buttons** (pro Zeile): Delete and (Edit or navigate to child)
        * **Button:** „Create new child“ für neue Subtasks / Varianten


---

### 3. Tab: PDF

* **Layout:** `SplitPane` (horizontal)

  * **PDF-Konfiguration**

    * Formularfelder für:

      * Zielpunktzahl
      * Schwierigkeitsgrad-Verteilung
      * PDF-Ausgabeoptionen (mock-exam, exam, ...)
  * **VBox / BorderPane**
    * **Buttons**

        * „Generate PDF“
        * „Generate Solution PDF“
    * **PDF-Vorschau**

        * ScrollPane mit eingebetteter PDF-Preview-Komponente

---

### 4. JavaFX-Komponenten Mapping (empfohlen)

| UI-Bereich            | JavaFX-Komponente                                        |
| --------------------- | -------------------------------------------------------- |
| TabPane               | `TabPane`                                                |
| Tab                   | `Tab`                                                    |
| Split XML             | `SplitPane(Orientation.HORIZONTAL)`                      |
| TreeView              | `TreeView<ExamElement>`                                  |
| Breadcrumb            | `HBox` + `Label` / `Button`                              |
| Detailform            | `VBox` + `Label` + `TextField` / `ComboBox` / `CheckBox` |
| Kinderobjekte Tabelle | `TableView<ExamElement>`                                 |
| Zusammenfassung       | `Label` / `TextArea`                                     |
| Buttons               | `Button`                                                 |
| PDF-Konfiguration     | `GridPane` / `Form`                                      |
| PDF Vorschau          | `ScrollPane` + `WebView` / `SwingNode` mit PDF Renderer  |

---
