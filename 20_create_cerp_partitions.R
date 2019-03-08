# NOTE: mclapply will output something (ignore it).
# I don't need the results the result already written to csv files.

write_kfold_partition <-
  function(num_partition,
           i,
           kfold_i,
           partitions,
           response.state,
           rand_seed) {
    ignore <- mclapply(1:num_partition, function(k) {
      # grab the current partition to write
      part_to_write <- kfold_i[, partitions[[k]]]
      # add in the response
      part_to_write$state <- response.state
      # create the path and write out to csv
      file_path <-
        str_c("kfold_partitions/rand_seed_",
              rand_seed,
              "_kfold_",
              i,
              "_part_",
              k,
              ".csv")
      write.csv(part_to_write, file = file_path, row.names = FALSE)
    }, mc.silent = TRUE)
  }

aux_cerp_partition <- function(num_partition, num_r, ran_seed) {
  # go through each kfolds (all n of them) and create cerp partitions
  ignore <- mclapply(1:num_r, function(i) {
    kfold_path <- str_c("kfolds_data/kfold_", i, ".csv")
    kfold_i <- read_csv(kfold_path)
    response.state <- kfold_i$state #TODO: this is hardcoded
    kfold_i$state <- NULL


    # Shuffle the predictors before partition
    set.seed(ran_seed)
    shuffled_data <- kfold_i[, sample(ncol(kfold_i))]
    shuf_preds <- names(shuffled_data)
    num_pred <- ncol(kfold_i)
    pred_to_sample <- shuf_preds
    partitions <- list()
    num_pred_per_partition <- floor(num_pred / num_partition)
    remainders <- num_pred - num_pred_per_partition * num_partition
    # DONOT: parallize the for loop below it is an iterative process
    for (j in 1:num_partition) {
      if (remainders > 0) {
        part_size <- num_pred_per_partition + 1
        remainders <- remainders - 1
      } else {
        part_size <- num_pred_per_partition
      }
      partitions[[j]] <- pred_to_sample[1:part_size]
      pred_to_sample <-
        setdiff(pred_to_sample, pred_to_sample[1:part_size])
    }

    write_kfold_partition(num_partition,
                          i,
                          kfold_i,
                          partitions,
                          response.state,
                          ran_seed)

  }, mc.silent = TRUE)
}

create_CERP_partition <- function(num_partition, num_r, ran_seed) {
  aux_cerp_partition(num_partition, num_r, ran_seed)
}
