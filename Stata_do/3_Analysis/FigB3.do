clear
set more off

use "$wdata/analysis/IPEDS_Balanced_Panel.dta", clear

keep if year == 2001
gen v1 = ftetotl
egen weight = mean(v1), by(unitid)

keep unitid instnm weight
duplicates drop

merge 1:m unitid using "$wdata/intermediate/Hiring_Projection.dta"
keep if _m == 3

collapse (sum) nhtetotl nhntetotl nhte_hat nhnte_hat, by(year)

drop if year > 2035

foreach x in nhtetotl nhntetotl nhte_hat nhnte_hat{
	recode `x' 0 = .
	replace `x' = `x' / 1000
}

twoway 	(line nhtetotl yea if year <= 2015, lc(navy*0.5) lw(medthick)) ///
		(line nhte_hat year if year <= 2015, lc(navy) lp(dash)) ///
		(line nhntetotl year if year <= 2015, lc(maroon*0.5) lw(medthick)) ///
		(line nhnte_hat year if year <= 2015, lc(maroon) lp(dash)) ///
		(line nhtetotl yea if year >= 2016, lc(navy*0.5) lw(medthick)) ///
		(line nhte_hat year if year >= 2016, lc(navy) lp(dash)) ///
		(line nhntetotl year if year >= 2016, lc(maroon*0.5) lw(medthick)) ///
		(line nhnte_hat year if year >= 2016, lc(maroon) lp(dash)), ///
		scheme(s1color) ///
		legend(col(4) symx(8) size(small) ///
		order(1 "TTT (Actual)" 2 "TTT (Predicted)" 3 "NTT (Actual)" 4 "NTT (Predicted)")) ///
		ylabel(10(10)50, angle(0)) ytitle(Total New Hired (Thousand)) ///
		xtitle(Year) xlabel(2000(5)2035)
graph export "$figure/FigB3.png", as(png) replace		
