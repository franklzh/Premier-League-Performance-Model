# What Drives Premier League Season Points?
### A reproducible team-season analysis of expected goals, pressing, possession, and wage expenditure

This project examines whether on-pitch performance indicators and estimated squad wage expenditure are associated with final English Premier League (EPL) season points. It compares nested ordinary least squares (OLS) models and produces descriptive plots, model summaries, confidence intervals, and regression diagnostics.

> **Reproducibility note:** The source files supplied for this publication contained an R script with manually embedded observations and a Word research paper, but did not include the underlying downloadable source CSV files. The analysis has therefore been refactored to import a documented CSV schema rather than silently treating hand-entered values as a verified dataset. Add the source-verified merged dataset described in [`data/README.md`](data/README.md) before running the analysis. Numerical results reported in the original paper are historical reported results and have not been independently reproduced by this refactored pipeline.

## Research question

To what extent are season points associated with expected goals for (xG), expected goals against (xGA), pressing intensity (PPDA), possession percentage, and estimated squad wage bill?

## Variables

- **Outcome:** final league points for each club-season.
- **Performance predictors:** xG, xGA, PPDA, and possession.
- **Financial predictor:** estimated wage bill in millions of pounds sterling.
- **Unit of analysis:** one team-season, covering 2017–18 through 2023–24 in the original research design.

Lower PPDA generally indicates more frequent defensive actions in the relevant zone, and is commonly interpreted as more intense pressing. Metric definitions may vary by provider, so source consistency matters.

## Analysis workflow

1. Import the merged team-season CSV and validate required columns and identifiers.
2. Produce summary statistics and exploratory plots.
3. Estimate four nested OLS models:
   - **M1:** points ~ xG
   - **M2:** points ~ xG + xGA
   - **M3:** points ~ xG + xGA + PPDA
   - **M4:** points ~ xG + xGA + PPDA + possession + wage bill
4. Compare R², adjusted R², and AIC.
5. Export coefficient estimates and confidence intervals for M3 and M4.
6. Inspect residuals and a normal Q–Q plot for M3.
7. Run a Welch two-sample t-test comparing xG between points tiers split at the sample median.

The regression results are associations, not causal effects. The project also does not claim genuine out-of-sample predictive performance: a train/test split or time-based validation should be added before describing the model as a validated forecasting system.

## Repository structure

```text
R/analysis.R       Import, validation, analysis, plotting, and output export
 data/README.md    Required input schema and data-provenance guidance
 output/           Generated artifacts (created when the script runs)
 README.md         Project overview and run instructions
 LICENSE           MIT license for this repository's original code
 .gitignore        Excludes local data and generated outputs by default
```

## Requirements

R 4.1+ is recommended. Required packages: `ggplot2`, `dplyr`, `readr`, `tidyr`, `broom`, and `scales`.

Install dependencies in R:

```r
install.packages(c("ggplot2", "dplyr", "readr", "tidyr", "broom", "scales"))
```

## Run the analysis

From the repository root, place the verified merged dataset at `data/epl_team_seasons.csv`, then run:

```r
source("R/analysis.R")
results <- run_analysis("data/epl_team_seasons.csv", output_dir = "output")
```

Or from a terminal with R installed:

```bash
Rscript R/analysis.R data/epl_team_seasons.csv output
```

The script exports CSV tables, text summaries, and high-resolution PNG plots to `output/`.

## Data sources and attribution

The original paper identifies the following sources for its intended merged dataset:

- [FBref](https://fbref.com/) — team performance statistics.
- [Understat](https://understat.com/) — expected-goals data used as a cross-check.
- [Capology](https://www.capology.com/) — estimated football wage and salary information.
- [Kaggle](https://www.kaggle.com/) — a cited Premier League data collection.

These references describe the original paper's stated sourcing, not confirmation that the original figures were downloaded directly or that each source's values are identical. Check source terms, cite the exact datasets used, and disclose any joins, transformations, or discrepancies. See [`data/README.md`](data/README.md).

## Important limitations

- Wage bills may be estimates rather than audited disclosures.
- xG, xGA, and PPDA definitions can differ by provider.
- Predictors are correlated, which can make individual coefficients unstable.
- Repeated clubs across seasons may violate independent-error assumptions; consider club-clustered standard errors or a multilevel/panel model.
- OLS diagnostics do not prove assumptions are satisfied; inspect plots and consider robust standard errors.
- In-sample fit is not evidence of future-season forecasting accuracy.
- Results may not generalize to other leagues or eras.

## Resume-ready project description

**Premier League Performance Analytics | R, Statistical Modeling**  
Built a reproducible R pipeline to study associations between EPL season points and expected goals, expected goals against, pressing intensity, possession, and estimated wage expenditure. Implemented CSV validation, exploratory visualization, nested OLS model comparison, confidence intervals, hypothesis testing, and regression diagnostics.

Only include numerical performance claims on a resume after rebuilding the source dataset and rerunning the pipeline to verify those results.
