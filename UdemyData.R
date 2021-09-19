
library(Amelia)
library(mice)
library(VIM)
library("rpart")
# Random forest for Udemy data

setwd("F:/National College of Ireland/Data Mining and Machine learning/Final project dataset/Datasets copy/Udemy")


Udemy_data <- read.csv('F:/National College of Ireland/Data Mining and Machine learning/Final project dataset/Datasets copy/Udemy/Udemy.csv')
str(Udemy_data)
summary(Udemy_data)


#Droping insignificant columns 
#Creating new dataframe for the droped columns 
Udemy_data_dropped <- Udemy_data

Udemy_data_dropped <- Udemy_data_dropped[,-c(1,2,7,9,10,12,14)]
str(Udemy_data_dropped)


# Finding missing values 

sapply(Udemy_data_dropped,function(x) sum(is.na(x)))

# Graphical Representation of the missing values


#Visual representation of missing data

missmap(Udemy_data_dropped, main = "Missing values vs observed")



#Reference Handling missing values
##########  USING MICE PACKAGE TO FIND PATTERNS AND PREDICTIVE MEAN METHOD FOR IMPUTATION ###################

md.pattern(Udemy_data_dropped)


mice_plot <- aggr(Udemy_data_dropped, col=c('navyblue','yellow'),
                    numbers=TRUE, sortVars=TRUE,
                    labels=names(Udemy_data_dropped), cex.axis=.8,
                    gap=3, ylab=c("Missing data","Pattern"))



imputed_Data <- mice(Udemy_data_dropped, m=9, maxit = 50, method = 'pmm', seed = 500)
summary(imputed_Data) 
imputed_Data$imp$discount_price__amount #imputed mean for discount_price_amount
imputed_Data$imp$price # imputed mean for price
densityplot(imputed_Data) # Density plot for Imputed data and the observed data 

Udemy_newdata <- complete(imputed_Data,1)  # Imputed mean replaced 

str(Udemy_newdata)
sapply(Udemy_newdata,function(x) sum(is.na(x))) # 0 missing values replaced with mean

##############################  CHECKING FOR CORRELATIONS  ####################



#Converting is_paid in to factor
Udemy_newdata$is_paid <- as.factor(Udemy_newdata$is_paid)
Udemy_newdata$is_paid <- as.numeric(Udemy_newdata$is_paid)

str(Udemy_newdata)

Udemy_Correlation <- Udemy_newdata


#Checking correlations and printing heatmap



Heatmap_corr <- cor(Udemy_Correlation, use="complete.obs", method ="kendall") #Storing correlation matrix in dataframe
Heatmap_corr




install.packages("heatmaply")
library(heatmaply)
heatmaply(Heatmap_corr, draw_cellnote = TRUE, cellnote_color = "auto") # heatmaps with labels





##########  CHECKING OUTLIERS ##############
str(Udemy_newdata)
boxplot(Udemy_newdata)

hist(Udemy_newdata$num_subscribers)

Udemy_newdata$num_subscribers <- log(Udemy_newdata$num_subscribers)
Udemy_newdata$num_reviews <- log(Udemy_newdata$num_reviews)

hist(Udemy_newdata$price)

Udemy_newdata$price <- log(Udemy_newdata$price)

##########################  COPNVERTING IN TO FACTORS ###########################

Udemy_factors <- Udemy_newdata
str(Udemy_factors)
Udemy_factors$is_paid <- as.numeric(Udemy_factors$is_paid)
Udemy_factors$num_subscribers <- as.numeric(Udemy_factors$num_subscribers)
Udemy_factors$avg_rating <- as.numeric(Udemy_factors$avg_rating)
Udemy_factors$num_reviews <- as.numeric(Udemy_factors$num_reviews)
Udemy_factors$num_published_lectures <- as.numeric(Udemy_factors$num_published_lectures)
Udemy_factors$discount_price__amount <- as.numeric(Udemy_factors$discount_price__amount)
Udemy_factors$price <- as.numeric(Udemy_factors$price)


#Training the model 

smp_size <- floor(0.75 * nrow(Udemy_factors))
set.seed(123)
train_sup <- sample(seq_len(nrow(Udemy_factors)), size = smp_size)



train <- Udemy_factors[train_sup,]
test <- Udemy_factors[-train_sup,]




##############  decision tree  #################


model_dec= rpart(Udemy_factors$avg_rating~ Udemy_factors$is_paid + Udemy_factors$num_subscribers +
                        Udemy_factors$num_reviews + Udemy_factors$price,method="anova", data = train)


summary(model_dec)
ba=predict(model_dec, newdata = test[3])
ba
summary(ba)




################ R2 value #############
actual_u <- Udemy_factors$avg_rating
predicted_u <- ba
R2_dt <- 1 - (sum((predicted_u-actual_u)^2)/sum((actual_u-mean(actual_u))^2))
R2_dt
summary(model)$coefficient
cor(actual_u,predicted_u)^2
qqnorm(actual_u)
qqline(predicted_u)


library("Metrics")
rmse_ML <-  rmse(ba,test$avg_rating)
rmse_ML







