#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
#                                                     "*package - data.table*"
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
# Reading in a data from a url.
    salaries <- read.csv("http://dgrtwo.github.io/pages/lahman/Salaries.csv")
    View(salaries)
    class(salaries)

# Data manipulation with library "data.table".
    library(data.table)
    salaries <- as.data.table(salaries)
    salaries
    # 1. Accessing a column.
         salaries$salary[1:5]
    # 2. Accessing a particular row of the dataset.
         salaries[1,] # 1st row.
         salaries[1:5,] # Accessing range of rows (1st to 5th row).
         salaries[, list(yearID, salary)] # Accessing range of columns.
    # 3. Accessing a subset of the dataset given some condition.
         # Data for year 2000 or ahead.
           salaries[yearID > 2000, ]
         # Data for the year 2001.
           salaries[yearID == 2001, ] 
         # Data for the lgID = "NL".
           salaries[lgID == "NL",]
         # Data based on multiple conditions.
           salaries[lgID == "AL" & yearID > 2010,] # AND "&" operator
           salaries[yearID < 1990 | yearID > 2010] # OR "|" operator
    # 4. Sorting
         # Based on Salary
           salaries[order(salary),]
           salaries[order(yearID, salary),]
    # 5. Mean salary of a specific year.
         salaries[yearID == 2005, ]$salary
         mean(salaries[yearID == 2005, ]$salary)
    # 6. Mean salary yearwise.
         salaries[, mean(salary), by = "yearID"]
         # Naming the column average.
           salaries[, list(Average = mean(salary)), by = "yearID"]
  
         # Two columns at a time.
           salaries[, list(Average = mean(salary), MaxSalary = max(salary)), by = "yearID"]
         # Similarly one can add more than two columns like minimum, standard deviation, etc.
         # Summarising average and maximum by leagueID.
           salaries[, list(Average = mean(salary), Maximum = max(salary), StandardDeviation = sd(salary)), by = "lgID"]
  
         # Getting summarised value for some particular years.
           salaries[, list(Average = mean(salary), MaxSalary = max(salary)), by = "yearID"]
           summarized.team = salaries[, list(Average = mean(salary), MaxSalary = max(salary)), by = "yearID"]
           summarized.team[yearID > 2010, ]
  
         # Grouping by two variables.
           summarized.yr.lg <- salaries[, list(Average = mean(salary), Maximum = max(salary)), by = c("yearID", "lgID")]
           summarized.yr.team <- salaries[, list(Average = mean(salary), Maximum = max(salary)), by = c("yearID", "teamID")]
           summarized.team
           summarized.yr.team
  
     # 7. Plotting salary as a timeline.
          library(ggplot2)
          ggplot(salaries, aes(x = yearID, y = salary)) + geom_point()
  
          # Plotting average salary as timeline.
            summarized.year
            ggplot(summarized.year, aes(x = yearID, y = Average)) + geom_line()
            summarized.yr.lg
            ggplot(summarized.yr.lg, aes(x = yearID, y = Average, col = lgID)) + geom_line()

     # 8. Merging Data
          master <- read.csv("http://dgrtwo.github.io/pages/lahman/Master.csv")
          View(master)
          master <- as.data.table(master)
          summary(master)
          salaries[playerID == "aardsda01"]
          
          # Doing this for each is a tedious task. There is method to merge these 2 datasets.
            merged.salaries <- merge(salaries, master, by = "playerID")
            merged.salaries
            summary(merged.salaries)
  
          # Merging two columns.
            merged.salaries[, name := paste(nameFirst, nameLast)] # Paste is used to combine two objects separated by space.
            View(merged.salaries)
  
          # Complicated merging
            batting <- read.csv("http://dgrtwo.github.io/pages/lahman/Batting.csv")
            batting <- as.data.table(batting)
            View(batting)
            # Here, the batting dataset shares more than one variable with the salaries dataset unlike the master dataset case.
            # Here, we need to merge the dataset with all the common variables.
              merged.batting <- merge(batting, salaries, by = c("playerID", "teamID", "lgID", "yearID"))
              View(merged.batting) # This merging has only common data.
            # To get the uncommon data also we need to put an argumenet all.x = TRUE
              merged.batting <- merge(batting, salaries, by = c("playerID", "teamID", "lgID", "yearID"), all.x = TRUE)
            # Merging all the datasets
              merged.all <- merge(merged.batting, master, by = "playerID")
            # Getting the total runs scored by the batters
              summarized.batters <- merged.all[, list(Total.HR = sum(HR)), by = "playerID"]
              summarized.batters
            # We also need name of the batter along with their total home runs.
              merged.all[, name := paste(nameFirst, nameLast)]
              summarized.batters <- merged.all[, list(Total.HR = sum(HR)), by = c("playerID", "name")]
              summarized.batters
              summarized.batters[order(Total.HR),]
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#

   
  
