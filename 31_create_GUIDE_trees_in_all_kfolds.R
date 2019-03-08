create_CERP_GUIDE_forest <-
  function(num_partition, num_of_folds, rand_seed) {
    #for (k in 1:num_of_folds) {
    #  for (j in 1:num_partition) {
    k <- 1:num_of_folds
    j <- 1:num_partition
    kandj <- expand.grid(k = k, j = j)
    nr <- nrow(kandj)
    result_dir <- str_c('guide_output/forests')
    if (!dir.exists(result_dir)) {
      dir.create(result_dir)
    }
    result_dir <- str_c('guide_output/out_files')
    if (!dir.exists(result_dir)) {
      dir.create(result_dir)
    }
    result_dir <-
      str_c('guide_output/forests/rand_seed_', rand_seed)
    if (!dir.exists(result_dir)) {
      dir.create(result_dir)
    }

    mclapply(1:nr, function(iter) {
      k <- kandj[iter, ]$k
      j <- kandj[iter, ]$j
      text <-
        readLines("guide_no_prune.input", encoding = "UTF-8")
      text[4]  <-
        str_c(
          '"guide_output/out_files/rand_seed_',
          rand_seed,
          '_kfold_',
          k,
          '_tree_',
          j,
          '.out"'
        )
      text[10] <-
        str_c('"guide_data/rand_seed_',
              rand_seed,
              '_kfold_',
              k,
              '_part_',
              j,
              '.dsc"')
      text[20] <-
        str_c('"guide_output/forests/rand_seed_',
              rand_seed,
              '/kfold_',
              k,
              '_tree_',
              j,
              '.R"')
      tmp_input_file <-
        str_c("tmp_input/guide.tmp_input_", k, '_tree_', j)
      write(text, file = tmp_input_file)
      sys_command <- str_c("./guide < ", tmp_input_file)
      system(sys_command)
    }, mc.silent = TRUE)
    delete_all_files_in_a_folder("./guide_output/out_files/")
  }
