clear
set more off

use "$wdata/analysis/IPEDS_Balanced_Panel.dta", clear

keep if year == 2001
gen v1 = ftetotl
egen weight = mean(v1), by(unitid)


sort unitid year
by unitid: replace control = control[_n-1] if _n > 1
by unitid: replace icleve = icleve[_n-1] if _n > 1

gen institution = 0
replace institution = 1 if control == 1 & icleve == 4
replace institution = 2 if control == 2 & icleve == 4
replace institution = 3 if control == 3 & icleve == 4
replace institution = 4 if control == 1 & icleve == 2
replace institution = 5 if control == 2 & icleve == 2
replace institution = 6 if control == 3 & icleve == 2

keep unitid instnm institution weight
duplicates drop

merge 1:m unitid using "$wdata/analysis/simulation/IPEDS_Prediction_Scenario_v50.dta"
keep if _m == 3
drop _m
merge 1:1 unitid year using "$wdata/analysis/IPEDS_Balanced_Panel.dta", replace update
drop if _m == 2
drop _m
merge 1:1 unitid year using "$wdata/intermediate/Hiring_Projection.dta", replace update
drop if _m == 2
drop _m

sort unitid year

keep if year == 2019 | year == 2035

keep unitid weight year propis* propfte* is_D9* is_R9*

rename is_D9 isD
rename is_R9 isR
replace isD = is_D9_b50 if isD == .
replace isR = is_R9_b50 if isR == .
rename propftetmor_hat propfte2mor_hat

foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral{
	replace propis`category' = propis`category'_b50 if propis`category' == .
	replace propfte`category' = propfte`category'_hat if propfte`category' == .
}
keep unitid weight year propiswhit-propisnral propftewhit-propftenral isD isR

recode year 2019=0 2035=1

reshape wide prop* isD isR, i(unitid weight) j(year)

cap gen totprop0 = .
cap gen totprop1 = .

foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral{
	foreach var in is fte {
		cap gen prop`var'`category' = .

		replace prop`var'`category' = prop`var'`category'1
		replace totprop1 = 1 - prop`var'`category'1
		replace totprop0 = 0
		
		foreach category2 in whit bkaa hisp asia nhpi aian 2mor unkn nral{
			if "`category2'" != "`category'"{
				replace totprop0 = totprop0 + prop`var'`category2'0
			}
		}
		foreach category2 in whit bkaa hisp asia nhpi aian 2mor unkn nral{
			if "`category2'" != "`category'"{
				cap gen prop`var'`category2' = .
				replace prop`var'`category2' = prop`var'`category2'0 / totprop0 * totprop1
			}
		}
		
		gen `var'D1_`category' = (1-(prop`var'whit^2 + prop`var'bkaa^2 + prop`var'hisp^2 + prop`var'asia^2 + prop`var'nhpi^2 + prop`var'aian^2 + prop`var'2mor^2 + prop`var'unkn^2 + prop`var'nral^2))/8*9
		replace `var'D1_`category' = 1 if `var'D1_`category' > 1 & `var'D1_`category' ~= .
		
		if "`var'" == "fte"{
			foreach category2 in whit bkaa hisp asia nhpi aian 2mor unkn nral{
				cap gen propis`category2' = .
				replace propis`category2' = propis`category2'0
			}
		}
		if "`var'" == "is"{
			foreach category2 in whit bkaa hisp asia nhpi aian 2mor unkn nral{
				cap gen propfte`category2' = .
				replace propfte`category2' = propfte`category2'0
			}
		}
		
		gen `var'R_`category' = 1 - sqrt( ( ///
						(propiswhit - propftewhit)^2 + ///
						(propisbkaa - propftebkaa)^2 + ///
						(propishisp - propftehisp)^2 + ///
						(propisasia - propfteasia)^2 + ///
						(propisnhpi - propftenhpi)^2 + ///
						(propisaian - propfteaian)^2 + ///
						(propis2mor - propfte2mor)^2 + ///
						(propisunkn - propfteunkn)^2 + ///
						(propisnral - propftenral)^2 ) / 2 )
						
		replace `var'R_`category' = 1 if `var'R_`category' > 1 & `var'R_`category' ~= .
		replace `var'R_`category' = 0 if `var'R_`category' < 0 & `var'R_`category' ~= .
	}
}

save  "$wdata/bootstrap/Decomposition_Change_Group9_Baseline_Temp.dta", replace

collapse (mean)isD* fteR* isR* [aw=weight]

reshape long isD1_ fteR_ isR_, i(isD0 isD1 isR0 isR1) j(category) string

rename isD1_ D_Faculty
rename fteR_ R_Student
rename isR_ R_Faculty

gen con_D_Faculty = (D_Faculty - isD0) // (isD1 - isD0)
gen con_R_Student = (R_Student - isR0) // (isR1 - isR0)
gen con_R_Faculty = (R_Faculty - isR0) // (isR1 - isR0)

replace category = "tmor" if category == "2mor"
keep category con*

tostring _all, replace force

sxpose, clear firstnames destring

gen var = ""
replace var = "D_Faculty" in 1
replace var = "R_Student" in 2
replace var = "R_Faculty" in 3

order var

foreach category in whit bkaa hisp asia nhpi aian tmor unkn nral{
	rename `category' p`category'
}

reshape long p, i(var) j(race) string

gen no = .
replace no = 9 if race == "whit"
replace no = 8 if race == "bkaa"
replace no = 7 if race == "hisp"
replace no = 6 if race == "asia"
replace no = 5 if race == "nhpi"
replace no = 4 if race == "aian"
replace no = 3 if race == "tmor"
replace no = 2 if race == "unkn"
replace no = 1 if race == "nral"

sort var no

save "$wdata/bootstrap/Decomposition_Change_Group9_Baseline_Main.dta", replace
wegwe
**********************************************************************

forv i = 1(1)1000{
	if `i' == 1 {
		dis "Bootstrap (1,000)"
		dis "----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5"
	}
	_dots `i' 0
	qui{
	set seed `i'
	use "$wdata/bootstrap/Decomposition_Change_Group9_Baseline_Temp.dta", clear
	bsample
	
	collapse (mean)fteD* isD* fteR* isR* [aw=weight]

	reshape long isD1_ fteR_ isR_, i(isD0 isD1 isR0 isR1) j(category) string

	rename isD1_ D_Faculty
	rename fteR_ R_Student
	rename isR_ R_Faculty

	gen con_D_Faculty = (D_Faculty - isD0) // (isD1 - isD0)
	gen con_R_Student = (R_Student - isR0) // (isR1 - isR0)
	gen con_R_Faculty = (R_Faculty - isR0) // (isR1 - isR0)

	keep category con*

	tostring _all, replace force
	
	replace category = "tmor" if category == "2mor"

	sxpose, clear firstnames destring

	gen var = ""
	replace var = "D_Faculty" in 1
	replace var = "R_Student" in 2
	replace var = "R_Faculty" in 3

	order var

	foreach category in whit bkaa hisp asia nhpi aian tmor unkn nral{
		rename `category' p`category'
	}

	reshape long p, i(var) j(race) string

	gen no = .
replace no = 9 if race == "whit"
replace no = 8 if race == "bkaa"
replace no = 7 if race == "hisp"
replace no = 6 if race == "asia"
replace no = 5 if race == "nhpi"
replace no = 4 if race == "aian"
replace no = 3 if race == "tmor"
replace no = 2 if race == "unkn"
replace no = 1 if race == "nral"

	gen sample = `i'

	save "$wdata/bootstrap/Decomposition_Change_Group9_Baseline_Bsample`i'.dta", replace
	}
}

clear
forv i = 1(1)1000{
	ap using "$wdata/bootstrap/Decomposition_Change_Group9_Baseline_Bsample`i'.dta"
}

collapse (sd)p, by(var race no)
rename p se
merge 1:1 var race no using "$wdata/bootstrap/Decomposition_Change_Group9_Baseline_Main.dta"
drop _m

gen upper = p + 1.96 * se
gen lower = p - 1.96 * se

twoway 	(bar p no if var == "D_Faculty", hori barw(0.6) fc(gs10) lc(black)) ///
		(rcap upper lower no if var == "D_Faculty", hori color(black)), ///
		scheme(s1color) xtitle(Change in Faculty Diversity Index) xlabel(0(0.01)0.04, format(%4.2f)) ///
		ytitle(" ") ylabel(9 "White" 8 "Black" 7 "Hispanic" 6 "Asian" 5 "NHPI" 4 "AIAN" 3 "2 or More" 2 "Unknown" 1 "NRA", angle(0) labsize(small)) ///
		xline(0, lc(black)) legend(off) xscale(ra(-.0022 .04))
graph export "$figure/FigA2a_Diversity.png", as(png) replace		
		
		
replace no = no+0.2 if var == "R_Faculty"
replace no = no-0.2 if var == "R_Student"

twoway 	(bar p no if var == "R_Faculty", hori barw(0.4) fc(gs5) lc(black)) ///
		(rcap upper lower no if var == "R_Faculty", hori color(black)) ///
		(bar p no if var == "R_Student", hori barw(0.4) fc(gs12) lc(black)) ///
		(rcap upper lower no if var == "R_Student", hori color(black)), ///
		scheme(s1color) xtitle(Change in Representation Index) xlabel(-0.07(0.01)0.01, format(%4.2f)) ///
		ytitle(" ") ylabel(9 "White" 8 "Black" 7 "Hispanic" 6 "Asian" 5 "NHPI" 4 "AIAN" 3 "2 or More" 2 "Unknown" 1 "NRA", angle(0) labsize(small)) ///
		xline(0, lc(black)) legend(order(1 "Faculty" 3 "Student"))
graph export "$figure/FigA2b_Representation.png", as(png) replace		
