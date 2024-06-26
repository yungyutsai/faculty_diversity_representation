clear
set more off

use "$wdata/analysis/IPEDS_Balanced_Panel.dta", clear

gen v1 = ftetotl if year == 2001
egen weight = mean(v1), by(unitid)


sort unitid year

*****************

collapse (mean)fte_D7 fte_D9 is_D7 is_D9 is_R7 is_R9 [aweight=weight], by(year)
	
sort year	



twoway 	(line fte_D7 year, lc(navy)) ///
		(line fte_D9 year if year > 2009, lc(maroon) lp(dash)), ///
		xlabel(2001(2)2021) ///
		ylabel(,angle(0) format(%4.2f)) scheme(s1color) ///
		ytitle("Student Diversity Index") xtitle(Year) ///
		legend(order(1 "Based on 7-bin Scale" 2 "Based on 9-bin Scale") size(small))
graph export "$figure/FigC1.png", replace

*****************

use "$wdata/analysis/IPEDS_Balanced_Panel.dta", clear

gen v1 = ftetotl if year == 2001
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

*****************

collapse (mean)fte_D7 fte_D9 is_D7 is_D9 is_R7 is_R9 [aweight=weight], by(institution year)
	
sort institution year	

foreach var in fte_D7{
	forv i = 1(1)6{
		sum `var' if year == 2021 & institution == `i'
		local loc`i' = r(mean)
	}
	
	if "`var'" == "fte_D7"{
		loc ytitle = "Student Diversity Index"
		loc name = "StudentDiversity"
	}
	if "`var'" == "is_D7"{
		loc ytitle = "Faculty Diversity Index"
		loc name = "Diversity"
	}
	if "`var'" == "is_R7"{
		loc ytitle = "Representation Index"
		loc name = "Representation"
	}
	
	if "`var'" == "fte_D7"{
		local loc6 = `loc6' + 0.005
	}
	if "`var'" == "is_D7"{
		local loc2 = `loc2' + 0.005
	}
	if "`var'" == "is_D7"{
		local loc4 = `loc4' - 0.005
	}
	if "`var'" == "is_R7"{
		local loc5 = `loc5' + 0.005
	}
		
	twoway 	(line `var' year if institution == 1, lw(medthick) lc(black)) ///
			(line `var' year if institution == 2, lw(medthick) lp(longdash) lc(gs2)) ///
			(line `var' year if institution == 3, lw(medthick) lp(shortdash) lc(gs4)) ///
			(line `var' year if institution == 4, lw(vthin) lc(gs6)) ///
			(line `var' year if institution == 5, lw(vthin) lp(longdash) lc(gs8)) ///
			(line `var' year if institution == 6, lw(vthin) lp(shortdash) lc(gs8)), ///
			legend(off) xscale(ra(2001 2027)) xlabel(2001(2)2021) ///
			ylabel(0.35(0.05)0.7,angle(0) format(%4.2f)) scheme(s1color) ///
			ytitle("`ytitle'") xtitle(Year) ///
			text(`loc1' 2021.25 "Public 4-year", place(e) size(small) color(black)) ///
			text(`loc2' 2021.25 "Non-profit 4-year", place(e) size(small) color(gs2)) ///
			text(`loc3' 2021.25 "For-profit 4-year", place(e) size(small) color(gs4)) ///
			text(`loc4' 2021.25 "Public 2-year", place(e) size(small) color(gs6)) ///
			text(`loc5' 2021.25 "Non-profit 2-year", place(e) size(small) color(gs8)) ///
			text(`loc6' 2021.25 "For-profit 2-year", place(e) size(small) color(gs8))
			
	graph export "$figure/FigC1b_`name'_byTypes.png", replace
}
