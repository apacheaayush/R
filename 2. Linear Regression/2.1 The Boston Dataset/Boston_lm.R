#-----------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------#
#                             "*THE BOSTON DATASET*"
#-----------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------#
#-----------------------------------------------------------------------------------#
# In this section I am going to use the inbuilt housing data of Boston for 
# learning regression analysis.
#-----------------------------------------------------------------------------------#
# 1. DATA ACQUISITION
#--------------------
  library("MASS")
  data(Boston)
  View(Boston)
  str(Boston)
  dim(Boston)
  ?Boston
  
  library("psych")
  describe(Boston)
#-----------------------------------------------------------------------------------#
# 2. DIVIDE DATASET
#------------------
  set.seed(1)
  library(caTools) # sample.split function is present in this package
  
  split_data <- sample.split(Boston$medv, SplitRatio = 0.7)
  # We divide the data in the ratio 0.7
  split_data
  
  training_data <- subset(Boston, split_data == "TRUE")
  test_data <- subset(Boston, split_data == "FALSE")
  # Here the dataset is divided into training:test as 7:3
#----------------------------------------------------------------------------------#
# 3. EXPLORATORY ANALYSIS
#------------------------
  library(lattice)
  jpeg('scatterplot1.jpg') # To save plot in a jpeg format
  splom(~Boston[c(1:6, 14)], groups = NULL, data = Boston, axis.line.tck = 0,
        axis.text.alpha = 0)
  dev.off() # It is required to turn off the graphics device
  jpeg('scatterplot2.jpg')
  splom(~Boston[c(7:14)], groups = NULL, data = Boston,axis.line.tck = 0,
        axis.text.alpha = 0)
  dev.off()
  # Checking for "CORRELATION" among data
  # Correlation is an important factor to check the dependencies among themselves
  # Correlation analysis gives us an insight for mutual relationship among variables
  cr <- cor(Boston)
  cr # This will give us the correlation coefficients
  # To visualise this corrplot library is required
  library("corrplot")
  jpeg('corrplot.jpg')
  corrplot(cr, type = "lower")
  dev.off()
  
  # Checking for "MULTICOLLINEARITY"
  # Multicollinearity exists when two or more predictors are highly correlated
  # among themselves
  library("car")
  model <- lm(medv~., data = training_data)
  vif(model) # vif = Variance Inflation Factor
  # vif measure the increase in the variance (the square of the estimate's standard
  # deviation) of an estimated regression coefficient due to multicollinearity.
  # A vif of 1 indicates that there is no correlation among variables.
  # A high vif indicates high multicollinearity.
  
  # The equation for the best fit line
  summary(model) # p-value for "indus" is the highest
  # This means that in presence of other predictors, "indus" is highly correlated.
  # P-value tests the NULL hypothesis that coefficient is equal to zero.
  # A high P-value denotes coefficient is really zero.
#-----------------------------------------------------------------------------------#
# 4. IMPLEMENT & OPTIMISE MODEL
#------------------------------
  # In the next model, we will remove the predictor "indus".
  model <- lm(medv ~ crim + zn  + chas + nox + rm + age + dis + rad + tax + ptratio
              + black + lstat, data = training_data)
  summary(model) # "age" has a very high P-value.
  
  model <- lm(medv ~ crim + zn + chas + nox + rm + dis + rad + tax + ptratio +
                black + lstat, data = training_data)
  summary(model) # Every predictor now in the model is signiicant.
  
  # NON LINEAR TERMS & INTERACTIONS
  # lstat & age
  interaction_model1 <- lm(medv ~ lstat*age, data = training_data)
  summary(interaction_model1)
  # Results indicate that effect of age alone is insignificant (p-value = 0.996)
  # whereas the interaction between "lstat" and "age" is significant (p-value =
  # 0.0579).
#-----------------------------------------------------------------------------------#
# 5. MODEL VALIDATION
#--------------------
  prediction <- predict(model, test_data)
  prediction
  
  # To compare the values - predicted and actual, we need to plot a graph.
  jpeg("PredictionPlot.jpg")
  plot(test_data$medv, type = "l", lty = 2.0, col = "green")
  lines(prediction, type = "l", lty = 3.0, col = "red")
  dev.off()
#-----------------------------------------------------------------------------------#
  