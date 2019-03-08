cross_validate_CERP_GUIDE_ensemble_forests <- function(num_partition,
                                                       num_of_folds,
                                                       prostate_data,
                                                       rand_seeds){
  # TODO Not sure if I can parallelize when the subroutine is
  # already parallelize
  # Possible Solution:
  # one giant function with 3 nested for loops
  # use grid to make it into one mclapply
  # Only do this after everything is done.
  # DO NOT prematurely optimize
  for (seed in rand_seeds) {
    cross_validate_CERP_GUIDE(num_partition,
                              num_of_folds,
                              prostate_data,
                              seed)
  }
}
