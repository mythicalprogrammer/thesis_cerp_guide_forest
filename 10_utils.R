sinkall <- function() {
  i <- sink.number()
  if (i > 0) {
    for (i in 1:i) {
      sink()
    }
  }
}

delete_all_files_in_a_folder <- function(dir_path) {
  kfold_partitions_dir_files <-
    list.files(path = dir_path, full.names = TRUE)
  file.remove(kfold_partitions_dir_files)
}

delete_generated_files <- function() {
  delete_all_files_in_a_folder("./kfold_partitions")
  delete_all_files_in_a_folder("./guide_data")
  delete_all_files_in_a_folder("./tmp_input")
}

# TODO: parallize this
clear_forests <- function() {
  dir_path <- "./guide_output/forests"
  forest_dirs <- list.files(path = dir_path, full.names = TRUE)
  for (dir in forest_dirs) {
    delete_all_files_in_a_folder(dir)
    unlink(dir, recursive = TRUE)
  }
}

check_if_forest_exist <- function(rand_seed, num_part, num_kfold) {
  result_dir <-
    str_c('guide_output/forests/rand_seed_', rand_seed)
  exist <- dir.exists(result_dir)
  num_files <- length(list.files(result_dir))
  file_equal <- num_files == (num_part * num_kfold)
  return(exist && file_equal)
}
