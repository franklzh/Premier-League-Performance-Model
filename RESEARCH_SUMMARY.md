# Premier League Season Points: Multi-Factor Regression Analysis

## Abstract

This project investigates the relationship between English Premier League (EPL) clubs' final season points and five candidate predictors: expected goals for (xG), expected goals against (xGA), passes per defensive action (PPDA), possession percentage, and estimated squad wage expenditure. The original study design covers team-season observations from 2017–18 through 2023–24 and compares nested ordinary least squares (OLS) models. The analysis pipeline has been refactored to load a source-verified CSV rather than rely on observations typed directly into an R script.

The original paper reported a strong in-sample relationship between season points and xG/xGA, and reported that adding PPDA improved its three-predictor model. Those numerical findings should be treated as **reported in the original manuscript, not independently reproduced here**: the source CSV files were not included with the supplied materials, and the original manually entered data could not be verified against the named providers. The reproducible pipeline in this repository is designed to recalculate the results after a verified merged dataset is supplied.

## Research question

How strongly are EPL season points associated with attacking chance quality, defensive chance prevention, pressing intensity, possession, and estimated wage expenditure?

## Data and variables

The original manuscript describes seven seasons (2017–18 to 2023–24), with up to 20 team-season rows per season. It names FBref as the primary source for performance measures, Understat as a cross-check for xG/xGA, Capology for estimated wage expenditure, and a Kaggle Premier League dataset as a standings/results reference. The intended observation is a club-season, keyed by club and season.

| Variable | Role | Interpretation |
|---|---|---|
| Season points | Outcome | Final league points accumulated by a club in a season |
| xG | Predictor | Expected goals generated |
| xGA | Predictor | Expected goals conceded |
| PPDA | Predictor | Passes allowed per defensive action; lower values are often associated with more intense pressing |
| Possession | Predictor | Average share of possession, in percent |
| Wage bill | Predictor | Estimated season wage expenditure, in millions of GBP |

Data definitions and provider methodologies can differ. A final publication should identify the exact files, retrieval dates, units, team-name harmonization, and missing-data decisions used to construct the merged dataset.

## Modeling plan

The R pipeline estimates four nested OLS specifications on a consistent complete-case sample:

1. **M1:** points as a function of xG.
2. **M2:** points as a function of xG and xGA.
3. **M3:** points as a function of xG, xGA, and PPDA.
4. **M4:** points as a function of xG, xGA, PPDA, possession, and wage bill.

Models are compared using R², adjusted R², and AIC. The workflow exports coefficient estimates and confidence intervals, residual-versus-fitted and Q–Q plots, an overall ANOVA table, descriptive statistics, and a Welch t-test comparing xG between groups defined by a median split of season points.

## Original manuscript's reported results (not independently verified)

The supplied manuscript reports that its 90-row random sample produced R² values of 0.8995, 0.9357, 0.9397, and 0.9398 for M1–M4, respectively. It reports an adjusted R² of 0.9376 for M3 and the equation:

`Points = 70.863 + 0.483(xG) − 0.504(xGA) − 1.254(PPDA)`

The paper also reports strong positive correlation between xG and points, strong negative correlation between xGA and points, and a negative PPDA coefficient. These are included here only to preserve the original study's stated findings; they should not be represented as newly reproduced results until the data provenance is resolved and the code is rerun. The source paper also contains inconsistent adjusted-R² claims in different sections, so this project avoids treating the paper's numbers as authoritative.

## Interpretation and limitations

The model is observational. Regression coefficients describe conditional associations and do not establish that changing a predictor would cause a change in points. xG, xGA, PPDA, possession, and wage expenditure may be correlated, making individual coefficients sensitive to model specification. Clubs recur across seasons, so the independence assumption may not hold; clustered standard errors or panel/multilevel models are potential improvements. A random in-sample fit is not a test of future-season forecasting accuracy. A stronger forecasting extension would use a chronological holdout season and compare predictions against a simple baseline.

Other limitations include estimated wage data, provider-specific definitions of performance metrics, a short seven-season window, and potential changes in league tactics over time. Residual plots are diagnostic aids, not proof that all OLS assumptions are satisfied.

## Next steps for a public release

1. Download the source data and confirm that redistribution or linking complies with each provider's terms.
2. Merge all variables using documented team-season keys and resolve naming differences explicitly.
3. Save the merged file in the schema specified in `data/README.md`.
4. Run `Rscript R/analysis.R data/epl_team_seasons.csv output`.
5. Inspect generated outputs and compare them against the original manuscript; update all numerical claims only from the reproduced results.
6. Add exact dataset citations and a data dictionary before publishing to GitHub.
