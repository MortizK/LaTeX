## 1. Grundprinzipien der Komponenten

**Ziel:** Jede UI-Funktionalität, die wiederverwendbar ist oder eine klare Verantwortung hat, wird zu einer Komponente. Komponenten können selbst wieder UI-Elemente enthalten, z.B. Buttons, Tabellen, Dialoge.

---

## 2. Komponenten für das XML-Tab

### A. TreeView-Komponenten

* **`ExamTreeView`**

  * Zeigt die gesamte Exam-Struktur (Exam > Kapitel > Subtask)
  * Methoden:

    * `selectNode(ExamElement element)`
    * `refresh()`
  * Events:

    * `onNodeSelected(ExamElement)`
    * `onNodeContextMenu(ExamElement)` → zeigt PopUpMenu (Delete/Edit/Create)

* **`TreeNodeContextMenu`** (Popup)

  * Kontextmenü für jede Node
  * Optionen:

    * Create Child (Subtask/Variante)
    * Edit
    * Delete
  * Bindung an `ExamElement`

---

### B. Detail-Formular-Komponenten

* **`ExamElementDetailPane`**

  * Zeigt Attribute des aktuell ausgewählten Objekts
  * Dynamisch angepasst nach Typ: Exam, Kapitel, Subtask, Variante
  * Bestandteile:

    * `BreadcrumbBar`
    * Attribute Form (`VBox` mit Labels + TextFields / ComboBoxes)
    * **Kinder-Tabelle** (falls relevant)
    * **Create New Child Button**
  * Methoden:

    * `bindTo(ExamElement element)` – zeigt Details
    * `updateElement()` – speichert Änderungen

* **`BreadcrumbBar`**

  * Zeigt Pfad der ausgewählten Node
  * Klick auf Segment → Auswahl im TreeView

* **`ChildObjectTable`**

  * `TableView<ExamElement>` für Kinder (Subtasks/Varianten)
  * Jede Zeile (`ExamElementRow`) enthält:

    * Name, Typ, Punktzahl (je nach Typ)
    * Edit/Delete Buttons → öffnet PopUp

---

### C. PopUp-Komponenten

* **`EditDialog`**

  * Eingabeformular für Attribute des Objekts
  * Buttons: Save / Cancel
  * Rückgabe: geändertes Objekt
* **`DeleteConfirmationDialog`**

  * Text: „Sind Sie sicher, dass Sie [Objektname] löschen?“
  * Buttons: Yes / No

---

### D. Reusable Sub-Components

* **`ExamElementRow`**

  * Repräsentiert eine Zeile in `ChildObjectTable`
  * Bindet an `ExamElement`
  * Enthält:

    * Labels für Attribute
    * Buttons für Edit/Delete → ruft PopUp auf
* **`CreateChildButton`**

  * Kontextabhängig: erzeugt Subtask / Variante für ausgewähltes Element
  * Kann in DetailPane oder TableRow verwendet werden

---

## 3. Komponenten für PDF-Tab

* **`PDFConfigPane`**

  * Formular für PDF-Optionen
  * GridPane oder VBox
* **`PDFPreviewPane`**

  * Zeigt generierte PDF als Vorschau
  * `WebView` oder `SwingNode` mit PDF-Renderer
* **`PDFActionButtons`**

  * Generate PDF
  * Generate Solution PDF
  * Generate Mock Exam

---

## 4. Komponenten-Hierarchie (Beispiel)

```
TabPane
├─ XMLTab
│   ├─ SplitPane
│   │   ├─ ExamTreeView
│   │   └─ ExamElementDetailPane
│   │       ├─ BreadcrumbBar
│   │       ├─ AttributeForm
│   │       ├─ ChildObjectTable
│   │       │   └─ ExamElementRow (Edit/Delete Button → PopUp)
│   │       └─ CreateChildButton
│   └─ TreeNodeContextMenu (Popup)
├─ PDFTab
│   ├─ PDFConfigPane
│   ├─ PDFPreviewPane
│   └─ PDFActionButtons
```

---

💡 **Tipps zur Implementierung:**

* Jedes Objekt (`Exam`, `Chapter`, `Subtask`, `Variant`) kann ein **JavaFX-Model** sein, das direkt an TreeView und TableView gebunden wird.
* PopUps/Dialoge sind **eigene Components**, die vom TreeView oder TableView aufgerufen werden.
* Zeilen (`ExamElementRow`) sind **Controller + View** für jedes Kindobjekt in der Tabelle.
* Create/Edit/Delete Button → öffnen PopUp-Komponente, die das Model ändert.
