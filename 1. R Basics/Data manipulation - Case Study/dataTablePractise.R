#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
#                                   "*Some basic Data Manipulation problems in R*"
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
    
    # Question 1: Import the customer data into R using read.csv, read.table etc.
      # CODE :-

        getwd()
        dir()
        customers <- read.csv("Dataset - Customers.csv")
        library(data.table)
        customers <- as.data.table(customers)
        summary(customers)
        
#----------------------------------------------------------------------------------------------------------------------------------------#
#----------------------------------------------------------------------------------------------------------------------------------------#
    
    # Question 2: Understand the data using different functions like View, head, tail, str, names, nrow, ncol, summary, duplicates, 
    # describe etc.
      # CODE :-
        
        # 1. View function
             View(customers)
        
        # 2. head function
             head(customers)
             head(customers, 10)
             
        # 3. tail function
             tail(customers)
             tail(customers, 5)
             
        # 4. str function
             str(customers)
             
        # 5. names funtion
             names(customers)
             
        # 6. ncol, nrow & dim functions
             ncol(customers)
             nrow(customers)
             dim(customers)
             
        # 7. Summarizing the data.
             summary(customers)
             
             library(psych)
             describe(customers)
             
        # 8. Duplicate observations in the dataset.
             anyDuplicated(customers, by = "Customer.ID") # Result - 9818. 9818 is the index of the first duplicate, if there would
                                                          # be no duplicates this value would be 0.
             duplicated(customers) # Returns a logical vector indicating which rows are duplicates.
             
#-------------------------------------------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------------------------------------------#
             
    # Question 3: What is percentage of missing values for customer value variable?
      # CODE :-
             
        # Total number of missing values.
          sum(is.na(customers))
             
        # Missing values in customer value variable.
          sum(is.na(customers$Customer.Value))
        
        # Percentage of missing values for customer value variable.
          (sum(is.na(customers$Customer.Value))/nrow(customers))*100
          
#-------------------------------------------------------------------------------------------------------------------------------------#
#-------------------------------------------------------------------------------------------------------------------------------------#
          
    # Question 4 : Create two subsets with unique and duplicate values.
      # CODE :-
        uniquecustomers <- customers[duplicated(customers, by = "Customer.ID") == FALSE,]
        View(uniquecustomers)
        duplicatecustomers <- customers[duplicated(customers, by = "Customer.ID") == TRUE,]     
        View(duplicatecustomers)
        
#--------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------------#
        
    # Question 5: Create data set with list of customers whose customer value is greater than 10000.
      # CODE :-
        customers[Customer.Value > 10000]
        
#--------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------------#
        
    # Question 6: In customer table, create a new variable called "customer value segment" using customer value as follows.
    #             - High Value Segment - > 25000,
    #             - Medium Value Segment - Between 10000 and 25000,
    #             - Low Value Segment - less than or equal to 10000.
      # CODE :-
        customers[ , customerValueSegment := ifelse(Customer.Value > 25000, "High Value Segment", ifelse(Customer.Value < 10000, 
                     "Low Value Segment", "Medium Value Segment"))]
        View(customers)
        
#--------------------------------------------------------------------------------------------------------------------------------------#
#--------------------------------------------------------------------------------------------------------------------------------------#
        
    # Question 7: Create variables "average revenue per trip" and "balance points" in the customer data set.
      # CODE :-
        customers[, "AverageRevenuePerTrip" := (Customer.Value/buy.times)]
        customers[, "BalancePoints" := (Points.earned - Points.redeemed)]
        View(customers)
        
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
        
    # Question 8: How many days between last purchase date and today?
      # CODE :-
        customers$recent.date <- as.character(customers$recent.date)
        customers$recent.date <- as.Date(customers$recent.date, format = "%Y%m%d")
        customers[, "lastPurchaseDate" := difftime(recent.date, Sys.Date(), units = "days")]
        
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
        
    # Question 9: Calculate percentage of sales by last city, state and region.
      # CODE :-
        SumValue <- customers[, sum(Customer.Value, na.rm = TRUE), by = list(Last_city, Last_state, Last_region)]
        View(SumValue)
        SumValue[, "percentSales" := ((V1/sum(V1))*100)]
        View(SumValue) 
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
        
    # Question 10: What is the count of customers and average number of purchases by last state and city.
      # CODE :-
        Count <- customers[, list(Customer.ID, buy.times, AverageRevenuePerTrip), by = list(Last_state, Last_city)]
        View(Count)
        Count[, list(.N), by = list(Last_state, Last_city)] # Count of customers by Last state and city.
        a <- Count[, sum(buy.times), by = list(Last_state, Last_city)] # Buy times by Last state & city.
        a <- (a/sum(customers$buy.times))
    
#---------------------------------------------------------------------------------------------------------------------------------------#
#---------------------------------------------------------------------------------------------------------------------------------------#
        
