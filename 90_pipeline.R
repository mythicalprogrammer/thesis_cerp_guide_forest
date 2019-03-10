run_pipeline <- function(num_partition,
                         num_kfold,
                         data,
                         response,
                         rand_seeds,
                         level_names,
                         check_forest_exist = TRUE) {
  create_ensemble_of_GUIDE_forests(num_partition,
                                   num_kfold,
                                   rand_seeds,
                                   check_forest_exist)
  cross_validate_CERP_GUIDE_ensemble_forests(num_partition,
                                             num_kfold,
                                             data,
                                             rand_seeds)
}
