# Premier League Season Points: Multi-Factor Regression Analysis
# Reproducible analysis pipeline. Input data are loaded from CSV, not typed into R.

required_packages <- c("ggplot2", "dplyr", "readr", "tidyr", "broom", "scales")
missing_packages <- required_packages[!vapply(required_packages, requireNamespace, logical(1), quietly = TRUE)]
if (length(missing_packages)) {
  stop("Install required packages first: install.packages(c(",
       paste(sprintf('"%s"', missing_packages), collapse = ", "), ")).", call. = FALSE)
}

suppressPackageStartupMessages({
  library(ggplot2)
  library(dplyr)
  library(readr)
  library(tidyr)
  library(broom)
})

# Expected one-row-per-team-season CSV schema:
# team, season, points, xG, xGA, possession, PPDA, wage_bill
# wage_bill should be in millions of GBP; possession should be a percentage.
read_epl_data <- function(path) {
  if (!file.exists(path)) stop("Input CSV not found: ", path, call. = FALSE)
  dat <- readr::read_csv(path, show_col_types = FALSE, na = c("", "NA", "N/A", "-"))
  required <- c("team", "season", "points", "xG", "xGA", "possession", "PPDA", "wage_bill")
  missing_cols <- setdiff(required, names(dat))
  if (length(missing_cols)) {
    stop("Missing required column(s): ", paste(missing_cols, collapse = ", "),
         ". See data/README.md for the expected schema.", call. = FALSE)
  }
  dat <- dat %>% select(all_of(required)) %>%
    mutate(team = trimws(as.character(team)), season = trimws(as.character(season)))
  numeric_cols <- setdiff(required, c("team", "season"))
  non_numeric <- numeric_cols[!vapply(dat[numeric_cols], is.numeric, logical(1))]
  if (length(non_numeric)) stop("These columns must be numeric: ", paste(non_numeric, collapse = ", "), call. = FALSE)
  if (any(is.na(dat$team) | dat$team == "") || any(is.na(dat$season) | dat$season == "")) {
    stop("team and season cannot be blank or missing.", call. = FALSE)
  }
  if (anyDuplicated(dat[c("team", "season")])) {
    dupes <- dat %>% count(team, season) %>% filter(n > 1)
    stop("Duplicate team-season keys found. Resolve them before analysis. Examples: ",
         paste(paste(dupes$team, dupes$season, sep = " / ", collapse = "; ")), call. = FALSE)
  }
  if (any(dat$points < 0 | dat$points > 114, na.rm = TRUE)) warning("Some points values are outside the expected 0–114 range.")
  if (any(dat$possession < 0 | dat$possession > 100, na.rm = TRUE)) stop("possession must be between 0 and 100.", call. = FALSE)
  if (any(dat$xG < 0 | dat$xGA < 0 | dat$PPDA < 0 | dat$wage_bill < 0, na.rm = TRUE)) stop("xG, xGA, PPDA, and wage_bill must be non-negative.", call. = FALSE)
  if (nrow(dat) == 0) stop("The input CSV has no data rows.", call. = FALSE)
  dat
}

summarise_data <- function(dat) {
  vars <- c("points", "xG", "xGA", "PPDA", "possession", "wage_bill")
  summary <- lapply(vars, function(v) {
    x <- dat[[v]]
    tibble(variable = v, n = sum(!is.na(x)), mean = mean(x, na.rm = TRUE),
           sd = sd(x, na.rm = TRUE), median = median(x, na.rm = TRUE),
           min = min(x, na.rm = TRUE), max = max(x, na.rm = TRUE))
  })
  bind_rows(summary)
}

make_plots <- function(dat, output_dir) {
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  theme_set(theme_minimal(base_size = 12))
  p1 <- ggplot(dat, aes(points)) + geom_histogram(binwidth = 5, fill = "#315A7D", color = "white") +
    geom_vline(xintercept = mean(dat$points, na.rm = TRUE), linetype = "dashed", color = "#D1495B") +
    labs(title = "Distribution of Premier League season points", x = "Season points", y = "Team-seasons")
  ggsave(file.path(output_dir, "01_points_distribution.png"), p1, width = 8, height = 5, dpi = 300)

  plot_vars <- c("xG", "xGA", "PPDA", "possession", "wage_bill")
  plot_labels <- c(xG = "Expected goals (xG)", xGA = "Expected goals against (xGA)",
                   PPDA = "Passes per defensive action (PPDA)", possession = "Possession (%)",
                   wage_bill = "Wage bill (£m)")
  for (v in plot_vars) {
    p <- ggplot(dat, aes(x = .data[[v]], y = points)) +
      geom_point(alpha = .75, color = "#315A7D") +
      geom_smooth(method = "lm", se = TRUE, color = "#D1495B") +
      labs(title = paste("Season points vs.", plot_labels[[v]]), x = plot_labels[[v]], y = "Season points")
    ggsave(file.path(output_dir, paste0("02_points_vs_", v, ".png")), p, width = 8, height = 5, dpi = 300)
  }

  corr <- dat %>% select(points, all_of(plot_vars)) %>% cor(use = "pairwise.complete.obs") %>%
    as.data.frame() %>% tibble::rownames_to_column("variable_x") %>%
    pivot_longer(-variable_x, names_to = "variable_y", values_to = "correlation")
  p_corr <- ggplot(corr, aes(variable_x, variable_y, fill = correlation)) +
    geom_tile(color = "white") + geom_text(aes(label = sprintf("%.2f", correlation)), size = 3) +
    scale_fill_gradient2(low = "#B64B4B", mid = "white", high = "#2A7F62", limits = c(-1, 1)) +
    labs(title = "Correlation matrix", x = NULL, y = NULL, fill = "Pearson r") +
    theme(axis.text.x = element_text(angle = 35, hjust = 1))
  ggsave(file.path(output_dir, "03_correlation_matrix.png"), p_corr, width = 8, height = 6, dpi = 300)
}

run_analysis <- function(input_path = "data/epl_team_seasons.csv", output_dir = "output") {
  dat <- read_epl_data(input_path)
  dir.create(output_dir, recursive = TRUE, showWarnings = FALSE)
  readr::write_csv(summarise_data(dat), file.path(output_dir, "summary_statistics.csv"))

  # Complete-case rows are used consistently for comparable nested models.
  model_vars <- c("points", "xG", "xGA", "PPDA", "possession", "wage_bill")
  model_data <- dat %>% filter(if_all(all_of(model_vars), ~ !is.na(.x)))
  if (nrow(model_data) < 10) stop("Fewer than 10 complete observations remain; insufficient for this analysis.", call. = FALSE)
  if (nrow(model_data) <= 6) stop("Not enough complete observations for the specified regression models.", call. = FALSE)

  m1 <- lm(points ~ xG, data = model_data)
  m2 <- lm(points ~ xG + xGA, data = model_data)
  m3 <- lm(points ~ xG + xGA + PPDA, data = model_data)
  m4 <- lm(points ~ xG + xGA + PPDA + possession + wage_bill, data = model_data)
  models <- list(M1 = m1, M2 = m2, M3 = m3, M4 = m4)
  model_table <- bind_rows(lapply(names(models), function(nm) {
    m <- models[[nm]]
    tibble(model = nm, n = nobs(m), r_squared = summary(m)$r.squared,
           adjusted_r_squared = summary(m)$adj.r.squared, AIC = AIC(m))
  }))
  write_csv(model_table, file.path(output_dir, "model_comparison.csv"))
  write_csv(broom::tidy(m3, conf.int = TRUE), file.path(output_dir, "model_m3_coefficients.csv"))
  write_csv(broom::glance(m3), file.path(output_dir, "model_m3_fit.csv"))
  write_csv(broom::tidy(m4, conf.int = TRUE), file.path(output_dir, "model_m4_coefficients.csv"))

  # Save diagnostic figures for the pre-specified three-predictor model (M3).
  diag <- tibble(fitted = fitted(m3), residuals = residuals(m3))
  p_res <- ggplot(diag, aes(fitted, residuals)) + geom_hline(yintercept = 0, linetype = "dashed") +
    geom_point(alpha = .7, color = "#315A7D") + geom_smooth(method = "loess", se = FALSE, color = "#D1495B") +
    labs(title = "M3 residuals vs. fitted values", x = "Fitted points", y = "Residuals")
  ggsave(file.path(output_dir, "04_m3_residuals.png"), p_res, width = 8, height = 5, dpi = 300)
  p_qq <- ggplot(diag, aes(sample = residuals)) + stat_qq(color = "#315A7D") + stat_qq_line(color = "#D1495B") +
    labs(title = "M3 normal Q–Q plot", x = "Theoretical quantiles", y = "Residual quantiles")
  ggsave(file.path(output_dir, "05_m3_qq_plot.png"), p_qq, width = 8, height = 5, dpi = 300)

  # Top/bottom-half comparison uses the median split and Welch's t-test.
  med <- median(model_data$points)
  tiers <- model_data %>% mutate(tier = if_else(points >= med, "top", "bottom"))
  if (n_distinct(tiers$tier) == 2) {
    test <- t.test(xG ~ tier, data = tiers, var.equal = FALSE)
    capture.output(test, file = file.path(output_dir, "welch_t_test.txt"))
    p_tier <- ggplot(tiers, aes(tier, xG, fill = tier)) + geom_boxplot(alpha = .8) +
      scale_fill_manual(values = c(bottom = "#B07D52", top = "#2A7F62")) +
      labs(title = "Expected goals by season-points tier", x = "Points tier (median split)", y = "Season xG") +
      theme(legend.position = "none")
    ggsave(file.path(output_dir, "06_xg_by_points_tier.png"), p_tier, width = 7, height = 5, dpi = 300)
  }
  make_plots(dat, output_dir)
  capture.output(summary(m3), file = file.path(output_dir, "model_m3_summary.txt"))
  capture.output(anova(m3), file = file.path(output_dir, "model_m3_anova.txt"))
  message("Analysis complete. Outputs written to: ", normalizePath(output_dir, mustWork = FALSE))
  invisible(list(data = dat, model_data = model_data, models = models, model_table = model_table))
}

# Run from the project root:
# source("R/analysis.R")
# results <- run_analysis("data/epl_team_seasons.csv")
if (sys.nframe() == 0) {
  args <- commandArgs(trailingOnly = TRUE)
  input <- if (length(args) >= 1) args[[1]] else "data/epl_team_seasons.csv"
  output <- if (length(args) >= 2) args[[2]] else "output"
  run_analysis(input, output)
}
