# Input data

The original R script embedded a manually typed dataset. That dataset has intentionally **not** been copied into this repository as if it were a source download. The paper describes multiple public sources, but the raw source CSV files were not included among the files provided for this packaging pass. Add a verified, merged CSV named `epl_team_seasons.csv` here (or pass another path to `run_analysis()`).

## Required CSV schema

One row per club-season, with these exact column names:

| Column | Meaning | Units / notes |
|---|---|---|
| `team` | Club name | Consistent spelling across sources |
| `season` | Season label | For example, `2017-18` |
| `points` | Final league points | Points awarded in the final table |
| `xG` | Expected goals for | Season total |
| `xGA` | Expected goals against | Season total |
| `possession` | Average possession | Percentage from 0 to 100 |
| `PPDA` | Passes per defensive action | Use one consistent provider/definition |
| `wage_bill` | Estimated squad wage bill | Millions of GBP (£m) per season |

The importer validates the schema, numeric fields, missing identifiers, duplicate team-season keys, and basic ranges. Missing numeric values are permitted at import but excluded from regression rows using complete-case analysis. The summary table and descriptive plots use all available values for each variable.

## Source and provenance notes

The accompanying original paper names FBref, Understat, Capology, and a Kaggle Premier League dataset as sources. It does not provide enough machine-readable provenance in the supplied materials to reconstruct the exact merged table safely. Download the source files directly, record the retrieval date and source URLs in your own data notes, document any team-name harmonization, and retain the provider's attribution/licensing terms. Do not present estimated wage figures as official club disclosures.
