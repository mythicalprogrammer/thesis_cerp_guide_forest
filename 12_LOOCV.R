myeloma_data <- read.table("start_data/GDS531_after_anova.csv",
                            sep=",", header=TRUE)


# create leave one out data set (20 rows so there should be 20 data set for CV)
n <- nrow(myeloma_data)
kfolds_data <- list()
for (i in  1:n) {
  ith_kfold_data <- myeloma_data[-c(i), ]
  kfolds_data[[i]] <- ith_kfold_data
  #debug purposes
  #print(str_c(i,': ', ith_kfold_data[,1],' ' ,nrow(ith_kfold_data) ))#should be 86
}

# test for the fact that 1st k_fold loocv have only the first row gone
k_fold_1 <- kfolds_data[[1]] # first row should be gone
k_fold_1[1,1] == myeloma_data[1,1] # should be FALSE
k_fold_1[1,1] == myeloma_data[2,1] # should be TRUE

# test for the fact that 2nd k_fold loocv have only the second row gone
k_fold_2 <- kfolds_data[[2]]
k_fold_2[1,1] == myeloma_data[1,1] # should be TRUE
k_fold_2[1,1] == k_fold_1[1,1] # should be FALSE

dim(k_fold_1) #19 x 1933
dim(k_fold_2) # 19 x 1933

# write the generated kfold data to csv
# TODO: rewrite this to lapply and then to multicore apply
for (i in  1:n) {
  file_path <- str_c("kfolds_data/kfold_",i,".csv")
  write.csv(kfolds_data[[i]], file = file_path, row.names = FALSE)
}


