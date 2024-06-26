clear
set more off

use "$wdata/intermediate/NCES_RacialDistribution_Projection.dta", clear

merge 1:1 year using "$wdata/intermediate/Age1829_Population_Projection.dta"
drop _m

foreach x in whit bkaa hisp asia nhpi aian tmor{
	reg `x' prop*`x'
	predict `x'hat
}

drop if year > 2035

keep year whithat bkaahat hisphat asiahat nhpihat aianhat tmorhat
save "$wdata/intermediate/Enrollment_Projection_Racial_Final.dta", replace
