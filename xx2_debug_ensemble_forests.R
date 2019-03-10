myeloma_data <- read.table("start_data/GDS531_after_anova.csv",
                           sep = ",",
                           header = TRUE)
rand_seeds <- c(1964, 1985, 1986, 1956, 1969, 2000, 2004,
                2009, 2019,
                1947, 1920,
                777, 13,
                1900, 1800,
                1,2,
                4,7,
                99,100)
num_partition <- 23
level_names <- c("W", "WO")

preds <- run_pipeline(num_partition = num_partition,
             nrow(myeloma_data),
             myeloma_data,
             myeloma_data$state,
             rand_seeds,
             level_names)

confusionMatrix(preds, myeloma_data$state)
