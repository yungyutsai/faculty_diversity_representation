clear
set more off

import delim using "$rdata/CB/np2017_d1_mid.csv", clear

keep if inrange(year,2016,2040)
keep if sex == 0
keep if inrange(race,0,6)

gen r = ""
replace r = "totl" if race == 0 & origin == 0
replace r = "whit" if race == 1 & origin == 1
replace r = "bkaa" if race == 2 & origin == 1
replace r = "hisp" if race == 0 & origin == 2
replace r = "asia" if race == 4 & origin == 1
replace r = "nhpi" if race == 5 & origin == 1
replace r = "aian" if race == 3 & origin == 1
replace r = "tmor" if race == 6 & origin == 1

drop if r == ""

keep r year pop_18-pop_29
reshape long pop_, i(year r) j(age)
recode age 18/24 = 1824 25/29 = 2529
collapse (sum)pop*, by(year r age)

sort r year

reshape wide pop, i(year r) j(age)
reshape wide pop*, i(year) j(r) string

foreach x in 1824 2529{
	foreach y in whit bkaa hisp asia nhpi aian tmor{
		gen prop_`x'`y' = pop_`x'`y' / pop_`x'totl
	}
}

gen pop_totl = pop_1824totl + pop_2529totl
order year pop_totl pop_1824totl pop_2529totl 
format pop* %14.0fc
format prop* %9.3f

save "$wdata/intermediate/Age1829_Population_Projection.dta", replace

/*
import delim using "$rdata/CB/np2023_d1_mid.csv", clear

keep if inrange(year,2022,2035)
keep if sex == 0
keep if inrange(race,0,6)

gen r = ""
replace r = "whit" if race == 1 & origin == 1
replace r = "bkaa" if race == 2 & origin == 1
replace r = "hisp" if race == 0 & origin == 2
replace r = "asia" if race == 4 & origin == 1
replace r = "nhpi" if race == 5 & origin == 1
replace r = "aian" if race == 3 & origin == 1
replace r = "tmor" if race == 6 & origin == 1

drop if r == ""

keep r year pop_18-pop_29
reshape long pop_, i(year r) j(age)
collapse (sum)pop*, by(year r)

egen totpop = sum(pop), by(year)

sort r year

replace pop = pop / totpop
drop tot
reshape wide pop, i(year) j(r) string

ap using "$wdata/intermediate/Age1829_Population_Projection.dta"

sort year
save "$wdata/intermediate/Age1829_Population_Projection.dta", replace


twoway (line pop_whit year)(line pop_hisp year)
*/
