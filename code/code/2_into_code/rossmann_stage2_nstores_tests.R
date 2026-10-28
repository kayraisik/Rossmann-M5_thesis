# ---------------------------------------------------------------------------
# FILE      rossmann_stage2_nstores_tests.R
# PURPOSE   Tests of Prediction 1 (the gain increases with the number of
#           stores) on the 20 draws of rossmann_stage2_nstores_20draws.Rmd.
#           Within a draw the store samples are nested (the 50 stores are part
#           of the 200, which are part of the 500), because each draw uses the
#           same seed for every size. The tests therefore pair by draw:
#             - slope of the gain on log(N) with draw fixed effects;
#             - paired t-test of 500 against 50 stores within each draw.
#           Runs in a second; no model is fitted.
# INPUTS    stage2_nstores_draws.csv
# OUTPUTS   stage2_nstores_tests.csv
# ---------------------------------------------------------------------------

d <- read.csv("stage2_nstores_draws.csv")
d <- d[d$N < max(d$N), ]                      # sampled sizes 50, 200, 500

one_test <- function(model, col) {
  fit <- lm(as.formula(paste(col, "~ log(N) + factor(draw)")), data = d)
  b <- coef(summary(fit))["log(N)", ]
  w <- merge(d[d$N == 500, c("draw", col)], d[d$N == 50, c("draw", col)], by = "draw")
  pt_ <- t.test(w[[2]], w[[3]], paired = TRUE)
  data.frame(Model = model,
             slope_per_log_N = b[["Estimate"]], slope_se = b[["Std. Error"]],
             slope_t = b[["t value"]],
             p_two_sided = 2 * pt(-abs(b[["t value"]]), df = fit$df.residual),
             p_one_sided_increase = pt(b[["t value"]], df = fit$df.residual, lower.tail = FALSE),
             diff_500_minus_50 = unname(pt_$estimate), paired_t = unname(pt_$statistic),
             paired_p = pt_$p.value, draws = nrow(w))
}
tests <- rbind(one_test("XGBoost", "XGB_delta"), one_test("LightGBM", "LGBM_delta"))
tests[] <- lapply(tests, function(x) if (is.numeric(x)) signif(x, 4) else x)
print(tests)
write.csv(tests, "stage2_nstores_tests.csv", row.names = FALSE)
