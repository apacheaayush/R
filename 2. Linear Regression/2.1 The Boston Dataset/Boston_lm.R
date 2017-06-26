#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
#                                                    "*THE BOSTON DATASET*"
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
# In this section I am going to use the inbuilt housing data of Boston to learn regression analysis. 
# Problem statement: To predict medv (median value of owner-occupied homes) against given predictors in the dataset
#---------------------------------------------------------------------------------------------------------------------------------------#
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
#---------------------------------------------------------------------------------------------------------------------------------------#
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
#---------------------------------------------------------------------------------------------------------------------------------------#
# 3. EXPLORATORY ANALYSIS
#------------------------
  library(ggplot2)
  library(GGally)
  plot1 <- ggpairs(Boston)
  plot1
  ggsave(filename = "Scatter Plot Matrix.png", plot1)
  
  # Checking for "CORRELATION" among data
  # Correlation is an important factor to check the dependencies among themselves
  # Correlation analysis gives us an insight for mutual relationship among variables
  cr <- cor(Boston)
  cr # This will give us the correlation coefficients
  # To visualise this corrplot library is required
  library("corrplot")
  png('corrplot.jpg')
  corrplot(cr, type = "lower")
  dev.off()
  
  # Checking for "MULTICOLLINEARITY"
  # Multicollinearity exists when two or more predictors are highly correlated among themselves.
  library("car")
  model <- lm(medv~., data = training_data)
  vif(model) # vif = Variance Inflation Factor
  # "vif" measures the increase in the variance (the square of the estimate's standard # deviation) of an estimated regression 
  # coefficient due to multicollinearity.
  # A vif of 1 indicates that there is no correlation among variables.
  # A high vif indicates high multicollinearity.
  
  # The equation for the best fit line
  summary(model) # p-value for "indus" is the highest
  # This means that in presence of other predictors, "indus" is highly correlated.
  # P-value tests the NULL hypothesis that coefficient is equal to zero.
  # A high P-value denotes coefficient is really zero.
#---------------------------------------------------------------------------------------------------------------------------------------#
# 4. IMPLEMENT & OPTIMISE MODEL
#------------------------------
  # In the next model, we will remove the predictor "indus".
  model <- lm(medv ~. - indus, data = training_data)
  summary(model) # "age" has a very high P-value.
  model <- lm(medv ~. - age, data = training_data)
  summary(model) # Every predictor now in the model is significant.
#---------------------------------------------------------------------------------------------------------------------------------------#
# 5. MODEL VALIDATION
#--------------------
  prediction <- predict(model, test_data)
  prediction
  
  # To compare the values - predicted and actual, we need to plot a graph.
  jpeg("PredictionPlot.jpg")
  plot(test_data$medv, type = "l", lty = 2.0, col = "green")
  lines(prediction, type = "l", lty = 3.0, col = "red")
  dev.off()
#---------------------------------------------------------------------------------------------------------------------------------------#
  
