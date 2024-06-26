clear
set more off

use "$wdata/analysis/IPEDS_Balanced_Panel.dta", clear

gen v1 = ftetotl if year == 2001
egen weight = mean(v1), by(unitid)

sort unitid year

keep if year == 2010 | year == 2021

keep unitid weight year propfte* propis* fte_D7 is_D7 is_R7

rename fte_D7 fteD
rename is_D7 isD
rename is_R7 isR

recode year 2010=0 2021=1

reshape wide prop* fteD isD isR, i(unitid weight) j(year)

cap gen totprop0 = .
cap gen totprop1 = .

foreach category in whit bkaa hisp aspi aian othe nral{
	foreach var in fte is {
		cap gen prop`var'`category' = .

		replace prop`var'`category' = prop`var'`category'1
		replace totprop1 = 1 - prop`var'`category'1
		replace totprop0 = 0
		
		foreach category2 in whit bkaa hisp aspi aian othe nral{
			if "`category2'" != "`category'"{
				replace totprop0 = totprop0 + prop`var'`category2'0
			}
		}
		foreach category2 in whit bkaa hisp aspi aian othe nral{
			if "`category2'" != "`category'"{
				cap gen prop`var'`category2' = .
				replace prop`var'`category2' = prop`var'`category2'0 / totprop0 * totprop1
			}
		}
		gen `var'D1_`category' = (1-(prop`var'whit^2 + prop`var'bkaa^2 + prop`var'hisp^2 + prop`var'aspi^2 + prop`var'aian^2 + prop`var'othe^2 + prop`var'nral^2))/6*7
		replace `var'D1_`category' = 1 if `var'D1_`category' > 1 & `var'D1_`category' ~= .
		
		if "`var'" == "fte"{
			foreach category2 in whit bkaa hisp aspi aian othe nral{
				cap gen propis`category2' = .
				replace propis`category2' = propis`category2'0
			}
		}
		if "`var'" == "is"{
			foreach category2 in whit bkaa hisp aspi aian othe nral{
				cap gen propfte`category2' = .
				replace propfte`category2' = propfte`category2'0
			}
		}
		
		gen `var'R_`category' = 1 - sqrt( ( ///
						(propiswhit - propftewhit)^2 + ///
						(propisbkaa - propftebkaa)^2 + ///
						(propishisp - propftehisp)^2 + ///
						(propisaspi - propfteaspi)^2 + ///
						(propisaian - propfteaian)^2 + ///
						(propisothe - propfteothe)^2 + ///
						(propisnral - propftenral)^2 ) / 2 )
						
		replace `var'R_`category' = 1 if `var'R_`category' > 1 & `var'R_`category' ~= .
		replace `var'R_`category' = 0 if `var'R_`category' < 0 & `var'R_`category' ~= .
	}
}

save  "$wdata/bootstrap/Decomposition_Change_Group7_Temp.dta", replace

collapse (mean)fteD* isD* fteR* isR* [aw=weight]

reshape long fteD1_ isD1_ fteR_ isR_, i(fteD0 fteD1 isD0 isD1 isR0 isR1) j(category) string

rename fteD1_ D_Student
rename isD1_ D_Faculty
rename fteR_ R_Student
rename isR_ R_Faculty

gen con_D_Student = (D_Student - fteD0) // (fteD1 - fteD0)
gen con_D_Faculty = (D_Faculty - isD0) // (isD1 - isD0)
gen con_R_Student = (R_Student - isR0) // (isR1 - isR0)
gen con_R_Faculty = (R_Faculty - isR0) // (isR1 - isR0)

keep category con*

tostring _all, replace force

sxpose, clear firstnames destring

gen var = ""
replace var = "D_Student" in 1
replace var = "D_Faculty" in 2
replace var = "R_Student" in 3
replace var = "R_Faculty" in 4

order var

/*
gen all = whit + bkaa + hisp + aspi + aian + othe + nral
replace all = all + all[_n+1] in 3 
replace all = all[_n-1] in 4 
replace all = -all in 3/4

foreach category in whit bkaa hisp aspi aian othe nral{
	replace `category' = `category' / all
}

drop all
*/

foreach category in whit bkaa hisp aspi aian othe nral{
	rename `category' p`category'
}

reshape long p, i(var) j(race) string

gen no = .
replace no = 7 if race == "whit"
replace no = 6 if race == "bkaa"
replace no = 5 if race == "hisp"
replace no = 4 if race == "aspi"
replace no = 3 if race == "aian"
replace no = 2 if race == "othe"
replace no = 1 if race == "nral"

save "$wdata/bootstrap/Decomposition_Change_Group7_Main.dta", replace

**********************************************************************

forv i = 1(1)1000{
	if `i' == 1 {
		dis "Bootstrap (1,000)"
		dis "----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5"
	}
	_dots `i' 0
	qui{
	set seed `i'
	use "$wdata/bootstrap/Decomposition_Change_Group7_Temp.dta", clear
	bsample
	
	collapse (mean)fteD* isD* fteR* isR* [aw=weight]

	reshape long fteD1_ isD1_ fteR_ isR_, i(fteD0 fteD1 isD0 isD1 isR0 isR1) j(category) string

	rename fteD1_ D_Student
	rename isD1_ D_Faculty
	rename fteR_ R_Student
	rename isR_ R_Faculty

	gen con_D_Student = (D_Student - fteD0) // (fteD1 - fteD0)
	gen con_D_Faculty = (D_Faculty - isD0) // (isD1 - isD0)
	gen con_R_Student = (R_Student - isR0) // (isR1 - isR0)
	gen con_R_Faculty = (R_Faculty - isR0) // (isR1 - isR0)

	keep category con*

	tostring _all, replace force

	sxpose, clear firstnames destring

	gen var = ""
	replace var = "D_Student" in 1
	replace var = "D_Faculty" in 2
	replace var = "R_Student" in 3
	replace var = "R_Faculty" in 4

	order var

	foreach category in whit bkaa hisp aspi aian othe nral{
		rename `category' p`category'
	}

	reshape long p, i(var) j(race) string

	gen no = .
	replace no = 7 if race == "whit"
	replace no = 6 if race == "bkaa"
	replace no = 5 if race == "hisp"
	replace no = 4 if race == "aspi"
	replace no = 3 if race == "aian"
	replace no = 2 if race == "othe"
	replace no = 1 if race == "nral"

	gen sample = `i'

	save "$wdata/bootstrap/Decomposition_Change_Group7_Bsample`i'.dta", replace
	}
}

clear
forv i = 1(1)1000{
	ap using "$wdata/bootstrap/Decomposition_Change_Group7_Bsample`i'.dta"
}

collapse (sd)p, by(var race no)
rename p se
merge 1:1 var race no using "$wdata/bootstrap/Decomposition_Change_Group7_Main.dta"
drop _m

gen upper = p + 1.96 * se
gen lower = p - 1.96 * se
		
twoway 	(bar p no if var == "D_Faculty", hori barw(0.6) fc(gs10) lc(black)) ///
		(rcap upper lower no if var == "D_Faculty", hori color(black)), ///
		scheme(s1color) xtitle(Change in Faculty Diversity Index) xlabel(0(0.01)0.10, format(%4.2f)) ///
		ytitle(" ") ylabel(7 "White" 6 "Black" 5 "Hispanic" 4 "Asian & NHPI" 3 "AIAN" 2 "Unknown & 2 or More" 1 "NRA", angle(0) labsize(small)) ///
		xline(0, lc(black)) legend(off) xscale(ra(-.0022 .10))
graph export "$figure/FigA1a_Diversity.png", as(png) replace		
		
		
replace no = no+0.2 if var == "R_Faculty"
replace no = no-0.2 if var == "R_Student"

twoway 	(bar p no if var == "R_Faculty", hori barw(0.4) fc(gs5) lc(black)) ///
		(rcap upper lower no if var == "R_Faculty", hori color(black)) ///
		(bar p no if var == "R_Student", hori barw(0.4) fc(gs12) lc(black)) ///
		(rcap upper lower no if var == "R_Student", hori color(black)), ///
		scheme(s1color) xtitle(Change in Representation Index) xlabel(-0.06(0.01)0.03, format(%4.2f)) ///
		ytitle(" ") ylabel(7 "White" 6 "Black" 5 "Hispanic" 4 "Asian & NHPI" 3 "AIAN" 2 "Unknown & 2 or More" 1 "NRA", angle(0) labsize(small)) ///
		xline(0, lc(black)) legend(order(1 "Faculty" 3 "Student"))
graph export "$figure/FigA1b_Representation.png", as(png) replace		
