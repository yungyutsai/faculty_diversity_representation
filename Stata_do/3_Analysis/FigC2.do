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

gen year = 2035
	
forv r = 1.05(0.05)2.05{
	loc p: dis %4.2f `r'
	loc p = substr("`p'",-2,2)
	merge 1:1 unitid year using "$wdata/analysis/simulation/IPEDS_Prediction_Scenario_v`p'.dta"
	keep if _m == 3
	drop _m
}

collapse (mean)*D9* *R9* [aw=weight], by(year)
drop *R9v2*

reshape long 	is_D9_b is_D9_hd is_D9_rd is_D9_hr is_D9_rr ///
				is_R9_b is_R9_hd is_R9_rd is_R9_hr is_R9_rr ///
				, i(year) j(r) string

replace r = "100" if r == "00"

destring r, replace
sort r


foreach x in b hd rd hr rr{
	sum is_D9_`x' if r == 100
	loc pos`x' = r(mean)
}
loc posb1 = `posb' + 0.0015

twoway 	(line is_D9_hd r, lc(gs8)) ///
		(line is_D9_rd r, lc(black)) ///
		(line is_D9_hr r, lc(gs8) lp(longdash)) ///
		(line is_D9_rr r, lc(black) lp(longdash)), ///
		legend(off) scheme(s1color) yline(`posb', lc(black) lp(shortdash)) ///
		xlabel(10(10)100, format(%4.0f)) xtitle(% Increase in Hiring/Retention) ///
		ylabel(0.5(0.03)0.74, angle(0) format(%4.2f)) ytitle(Diversity Index) ///
		xscale(ra(4 133)) ///
		text(`posb1' 130 "Baseline Prediction", place(11) size(vsmall) just(right)) ///
		text(`poshd' 101.5 "Diversity Hiring", size(vsmall) place(e) just(left) color(black)) ///
		text(`posrd' 101.5 "Diversity Hiring + Retention", size(vsmall) place(e) just(left) color(black)) ///
		text(`poshr' 101.5 "Representation Hiring", size(vsmall) place(e) just(left) color(gs8)) ///
		text(`posrr' 101.5 "Representation Hiring + Retention", size(vsmall) place(e) just(left) color(gs8))
graph export "$figure/FigC2a_Diversity.png", as(png) replace



foreach x in b hd rd hr rr{
	sum is_R9_`x' if r == 100
	loc pos`x' = r(mean)
}
loc posb1 = `posb' + 0.0005


twoway 	(line is_R9_hd r, lc(gs8)) ///
		(line is_R9_rd r, lc(black)) ///
		(line is_R9_hr r, lc(gs8) lp(longdash)) ///
		(line is_R9_rr r, lc(black) lp(longdash)), ///
		legend(off) scheme(s1color) yline(`posb', lc(black) lp(shortdash)) ///
		xlabel(10(10)100, format(%4.0f)) xtitle(% Increase in Hiring/Retention) ///
		ylabel(0.73(0.02)0.85, angle(0) format(%4.2f)) ytitle(Representation Index) ///
		xscale(ra(4 133)) ///
		text(`posb1' 130 "Baseline Prediction", place(11) size(vsmall) just(right)) ///
		text(`poshd' 101.5 "Diversity Hiring", size(vsmall) place(e) just(left) color(black)) ///
		text(`posrd' 101.5 "Diversity Hiring + Retention", size(vsmall) place(e) just(left) color(black)) ///
		text(`poshr' 101.5 "Representation Hiring", size(vsmall) place(e) just(left) color(gs8)) ///
		text(`posrr' 101.5 "Representation Hiring + Retention", size(vsmall) place(e) just(left) color(gs8))
graph export "$figure/FigC2b_Representation.png", as(png) replace
