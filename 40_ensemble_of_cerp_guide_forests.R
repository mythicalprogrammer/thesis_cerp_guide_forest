create_ensemble_of_GUIDE_forests <- function(num_partition, num_of_folds, rand_seeds) {
  #clear_forests()
  # TODO: parallelize this
  for (seed in rand_seeds) {
    delete_generated_files()
    create_CERP_partition(num_partition, num_of_folds, seed)
    generate_guide_description_file(num_partition, num_of_folds, seed)
    create_CERP_GUIDE_forest(num_partition, num_of_folds, seed)
  }
}
