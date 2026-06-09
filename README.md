# Course Notes

This repository collects my course notes, seminar problem writeups, references,
and small reproducibility scripts.

## Courses

- `2025-fall-intro-integrable-systems/`  
  Lecture notes for Professor Liming Ling's course
  *Introduction to Integrable Systems* in Fall 2025--2026. The main file is
  `AG-sol-for-mKdv.tex`, based on lectures about algebro-geometric solutions of
  the focusing mKdV equation and related material from Ling--Sun (2025).

- `2026-spring-nonlinear-wave-theory/`  
  Seminar notes for *Nonlinear Wave Theory* in Spring 2025--2026. The main file
  is `nonlinear-wave-seminar.tex`, collecting suggested problems, computations,
  and numerical experiments.

## Build

Compile each main TeX file from its course directory. Use `pdflatex` with
SyncTeX enabled:

```powershell
latexmk -pdf -synctex=1 -interaction=nonstopmode -halt-on-error AG-sol-for-mKdv.tex
latexmk -pdf -synctex=1 -interaction=nonstopmode -halt-on-error nonlinear-wave-seminar.tex
```

Final PDFs are kept in the repository for convenient reading. LaTeX auxiliary
files and temporary render outputs should not be committed.

## Repository Layout

- `prompts/`: personal prompt templates used while preparing notes.
- `*/figs/`: figures used directly by a course note.
- `*/computations/`: MATLAB scripts, data, and generated figures used by a
  seminar writeup.
- `*/references/`: papers and arXiv source archives kept for study and
  reproducibility.
