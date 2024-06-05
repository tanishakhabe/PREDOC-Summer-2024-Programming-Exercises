* Tanisha Khabe
* 5/28/2024

* Day 1 of the Hackathon

cd "/Users/tanishakhabe/Desktop/PREDOC Stata Course"

*close any possibly open log-files
cap log close
*start a log file
log using lab1_tanishakhabe.log, replace

use nlsy97 

* Plotting a histogram of kid_income. 
hist kid_income 
graph export histogram_kid_income.png, replace

* Calculating the sample mean of kid_income. 
sum kid_income
scalar mean_kid_income = r(mean)
display mean_kid_income

* Creating a new variable below_mean. 
gen below_mean = 0
replace below_mean = 1 if kid_income < mean_kid_income

* Calculating the sample mean of below_mean. 
sum below_mean
scalar below_mean_sm = r(mean)
display below_mean_sm

* Calculating the median of kid_income.
sum kid_income, d

* Calculating the standard deviation of kid_income.
sum kid_income, d
scalar sd_kid_income = r(sd)
display sd_kid_income

* Calculating what fraction of observations are within one SD of the mean of kid_income. 
gen within_one_sd = 0
replace within_one_sd = 1 if inrange(kid_income, mean_kid_income - sd_kid_income, mean_kid_income + sd_kid_income)
sum within_one_sd

* Calculating what fraction of observations are within two SDs of the mean of kid_income. 
gen within_two_sd = 0
replace within_two_sd = 1 if inrange(kid_income, mean_kid_income - (2*sd_kid_income), mean_kid_income + (2*sd_kid_income))
sum within_two_sd

* Percentile rank transformation. 
egen kid_inc_rank = rank(kid_income)

* Sorting the data by kid_income. 
sort kid_income 

* Normalizing rank so that the maximum is 100.
sum kid_inc_rank
scalar max_rank = r(max)
replace kid_inc_rank = 100* kid_inc_rank / max_rank

* Plotting a histogram of kid_inc_rank. 
hist kid_inc_rank
graph export histogram_kid_inc_rank.png, replace

* Verifying the sample mean of kid_inc_rank is approximately equal to its sample median. 
sum kid_inc_rank, d

* Visualizing the relationship between kid_income and parent_income.
* Scatter plot
scatter kid_income parent_income
graph export scatter_kid_parent_income.png, replace
* Binned scatter plot
ssc install binscatter
binscatter kid_income parent_income, linetype(connect)
graph export binscatter_kid_parent_income_connected.png, replace

* Random assignment.
set seed 11022005
gen random_number = runiform()

* Creating a new variable treatment_group. 
gen treatment_group = 1
replace treatment_group = 0 if random_number < 0.5
sum treatment_group

* Counting number of observations in treatment group and control group. 
count if treatment_group == 1
count if treatment_group == 0

* Calculating the sample mean and sample standard deviation of all variables. 
bys treatment_group: sum kid_income incarcerated child_education child_college child_sat parent_income mother_education father_education male black hispanic white region age2015 cohort

*close and save log file
log close

