# Decision-tree-regressor-for-Udemy-dataset
Implementing Decision tree regression technique to predict ratings for Udemy dataset

The project 

Udemy dataset contains the data for online content courses of about 10,000 financial courses. The dataset contains 13609 rows and 14 columns. avg_ratings is considered to be a dependent variable. From this dataset 
I will try to predict how much rating course will get, if the new course is published

KDD Methodology is used as a Data Mining technique to implement the project
The steps includes: 

Data cleaning and pre-processing: Data is in the form of .csv format. It is first loaded in to R using read_csv() function. Insignificant columns are dropped from the dataset. Once the data set is loaded in to R, it is checked for the missing values using sapply() function. 2% missing values are detected by plotting graph using missmap() function from "Amelia" package.

Handling missing values: These values are handled by using the imputation technique. There are different methods which are used to impute mean. On this dataset ‘Predictive Mean Matching’ imputation technique from package ‘mice’ is used to find the pattern and handle missing values. At first md.pattern() function is used to find the patterns

Checking outliers: Outliers are checked by using boxplots and Histograms. To check the outliers boxplot() and hist() functions are used.

Data reduction and transformation: In this process outliers are handled. This is handled by using normalization technique. For the outliers to handle log normalization technique has been used. This is done by applying log on columns with outliers. After applying the log the data is normally distributed and outliers are handled.

Checking correlation: To print the correlation “kendall” correlation method is used.This is done by using cor() function and heatmaply() function from “heatmaply” package.

Model Selection: As the problem is identified as Regression problem Decision tree Regressor is used as a model for implementation. Decision tree regression is applied on training sets by using rpart() function from  “rpart” package and values are predicted on test set. 

Evaluation: To evaluate the result R2 and RMSE valuse is used.





