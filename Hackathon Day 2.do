* Tanisha Khabe
* 5/29/2024

* Hackathon Day 2


*close any possibly open log-files
cap log close
*start a log file
log using lab2_tanishakhabe.log, replace

* Change working directory.                                                 
cd "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2"

* Starting with just the zip code level IRS data for 2020. 
import delimited "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/rawdata/irs2020.csv"

describe
tab agi_stub

* Creating a new year variable.
gen year = 2020
codebook year
label variable year "Tax Year"

* Saving the data set. 
save "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/rawdata/irs2020.dta", replace

* Load in the data for 2015-2020, saving each year as a separate stata data set. 
forvalues j = 2015/2020{
	display "Tax Year = " `j'
	import delimited "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/rawdata/irs`j'.csv", clear
	* Create year variable
	gen year = `j'
	label variable year "Tax Year"
	* Save data set
	save "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/output/irs`j'.dta", replace
}

* Appending to create one data set that combines the files for 2015 to 2020. 
use output/irs2015
append using output/irs2016
append using output/irs2017
append using output/irs2018
append using output/irs2019
append using output/irs2020
tab year

* Running the .do file to label all the variables. 
do "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/dofiles/label_irsdata.do"

* Saving the cleaned data set. 
save "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/output/irssoi_zip.dta", replace


* Opening and making changes to crosswalk data. 
use "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/crosswalk/hud_zips_county_xwalk.dta", clear
destring zipcode, replace
save "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/crosswalk/hud_zips_county_xwalk.dta", replace

use "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/output/irssoi_zip.dta", clear
merge m:1 zipcode using "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/crosswalk/hud_zips_county_xwalk.dta"

* Removing observations that were not successfully matched. 
keep if _merge == 3

* Using collapse to create a dataset of sums of all the variables in these data that have variable labels that include the word "Number" or "amount". 
describe
local vars ""
ds
foreach var of varlist _all {
	local label: variable label `var'
	if strpos(lower("`label'"), "number") > 0 | strpos(lower("`label'"), "amount") > 0 {
		 local vars `vars' `var'
	} 
}
display "`vars'"

collapse (sum) `vars', by(COUNTY agi_stub year)

* Using the .do file to label all the variables again. 
do "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/dofiles/label_irsdata.do"

* Producing summary statistics. 
sum

* Creating a new variable id_code. 
egen id_code = group(COUNTY agi_stub)

* Declaring the data to be a panel dataset with an id variable. 
xtset id_code year 
isid id_code year
xtdescribe

* Saving the cleaned data set.
save "/Users/tanishakhabe/Desktop/PREDOC Stata Course/bootcamp_day2/output/irssoi_county.dta", replace

*close and save log file
log close

