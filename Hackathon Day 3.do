* Tanisha Khabe
* 5/30/2024

* Hackathon Day 3

*close any possibly open log-files
cap log close
*start a log file
log using lab3_tanishakhabe.log, replace

cd "/Users/tanishakhabe/Desktop/PREDOC Stata Course"

use predoc_smoking.dta, clear

* Draw graphs to analyze the relationship between pack_sales and state_tax_dollatrs. 

* Figure 1
twoway (scatter pack_sales state_tax_dollars if year == 2018, msymbol(square) mlabel(state_name)) (lfit pack_sales state_tax_dollars), ytitle("Cigarette Consumption (Packs per Capita)") legend(off)
graph export figure1.png, replace

* Figure 2
twoway (scatter pack_sales state_tax_dollars, msymbol(square)) (lfit pack_sales state_tax_dollars), ytitle("Cigarette Consumption (Packs per Capita)") legend(off)
graph export figure2.png, replace

* Figure 3 
binscatter pack_sales state_tax_dollars, controls(i.year)
graph export figure3.png, replace

* Figure 4
binscatter pack_sales state_tax_dollars, controls(i.year i.state_fips)
graph export figure4.png, replace

* Figure 5
binscatter pack_sales state_tax_dollars, controls(i.year i.state_fips population personal_income)
graph export figure5.png, replace

* Running the regressions corresponding to each figure. 
reg pack_sales state_tax_dollars if year == 2018, robust
outreg2 using table_1.xls, replace keep(state_tax_dollars)

reg pack_sales state_tax_dollars, robust
outreg2 using table_1.xls, keep(state_tax_dollars)

reg pack_sales state_tax_dollars i.year, robust
outreg2 using table_1.xls, keep(state_tax_dollars) addtext(Year FE, YES)

reg pack_sales state_tax_dollars i.year i.state_fips, robust
outreg2 using table_1.xls, keep(state_tax_dollars) addtext(Year FE, YES, State FE, YES)

reg pack_sales state_tax_dollars i.year i.state_fips population personal_income, robust
outreg2 using table_1.xls, keep(state_tax_dollars) addtext(Year FE, YES, State FE, YES, Population FE, YES, Personal Income FE, YES)

* Repeating the regressions from above, but with transformed pack_sales and state_tax_dollars. 
generate logpack_sales = log(pack_sales)
generate logstate_tax_dollars = log(state_tax_dollars)

* Figure 1 & New Regression 1
twoway (scatter logpack_sales logstate_tax_dollars if year == 2018, msymbol(square) mlabel(state_name)) (lfit logpack_sales logstate_tax_dollars), ytitle("Cigarette Consumption (Packs per Capita)") legend(off)
graph export log_figure1.png, replace

reg logpack_sales logstate_tax_dollars if year == 2018, robust
outreg2 using table_2.xls, replace keep(logstate_tax_dollars)

* Figure 2 & New Regression 2
twoway (scatter logpack_sales logstate_tax_dollars, msymbol(square)) (lfit logpack_sales logstate_tax_dollars), ytitle("Cigarette Consumption (Packs per Capita)") legend(off)
graph export log_figure2.png, replace

reg logpack_sales logstate_tax_dollars, robust
outreg2 using table_2.xls, keep (logstate_tax_dollars)

* Figure 3 & New Regression 3 
binscatter logpack_sales logstate_tax_dollars, controls(i.year)
graph export log_figure3.png, replace

reg logpack_sales logstate_tax_dollars i.year, robust
outreg2 using table_2.xls, keep (logstate_tax_dollars) addtext(Year FE, YES)

* Figure 4 & New Regression 4
binscatter logpack_sales logstate_tax_dollars, controls(i.year i.state_fips)
graph export log_figure4.png, replace

reg logpack_sales logstate_tax_dollars i.year i.state_fips, robust
outreg2 using table_2.xls, keep (logstate_tax_dollars) addtext(Year FE, YES, State FE, YES)

* Figure 5 & New Regression 5
binscatter logpack_sales logstate_tax_dollars, controls(i.year i.state_fips population personal_income)
graph export log_figure5.png, replace

reg logpack_sales logstate_tax_dollars i.year i.state_fips population personal_income, robust
outreg2 using table_2.xls, keep (logstate_tax_dollars) addtext(Year FE, YES, State FE, YES, Population FE, YES, Personal Income FE, YES)

*close and save log file
log close



