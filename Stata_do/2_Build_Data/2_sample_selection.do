clear
set more off

use "$wdata/analysis/IPEDS_Merged_All_Imputed.dta", clear

keep if totmenroll == 0 //Always have student data
keep if totmfaculty == 0 //Always have faculty data
//drop if carnegie_newest == 6

foreach category in totl whit bkaa hisp asia nhpi aspi aian 2mor unkn othe nral{
	recode te`category' . = 0
	gen nte`category' = is`category' - te`category'
	gen nhnte`category' = nhis`category' - nhte`category'
}

** Calculate composition (make % sum up as 100%)
foreach var in ft pt fte tot is te nte{
	dis "Adjust for `var'..."
	replace `var'totl = `var'whit + `var'bkaa + `var'hisp + `var'aspi + `var'aian + `var'othe + `var'nral
	
	foreach category in whit bkaa hisp asia nhpi aspi aian 2mor unkn othe nral{
		dis "--Calculate proportion for `category'..."
		gen prop`var'`category' = `var'`category' / `var'totl
	}
	
	dis "--Compute Diversity Index"
	gen `var'_D7 = (1-(prop`var'whit^2 + prop`var'bkaa^2 + prop`var'hisp^2 + prop`var'aspi^2 + prop`var'aian^2 + prop`var'othe^2 + prop`var'nral^2))/6*7
	replace `var'_D7 = 1 if `var'_D7 > 1 & `var'_D7 ~= .
	
	gen `var'_D9 = (1-(prop`var'whit^2 + prop`var'bkaa^2 + prop`var'hisp^2 + prop`var'asia^2 + prop`var'nhpi^2 + prop`var'aian^2 + prop`var'2mor^2 + prop`var'unkn^2 + prop`var'nral^2))/8*9
	replace `var'_D9 = 1 if `var'_D9 > 1 & `var'_D9 ~= .
}

dis "Compute Representative Index"
foreach var in is te nte{
	dis "--For `var'..."
	
	gen `var'_R7 = 	1 - sqrt( ( ///
					(prop`var'whit - propftewhit)^2 + ///
					(prop`var'bkaa - propftebkaa)^2 + ///
					(prop`var'hisp - propftehisp)^2 + ///
					(prop`var'aspi - propfteaspi)^2 + ///
					(prop`var'aian - propfteaian)^2 + ///
					(prop`var'othe - propfteothe)^2 + ///
					(prop`var'nral - propftenral)^2 ) / 2 )
					
	replace `var'_R7 = 1 if `var'_R7 > 1 & `var'_R7 ~= .
	replace `var'_R7 = 0 if `var'_R7 < 0 & `var'_R7 ~= .
	
	
	gen `var'_R9 = 	1 - sqrt( ( ///
					(prop`var'whit - propftewhit)^2 + ///
					(prop`var'bkaa - propftebkaa)^2 + ///
					(prop`var'hisp - propftehisp)^2 + ///
					(prop`var'asia - propfteasia)^2 + ///
					(prop`var'nhpi - propftenhpi)^2 + ///
					(prop`var'aian - propfteaian)^2 + ///
					(prop`var'2mor - propfte2mor)^2 + ///
					(prop`var'unkn - propfteunkn)^2 + ///
					(prop`var'nral - propftenral)^2 ) / 2 )
					
	replace `var'_R9 = 1 if `var'_R9 > 1 & `var'_R9 ~= .
	replace `var'_R9 = 0 if `var'_R9 < 0 & `var'_R9 ~= .
	replace `var'_R9 = . if year < 2010
}
		 
** Save Data File
compress
save "$wdata/analysis/IPEDS_Balanced_Panel.dta", replace
