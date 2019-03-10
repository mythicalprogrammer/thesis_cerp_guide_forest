## Generate GUIDE .dsc for each partition

generate_guide_description_file <-
  function(num_partition, num_of_folds, rand_seed) {
    j <- 1:num_of_folds
    i <- 1:num_partition
    iandj <- expand.grid(i = i, j = j)
    mclapply(1:nrow(iandj), function(iter) {
      i <- iandj[iter, ]$i
      j <- iandj[iter, ]$j
      ## Generate GUIDE .dsc
      kfoldj_parti_path <-
        str_c("kfold_partitions/rand_seed_",
              rand_seed,
              "_kfold_",
              j,
              "_part_",
              i,
              ".csv")
      kfold_j_part_i <- read_csv(kfoldj_parti_path)
      part_to_write <- kfold_j_part_i
      data_file_name <-
        str_c('"guide_data/rand_seed_',
              rand_seed,
              '_kfold_',
              j,
              '_part_',
              i,
              '.txt"')
      desc_file_name <-
        str_c("guide_data/rand_seed_",
              rand_seed,
              "_kfold_",
              j,
              "_part_",
              i,
              ".dsc")
      tmp <- c(data_file_name, "NA", 2)
      for (k in 1:length(names(part_to_write))) {
        preds_and_feature <- names(part_to_write)
        tmp2 <- str_c(k, " ", preds_and_feature[[k]], " ", "n")
        if (k == length(names(part_to_write))) {
          tmp2 <- str_c(k, " ", preds_and_feature[[k]], " ", "d")
        }
        tmp <- c(tmp, tmp2)
      }
      write.table(
        tmp,
        file = desc_file_name,
        row.names = FALSE,
        col.names = FALSE,
        quote = FALSE
      )

      ## Generate GUIDE .txt for each partition
      # create the path and write out to txt
      data_file_path <-
        str_c('guide_data/rand_seed_',
              rand_seed,
              '_kfold_',
              j,
              '_part_',
              i,
              '.txt')
      options(scipen = 100)
      write.table(
        part_to_write,
        file = data_file_path,
        sep = " ",
        row.names = FALSE,
        quote = FALSE
      )
      options(scipen = 0)
    }, mc.silent = TRUE)
  }
