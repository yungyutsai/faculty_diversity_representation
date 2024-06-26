clear
set more off

use "$wdata/analysis/IPEDS_Balanced_Panel.dta", clear
keep if year == 2019

gen instype = ""
replace instype = "Public4-year" if control == 1 & iclevel == 4
replace instype = "Public2-year" if control == 1 & iclevel < 4
replace instype = "Private4-year" if control != 1 & iclevel == 4
replace instype = "Private2-year" if control != 1 & iclevel < 4

keep unitid instype
duplicates drop

expand 40
bysort unitid: gen year = 2000 + _n

merge 1:1 unitid year using "$wdata/analysis/IPEDS_Balanced_Panel.dta"
drop if _m == 2

sort unitid year

keep unitid year instnm iclevel control instype carnegie carnegie_newest fttotl ftwhit ftbkaa fthisp ftasia ftnhpi ftaian ft2mor ftunkn ftnral pttotl ptwhit ptbkaa pthisp ptasia ptnhpi ptaian pt2mor ptunkn ptnral nhistotl nhtetotl nhntetotl propfte*

merge m:1 year instype using "$wdata/intermediate/Enrollment_Projection_Final.dta"
drop if _m == 2
drop _m
merge m:1 year using "$wdata/intermediate/Enrollment_Projection_Racial_Final.dta"
drop if _m == 2
drop _m

sort unitid year
encode instype, gen(inscd)

replace projenrft = projenrft_hat if projenrft == .
replace projenrpt = projenrpt_hat if projenrpt == .

reghdfe fttotl c.projenrft#i.inscd, a(unitid)
reghdfe pttotl c.projenrpt#i.inscd, a(unitid)

foreach y in ft pt{
	qui gen `y'_hat = .
	foreach x in Public4-year Public2-year Private4-year Private2-year{
		dis "Projection for: `x' `y'"
		reghdfe `y'totl projenr`y' if instype == "`x'" & year <= 2019, a(unitid, savefe)
		qui predict yhat
		qui by unitid: replace __hdfe1__ = __hdfe1__[_n-1] if __hdfe1__ == .
		qui replace `y'_hat = yhat + __hdfe1__ if instype == "`x'"
		drop yhat __hdfe1__
		replace `y'_hat = 0 if `y'_hat < 0
	}
}

replace fttotl = ft_hat if fttotl == .
replace pttotl = pt_hat if pttotl == .

gen post = year >= 2016
egen unitid_post = group(unitid post)

reghdfe nhtetotl c.fttotl#i.inscd c.pttotl#i.inscd year, a(unitid_post)
reghdfe nhntetotl c.fttotl#i.inscd c.pttotl#i.inscd year, a(unitid_post)

foreach y in te nte{
	qui gen nh`y'_hat = .
	foreach x in Public4-year Public2-year Private4-year Private2-year{
		dis "Projection for: `x' `y'"
		reghdfe nh`y'totl fttotl pttotl year if instype == "`x'" & year <= 2019, a(unitid_post, savefe)
		qui predict yhat
		qui by unitid: replace __hdfe1__ = __hdfe1__[_n-1] if __hdfe1__ == .
		qui replace nh`y'_hat = yhat + __hdfe1__ if instype == "`x'"
		drop yhat __hdfe1__
		replace nh`y'_hat = 0 if nh`y'_hat < 0
	}
}

rename propfte2mor propftetmor
foreach x in whit bkaa hisp asia nhpi aian tmor{
	dis "Projection for: `x'"
	reghdfe propfte`x' `x'hat if year <= 2019, a(unitid, savefe)
	qui predict propfte`x'_hat
	qui by unitid: replace __hdfe1__ = __hdfe1__[_n-1] if __hdfe1__ == .
	qui replace propfte`x'_hat = propfte`x'_hat + __hdfe1__
	drop __hdfe1__
	replace propfte`x'_hat = 0 if propfte`x'_hat < 0
	replace propfte`x'_hat = 1 if propfte`x'_hat > 1 & propfte`x'_hat !=.
}
foreach x in unkn nral{
	dis "Projection for: `x'"
	reghdfe propfte`x' c.year#i.inscd if year <= 2019, a(unitid, savefe)
	qui predict propfte`x'_hat
	qui by unitid: replace __hdfe1__ = __hdfe1__[_n-1] if __hdfe1__ == .
	qui replace propfte`x'_hat = propfte`x'_hat + __hdfe1__
	drop __hdfe1__
	replace propfte`x'_hat = 0 if propfte`x'_hat < 0
	replace propfte`x'_hat = 1 if propfte`x'_hat > 1 & propfte`x'_hat !=.
}

save "$wdata/intermediate/Hiring_Projection.dta", replace
