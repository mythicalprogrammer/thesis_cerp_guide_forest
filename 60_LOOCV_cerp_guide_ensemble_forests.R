cross_validate_CERP_GUIDE_ensemble_forests <-
  function(num_partition,
           num_of_folds,
           prostate_data,
           rand_seeds) {
    # TODO Not sure if I can parallelize when the subroutine is
    # already parallelize
    # Possible Solution:
    # one giant function with 3 nested for loops
    # use grid to make it into one mclapply
    # Only do this after everything is done.
    # DO NOT prematurely optimize
    for (seed in rand_seeds) {
      check <- check_if_already_crossvalidated(seed, num_partition)
      if (check == FALSE) {
        cross_validate_CERP_GUIDE(num_partition,
                                  num_of_folds,
                                  prostate_data,
                                  seed)
      }
    }

    forest_preds <- c()
    i <- 1
    for (seed in rand_seeds) {
      forest_preds[[i]] <- cv_ensemble_forests(seed, num_partition)
      i <- i + 1
    }
    ensemble_forests_preds <- rbind.data.frame(forest_preds)

    file_path  <-
      str_c(
        'results/rand_seed_',
        paste(rand_seeds, collapse = "_"),
        '_LOOCV_CERP_GUIDE_ensemble_results_num_part_',
        num_partition,
        '.csv'
      )
    write.csv(ensemble_forests_preds,
              file = file_path,
              row.names = FALSE)
    majority_vote_ensemble_forests(ensemble_forests_preds)
  }

majority_vote_ensemble_forests <- function(forests_preds_df) {
  ensemble_forests_predictions <- c()
  for (i in 1:nrow(forests_preds_df)) {
    forests_votes <- table(unlist(forests_preds_df[i,]))
    ensemble_forests_predictions[[i]] <- names(which.max(forests_votes))
  }
  return(as.factor(ensemble_forests_predictions))
}

cv_ensemble_forests <- function(seed, part_num) {
  dir_str <- str_c(
    "results/rand_seed_",
    seed,
    "_LOOCV_CERP_GUIDE_results_num_part_",
    part_num,
    ".csv"
  )
  forest_pred <- t(read_csv(dir_str, col_names = FALSE))
  forest_pred <- data.frame(forest_pred)
  forest_pred[, 1] <- NULL
  names(forest_pred) <- str_c("seed_", seed, "_part_", part_num)
  return(forest_pred)
}

check_if_already_crossvalidated <- function(seed_num, part_num) {
  file_name <-
    str_c(
      "results/rand_seed_",
      seed_num,
      "_LOOCV_CERP_GUIDE_results_num_part_",
      part_num,
      ".csv"
    )

  return(file.exists(file_name))
}
