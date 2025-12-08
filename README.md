# Dokumentation

Dies ist meine Dokumentation von der DHBW-Stuttgart. Meine Fachrichtung ist Informatik. Für manche Fächer, wie Lineare Algebra, gibt es noch eine zusammenfassung in Vorbereitung auf die Klausur.

## Latex

All meine Dokumente sind in Latex formuliert. Das Formatting ist noch Standard, wird in Zukunft evt. noch geändert.

### preamble

Damit ich in jedem .tex file die gleichen imports für z.B. Mathe Formeln und Symbole, hat jedes Semester ein preamble.tex, welches von jedem lec_XX.tex referenziert wird.

### Ordnerstruktur DHBW

```
├── .vscode
├── /current
├── /helper
│   ├── /inkscape
│   │   └── template.svg
│   └── /scripts
├── /sem1
│   ├── preamble.tex
│   ├── /module_01
│   │   ├── /doc
│   │   ├── /fig
│   │   │   ├── figure_name.svg
│   │   │   ├── figure_name.pdf
│   │   │   ├── figure_name.tex
│   │   ├── info.yaml
│   │   ├── lec_01.tex
│   │   ├── lec_02.tex
│   │   ├── ...
│   ├── /module_02
│   ├── ...
└── /sem2
```

## Zusätze in Modulen

In Manchen Fächern/ Modulen gibt es noch zusätzliche Dateien, welche in der Ordnerstruktur des einzelnen Moduls sind.

### Ordner /scheme

Für Scheme Programme in der Sprache Racket im Standard R5RS.

### Ordner /c

Für Programme in der Sprache C.

Dies sind nur ein Paar Übungen, da der Großteil der Aufgaben in einem Anderen Repo sind.

### Ordner /python

Für Programme in der Sprache python. Diese sind für schnelle teilweise Mathematische Rechnungen.

### Ordner /jupiter

Für Jupyter Notebooks im Modul Scientific Programming Lab, welche python als Grundlage benutzen

### Ordner /pap

Für Dateien im .pap format um Ablaufplane zu kreieren und zu speichern.

## License

This repo ist licensed under the GNU GPLv3 - see the [LICENSE](https://github.com/MortizK/JExam/blob/main/LICENSE) file for details