clear
set more off

use "$wdata/analysis/IPEDS_TTEData_for_Simulation.dta", clear

keep if year == 2021

collapse (mean)under*2021 minor*2021

gen no=1
reshape long under minor, i(no) j(race) string

replace race = subinstr(race,"2021","",.)
replace no = 2 if race == "bkaa"
replace no = 3 if race == "hisp"
replace no = 4 if race == "asia"
replace no = 5 if race == "nhpi"
replace no = 6 if race == "aian"
replace no = 7 if race == "2mor"
replace no = 8 if race == "unkn"
replace no = 9 if race == "nral"

sort no

format under minor %4.2f
