clear
set more off

import excel using "$rdata/NCES/tabn307.10.xls", clear

gen year = substr(A,1,4)
destring year, replace force
keep if year != . & year != 1
rename F projenrftepub4
rename G projenrftepub2
rename I projenrftepri4
rename L projenrftepri2

keep year projenrfte*
order year
destring _all, replace

reshape long projenrfte, i(year) j(instype) string

replace instype = "Public4-year" if instype == "pub4"
replace instype = "Public2-year" if instype == "pub2"
replace instype = "Private4-year" if instype == "pri4"
replace instype = "Private2-year" if instype == "pri2"

save "$wdata/intermediate/NCES_Enrollment_Projection_19702028.dta", replace


import excel using "$rdata/NCES/tabn303.30.xls", clear

gen var = subinstr(subinstr(A,".","",.)," ","",.)

order var

foreach x of varlist H-Z{
	loc yr: dis `x'[3]
	rename `x' yr`yr'
}

keep var yr*

destring yr*, replace force
drop if yr2015 == .
drop in 1/2

compress

gen instype = var if var != "Males" & var != "Females" & var != "Full-time" & var != "Part-time"
gen atttype = var if var == "Full-time" | var == "Part-time" 

keep if instype != "" | atttype != ""
replace instype = instype[_n-1] if instype == ""
keep if atttype != ""

keep if instype == "Public4-year" | instype == "Private4-year" | instype == "Public2-year" | instype == "Private2-year"

drop var

order instype atttype

reshape long yr, i(instype atttype) j(year)

replace atttype = "ft" if atttype == "Full-time"
replace atttype = "pt" if atttype == "Part-time"
rename yr projenr

reshape wide projenr, i(instype year) j(atttype) string

save "$wdata/intermediate/NCES_Enrollment_Projection.dta", replace

import excel using "$rdata/NCES/tabn306.30.xls", clear

rename C whit
rename D bkaa
rename E hisp
rename F aspi
rename G asia
rename H nhpi
rename I aian
rename J tmor

gen year = substr(A,1,4)
destring year, replace force
drop if year == .

keep year whit bkaa hisp aspi asia nhpi aian tmor
order year
drop if year == 1
destring _all, replace force

save "$wdata/intermediate/NCES_RacialDistribution_Projection.dta", replace

use "$wdata/intermediate/NCES_Enrollment_Projection.dta", clear
gen totl = projenrft + projenrpt
collapse (sum)totl, by(year)
replace totl = totl / 1000

merge 1:1 year using "$wdata/intermediate/NCES_RacialDistribution_Projection.dta"
keep if _m == 3
drop _m

replace asia = asia / aspi
replace nhpi = nhpi / aspi

foreach x in whit bkaa hisp aspi aian tmor{
	replace `x' = `x' / totl
}

gen unkn_nral = 1 - whit - bkaa - hisp - aspi - aian - tmor

reg asia year
predict asia_hat
replace asia = aspi * asia
replace asia = aspi * asia_hat if asia == .
replace nhpi = aspi * nhpi
replace nhpi = aspi * (1-asia_hat) if nhpi == .
drop asia_hat
drop totl

save "$wdata/intermediate/NCES_RacialDistribution_Projection.dta", replace
