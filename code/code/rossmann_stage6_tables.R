# ---------------------------------------------------------------------------
# FILE      rossmann_stage6_tables.R
# PURPOSE   Writes the Stage 6 result tables E1, E2, E6 and E7 to thesis_tables/
#           by reading them from the executed Stage 6 report,
#           rossmann_stage6.html. No model is fitted; it takes a few seconds.
# INPUTS    rossmann_stage6.html (rendered rossmann_stage6.Rmd)
# OUTPUTS   thesis_tables/stage6_e1.csv, stage6_e2.csv, stage6_e6.csv, stage6_e7.csv
# THESIS    Sections 4.3.3 and 4.3.7. The .Rnw sources this file when the CSVs
#           are missing, so knitting the thesis is enough.
#
# The report prints its tables as paged tables, stored in the HTML as JSON in
# document order: 1 main holdout RMSE, 2 E1, 3 E2, 4 E3, 5 E5, 6 E6, 7 E7.
# Each table is checked by its first column before it is written, so a report
# with a different layout stops with an error instead of writing wrong numbers.
# ---------------------------------------------------------------------------

local({
  html <- paste(readLines("rossmann_stage6.html", warn = FALSE, encoding = "UTF-8"), collapse = "\n")
  m <- gregexpr('(?s)<script data-pagedtable-source type="application/json">(.*?)</script>', html, perl = TRUE)
  raw <- regmatches(html, m)[[1]]
  raw <- sub('(?s)^<script[^>]*>', "", sub("</script>$", "", raw, perl = TRUE), perl = TRUE)
  tabs <- lapply(raw, function(j) {
    d <- jsonlite::fromJSON(j)$data
    d[] <- lapply(d, function(x) { x[x == "NA"] <- NA; x })
    d
  })
  if (length(tabs) != 7) stop("rossmann_stage6.html: expected 7 paged tables, found ", length(tabs))
  num <- function(x) as.numeric(x)
  chk <- function(ok, what) if (!ok) stop("rossmann_stage6.html: unexpected layout of ", what)

  e1 <- tabs[[2]]; chk(identical(e1[[1]], c("LightGBM", "XGBoost")), "E1")
  e2 <- tabs[[3]]; chk(all(grepl(" vs ", e2[[1]])), "E2")
  e6 <- tabs[[6]]; chk(ncol(e6) == 6 && num(e6[[1]][1]) == 50, "E6")
  e7 <- tabs[[7]]; chk(all(grepl("LightGBM", e7[[1]])), "E7")

  dir.create("thesis_tables", showWarnings = FALSE)
  out <- list(
    stage6_e1.csv = data.frame(Model = e1[[1]], `Stage1 fixed-origin` = num(e1[[2]]),
                               `Stage3b recursive` = num(e1[[3]]), check.names = FALSE),
    stage6_e2.csv = data.frame(Comparison = e2[[1]], DM = num(e2[[2]]), p = num(e2[[3]])),
    stage6_e6.csv = data.frame(N = num(e6[[1]]), gain_xgb_mean = num(e6[[2]]), gain_xgb_se = num(e6[[3]]),
                               gain_lgbm_mean = num(e6[[4]]), gain_lgbm_se = num(e6[[5]]), reps = num(e6[[6]])),
    stage6_e7.csv = data.frame(Model = e7[[1]], RMSE = num(e7[[2]]), Stores = num(e7[[3]])))
  for (f in names(out)) write.csv(out[[f]], file.path("thesis_tables", f), row.names = FALSE)
})
