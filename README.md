# When Do Tree-Based Methods Win?
### How Dataset Characteristics Shape Ensemble Forecasting Performance

MSc Econometrics thesis · Vrije Universiteit Amsterdam  
**Kayra Işık** · supervisor prof. dr. Michael Massmann · co-reader dr. Yicong Lin

📄 **[Read the thesis (PDF)](Kayra_Isik_thesis.pdf)**

---

## About

Boosted trees won the M5 forecasting competition. This thesis asks *why*, and
whether that result carries over to other retail data. Using daily sales of
**1115 Rossmann stores (2013–2015)**, it compares XGBoost and LightGBM with
simple baselines (store mean, store × day-of-week mean) and statistical models
(Auto-ARIMA, ETS, Theta, ARIMAX), and changes the number of stores, the
training history, the store mix and the information the models see.

## Main findings

- **Information matters more than the algorithm.** With only their own sales
  history, XGBoost and LightGBM are about 12% *worse* than a day-of-week
  baseline. With calendar, store and promotion features they are about 39%
  better, and with recent sales close to 50% better.
- **More stores do not help**, and more than one year of history adds little.
- **Given the same covariates, ARIMAX closes most of the gap** to the trees:
  it nearly ties LightGBM at one forecast origin and loses at the other.
- **At least 82%** of the daily deviation from a store's normal level is
  predictable with the available information.

## What is where

| | |
|---|---|
| [`Kayra_Isik_thesis.pdf`](Kayra_Isik_thesis.pdf) | The thesis |
| [`code/`](code) | The analysis scripts, one per part of the thesis |
| [`results/`](results) | Every result table used in the thesis, as CSV |
| [`thesis/`](thesis) | LaTeX/knitr source of the thesis (`.Rnw`, bibliography, logo) |

## Scripts and the results they produce

| Script (`code/`) | What it does | Results (`results/`) |
|---|---|---|
| `rossmann_eda.Rmd` | Data description and exploratory figures | `descriptive_stats`, `store_types` |
| `rossmann_simulation.Rmd` | Simulation of the bias–variance sequence | (figures inside the thesis) |
| `rossmann_stage1_models.Rmd` | Stage 1: eleven models on the main holdout | `stage1_pooled_models` |
| `rossmann_bagging_only.Rmd` | Bagging and random forest settings | `bagging_rf_configs` |
| `rossmann_old_m_to_modern_ml_experiment.Rmd` | Auto-ARIMA, ETS and Theta | `statistical_benchmarks` |
| `rossmann_decomposition.Rmd` | Store level, predictable part and residual | `decomposition`, `decomposition_store1` |
| `rossmann_stages2_4.Rmd` | Stages 2–4: training window, store type, lags, rolling windows | `stage2_window`, `stage2_storetype`, `stage3_lags`, `stage4_rolling` |
| `rossmann_stage2_nstores_20draws.Rmd` | Stage 2: number of stores, 20 random draws per size | `stage2_nstores`, `stage2_nstores_draws` |
| `rossmann_stage2_nstores_tests.R` | Paired tests of the number-of-stores effect | `stage2_nstores_tests` |
| `rossmann_window6_diagnostic.Rmd` | Why XGBoost fails with six months of training data | `stage2_window_diag` |
| `rossmann_rolling_december.Rmd` | December test window | `rolling_december` |
| `rossmann_stage5.Rmd` | Stage 5: nested information sets | `stage5_information_sets` |
| `rossmann_stage6.Rmd` + `rossmann_stage6_tables.R` | Stage 6: recursive lags, Diebold–Mariano tests, hyperparameter grid, scale, global vs local | `hyperparameter_grid`, `stage6_e1`, `stage6_e2`, `stage6_e6`, `stage6_e7` |
| `rossmann_stage7_tree_vs_statistical.Rmd` | Trees vs Auto-ARIMA significance tests | `stage7_dm_tests` |
| `rossmann_arimax.Rmd` | Covariate-matched ARIMAX comparison | `arimax_comparison`, `arimax_uncertainty` |
| `rossmann_arimax_history.Rmd` | ARIMAX with 3, 6 and 12 months of history | `arimax_history`, `arimax_history_ci` |
| `rossmann_data_properties.Rmd` | Per-store gain vs data properties | `gain_vs_properties` |
| `rossmann_thesis_extensions.Rmd` | Store-level framework test | `tab_e4_store_level_framework`, `tab_e8_store_types` |
| `rossmann_pred23_verify.Rmd`, `rossmann_statistical_closeddays.Rmd` | Robustness checks | — |

## How to reproduce

1. Download `train.csv` and `store.csv` from
   [Kaggle](https://www.kaggle.com/c/rossmann-store-sales/data) and put them
   in `code/`. The data is not included here (Kaggle competition rules).
2. **Rerun an analysis:** knit the script in RStudio, or run
   `rmarkdown::render("rossmann_stages2_4.Rmd")` inside `code/`. Each script
   is self-contained and writes its result CSVs.
3. **Rebuild the thesis:** knit `thesis/Kayra_Isik_thesis_final_v3.Rnw`
   (pdfLaTeX with BibTeX). It reads the tables in `results/` and does not refit
   the models.

**Software:** R 4.5.3 · xgboost 3.2.1.1 · LightGBM 4.6–4.7 · tidyverse · forecast · ranger · rpart

## License

MIT, see [`LICENSE`](LICENSE). The Rossmann data belongs to Kaggle and Rossmann
and is not covered by this license.
