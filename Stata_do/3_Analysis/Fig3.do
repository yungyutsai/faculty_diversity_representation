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
merge 1:1 unitid year using "$wdata/analysis/IPEDS_Balanced_Panel.dta"
drop if _m == 2
drop _m

foreach x of varlist is_D9_*{
	replace `x' = is_D9 if year == 2021
}
foreach x of varlist is_R9_* is_R9v2_*{
	replace `x' = is_R9 if year == 2021
}
foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral { //bkaa hisp asia nhpi aian 2mor unkn nral
	foreach x of varlist propis`category'_*{
		replace `x' = propis`category' if year == 2021
	}
}

collapse (mean)*D9* *R9* propis* [aw=weight], by(year)

keep if inrange(year,2021,2035)



foreach x in b hd hr rd rr{
	sum is_D9_`x' if year == 2035
	loc pos`x' = r(mean)
}

twoway 	(line is_D9_b year if year >= 2021, lc(gs10) lp(shortdash)) ///
		(line is_D9_hd year if year >= 2021, lc(gs8)) ///
		(line is_D9_hr year if year >= 2021, lc(gs8) lp(longdash)) ///
		(line is_D9_rd year if year >= 2021, lc(black)) ///
		(line is_D9_rr year if year >= 2021, lc(black) lp(longdash)), ///
		legend(off) scheme(s1color) ///
		xlabel(2021(1)2035, angle(30)) xscale(ra(2021 2040)) xtitle(Year) ///
		ylabel(0.48(0.02)0.62, angle(0) format(%4.2f)) ///
		yscale(ra(0.49 0.62)) ytitle(Diversity Index)	///
		text(`posb' 2035.2 "Baseline Prediction", size(vsmall) place(e) just(left) color(gs10)) ///
		text(`poshd' 2035.2 "Diversity Hiring", size(vsmall) place(e) just(left) color(gs8)) ///
		text(`poshr' 2035.2 "Representation Hiring", size(vsmall) place(e) just(left) color(gs8)) ///
		text(`posrd' 2035.2 "Diversity Hiring + Retention", size(vsmall) place(e) just(left) color(black)) ///
		text(`posrr' 2035.2 "Representation Hiring + Retention", size(vsmall) place(e) just(left) color(black))
graph export "$figure/Fig3a_Diversity.png", as(png) replace


foreach x in b hd hr rd rr{
	sum is_R9_`x' if year == 2035
	loc pos`x' = r(mean)
}

twoway 	(line is_R9_b year if year >= 2021, lc(gs10) lp(shortdash)) ///
		(line is_R9_hd year if year >= 2021, lc(gs8)) ///
		(line is_R9_hr year if year >= 2021, lc(gs8) lp(longdash)) ///
		(line is_R9_rd year if year >= 2021, lc(black)) ///
		(line is_R9_rr year if year >= 2021, lc(black) lp(longdash)), ///
		legend(off) scheme(s1color) ///
		xlabel(2021(1)2035, angle(30)) xscale(ra(2021 2040)) xtitle(Year) ///
		ylabel(0.73(0.01)0.81, angle(0) format(%4.2f)) ///
		yscale(ra(0.73 0.81)) ytitle(Representation Index)	///
		text(`posb' 2035.2 "Baseline Prediction", size(vsmall) place(e) just(left) color(gs10)) ///
		text(`poshd' 2035.2 "Diversity Hiring", size(vsmall) place(e) just(left) color(gs8)) ///
		text(`poshr' 2035.2 "Representation Hiring", size(vsmall) place(e) just(left) color(gs8)) ///
		text(`posrd' 2035.2 "Diversity Hiring + Retention", size(vsmall) place(e) just(left) color(black)) ///
		text(`posrr' 2035.2 "Representation Hiring + Retention", size(vsmall) place(e) just(left) color(black))		
graph export "$figure/Fig3b_Representation.png", as(png) replace
