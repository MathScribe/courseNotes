# Course Notes

This repository collects course notes, seminar writeups, reference papers,
figures, and small reproducibility scripts for courses on integrable systems
and nonlinear waves.

## Main Notes

- [AG-sol-for-mKdv.tex](2025-fall-intro-integrable-systems/AG-sol-for-mKdv.tex)  
  Main notes for Professor Liming Ling's course
  *Introduction to Integrable Systems* in Fall 2025--2026. The notes focus on
  algebro-geometric solutions of the focusing mKdV equation and related
  Riemann-surface calculations. A compiled PDF is also kept at
  [AG-sol-for-mKdv.pdf](2025-fall-intro-integrable-systems/AG-sol-for-mKdv.pdf).

- [nonlinear-wave-seminar.tex](2026-spring-nonlinear-wave-theory/nonlinear-wave-seminar.tex)  
  Seminar notes for *Nonlinear Wave Theory* in Spring 2026. The file
  collects selected computations, homework writeups, numerical reproductions,
  and notes on the Grinevich--Santini finite-gap description of rogue-wave
  recurrence. A compiled PDF is also kept at
  [nonlinear-wave-seminar.pdf](2026-spring-nonlinear-wave-theory/nonlinear-wave-seminar.pdf).

## Repository Structure

```text
courseNotes/
|-- README.md
|-- prompts/
|   `-- personal prompt templates used while preparing notes
|-- 2025-fall-intro-integrable-systems/
|   |-- AG-sol-for-mKdv.tex
|   |-- AG-sol-for-mKdv.pdf
|   |-- clean.bat
|   |-- figs/
|   |-- references/
|   |   `-- arxiv-2510.12073v1/
|   `-- references.bib
`-- 2026-spring-nonlinear-wave-theory/
    |-- nonlinear-wave-seminar.tex
    |-- nonlinear-wave-seminar.pdf
    |-- clean.bat
    |-- computations/
    |   `-- one-mode-recurrence/
    `-- references/
        `-- papers/
```

The `figs/` directories contain figures used directly in the notes. The
`computations/` directory contains MATLAB scripts and generated figures used for
seminar reproduction experiments. The `references/` directories keep papers,
arXiv source archives, and supporting bibliography files for study and
reproducibility.

## Reference Papers

- Liming Ling and Xuan Sun, *Focusing mKdV equation: Two-phase solutions and
  their stability analysis* (2025).  
  External: [arXiv:2510.12073](https://arxiv.org/abs/2510.12073).  
  Local source archive:
  [arxiv-2510.12073v1](2025-fall-intro-integrable-systems/references/arxiv-2510.12073v1/).

- P. G. Grinevich and P. M. Santini, *The finite gap method and the analytic
  description of the exact rogue wave recurrence in the periodic NLS Cauchy
  problem. 1*, Nonlinearity 31 (2018), 5258--5308.  
  External: [arXiv:1707.05659](https://arxiv.org/abs/1707.05659).

- P. G. Grinevich and P. M. Santini, *The finite-gap method and the periodic
  NLS Cauchy problem of anomalous waves for a finite number of unstable modes*,
  Russian Mathematical Surveys 74 (2019), 211--263.  
  External: [arXiv:1810.09247](https://arxiv.org/abs/1810.09247).

- Yaroslav V. Kartashov and Vladimir V. Konotop, *Solitons in Bose-Einstein
  Condensates with Helicoidal Spin-Orbit Coupling*, Physical Review Letters 118
  (2017), 190401.  
  External: [DOI:10.1103/PhysRevLett.118.190401](https://doi.org/10.1103/PhysRevLett.118.190401),
  [arXiv:1709.07017](https://arxiv.org/abs/1709.07017).

## Build

Compile each main TeX file from its own course directory. Use `pdflatex` with
SyncTeX enabled:

```powershell
cd 2025-fall-intro-integrable-systems
latexmk -pdf -pdflatex="pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error %O %S" AG-sol-for-mKdv.tex

cd ../2026-spring-nonlinear-wave-theory
latexmk -pdf -pdflatex="pdflatex -synctex=1 -interaction=nonstopmode -halt-on-error %O %S" nonlinear-wave-seminar.tex
```

Each course directory also contains a local `clean.bat` for removing LaTeX
auxiliary files generated beside that directory's TeX source.

Final PDFs are kept in the repository for convenient reading. LaTeX auxiliary
files and temporary render outputs should not be committed.
