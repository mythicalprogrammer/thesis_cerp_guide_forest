create_ensemble_of_GUIDE_forests <-
  function(num_partition, num_of_folds, rand_seeds,
           check_forest_exist) {
    #clear_forests()
    # TODO: parallelize this maybe because sub functions are already parallelize
    for (seed in rand_seeds) {
      if (check_forest_exist) {
        check <- check_if_forest_exist(seed, num_partition, num_of_folds)
      } else {
        check <- FALSE
      }
      if (check == FALSE) {
        create_CERP_partition(num_partition, num_of_folds, seed)
        generate_guide_description_file(num_partition, num_of_folds, seed)
        create_CERP_GUIDE_forest(num_partition, num_of_folds, seed)
      }
    }
    delete_generated_files()
  }
