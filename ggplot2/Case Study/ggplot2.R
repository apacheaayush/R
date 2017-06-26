#---------------------------------------------------------------
#-------------------------------------------------------------------
#------------------------------------------------------------------
#                   "*ggplot2*"
#---------------------------------------------------------------
#--------------------------------------------------------------
#--------------------------------------------------------------
# This is case study to practise the commands of ggplot2.
#--------------------------------------------------------------
# LOADING THE LIBRARY AND A DATASET - diamonds.
#---------------------------------------------
library("ggplot2")
data("diamonds")
View(diamonds)
help(diamonds)
# -------------------------------------------------------
# SCATTER PLOT
#-------------
# Plotting "price" vs "carat".
ggplot(diamonds, aes(x = carat, y = price)) + geom_point()

# Coloring the data points with factor variable "clarity".
ggplot(diamonds, aes(x = carat, y = price, color=clarity)) + geom_point()

# Coloring the data points with factor variable "color" improving the resolution.
ggplot(diamonds, aes(x = carat, y = price, color=color, resolution(1200))) + geom_point()

# Coloring the data points with factor variable "color" and resizing the data points with another factor variable "cut".
ggplot(diamonds, aes(x = carat, y = price, color=color, resolution(1200), size = cut)) + geom_point()

# Coloring the data points with factor variable "color" and reshaping the data points with another factor variable "cut".
ggplot(diamonds, aes(x = carat, y = price, color=color, resolution(1200), shape = cut)) + geom_point()

# Fitting a smooth curve to the plot. (se = FALSE is used to remove the confidence interval shading).
ggplot(diamonds, aes(x = carat, y = price)) + geom_point() + geom_smooth()
ggplot(diamonds, aes(x = carat, y = price)) + geom_point() + geom_smooth(se = FALSE)
# Fitting a stright line to the plot.
ggplot(diamonds, aes(x = carat, y = price)) + geom_smooth(se = FALSE, method = "lm")

# Adding a title to the plot.
ggplot(diamonds, aes(x = carat, y = price)) + geom_point() + ggtitle("My plot")

# Restricting the value of a variable in a specific range.
ggplot(diamonds, aes(x = carat, y = price)) + geom_point() + xlim(0,2)

# To remove the data points and get the best fit line only
ggplot(diamonds, aes(x = carat, y = price)) + geom_smooth(method = "lm")
#-----------------------------------------------------
# HISTOGRAMS
#-----------
# Used for 1 dimensional data
ggplot(diamonds, aes(x = price)) + geom_histogram()

# Changing the bin width
ggplot(diamonds, aes(x = price)) + geom_histogram(binwidth = 2000) # wider
ggplot(diamonds, aes(x = price)) + geom_histogram(binwidth = 200) # narrow

# Facetting
ggplot(diamonds, aes(x = price)) + geom_histogram() + facet_wrap(~ clarity)
ggplot(diamonds, aes(x = price)) + geom_histogram(col = "blue") + facet_wrap(~ color)
# All plots have different frequencies(count). To change the y axis accordingly
ggplot(diamonds, aes(x = price)) + geom_histogram(col = "red") + facet_wrap(~ color, scales = "free_y")

# Creating a stack histogram for "price" based on "clarity".
ggplot(diamonds, aes(x = price, fill = clarity)) + geom_histogram()
# Creating a stack histogram for "price" based on "cut".
ggplot(diamonds, aes(x = price, fill = cut)) + geom_histogram()
#-----------------------------------
#  DENSITY PLOTS
#---------------
ggplot(diamonds, aes(x = price)) + geom_density()

# Coloring the data based on the "cut" attribute.
ggplot(diamonds, aes(x = price, col = cut)) + geom_density()
#------------------------------------------
# BOX PLOTS
#----------
# Used to compare multiple densities
ggplot(diamonds, aes(x = color, y = price, color = "red")) + geom_boxplot()
# We have a lot of outliers in the above boxplot. We can use scaling to overcome this.
ggplot(diamonds, aes(x = color, y = price)) + geom_boxplot() + scale_y_log10()
#---------------
# VIOLIN PLOTS
#-------------
ggplot(diamonds, aes(x = color, y = price)) + geom_violin()
ggplot(diamonds, aes(x = color, y = price)) + geom_violin() + scale_y_log10()
ggplot(diamonds, aes(y = price, x = color)) + geom_violin() + facet_wrap(~ clarity, scales = "free_y")
#----------------------
# q-plot
#-------
set.seed(1)
x <- rnorm(1000)
qplot(x, fill = "red")
qplot(x, fill = "red", binwidth = 0.1)
qplot(x, fill = "yellow", binwidth = 0.2) + xlab("Random Normal Values") + ylab("Frequency")
# creating a scatter plot
set.seed(2)
y <- rnorm(1000)
qplot(x, y)
qplot(x, y) + geom_smooth()
#-----------------------
data("WorldPhones")
head(WorldPhones, 10)
summary("WorldPhones")
View(WorldPhones)
library(reshape2)
worldPhones.m <- melt(WorldPhones)
worldPhones.m
colnames(worldPhones.m) <- c("Year", "Continent", "Phones")
View(worldPhones.m)
# In melted format it becomes easy to visualise in ggplot2.
ggplot(worldPhones.m, aes(x = Year, y = Phones, col = Continent)) + geom_point()
ggplot(worldPhones.m, aes(x = Year, y = Phones, col = Continent)) + geom_line()
# The data is not linear and difficult to visualise. To overcome this use log scales
ggplot(worldPhones.m, aes(x = Year, y = Phones, col = Continent)) + geom_line() + scale_y_log10()
#----------------
# SAVING THE PLOTS
#-----------------
ggplot(diamonds, aes(x = carat, y = price)) + geom_point()
# Save the plot in an object, say p.
p <- ggplot(diamonds, aes(x = carat, y = price)) + geom_point()
# Saving the plot
ggsave(filename = "diamond.png", p)
