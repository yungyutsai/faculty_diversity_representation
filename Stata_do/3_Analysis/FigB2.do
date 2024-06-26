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

sum whithat if year == 2035
loc p1 = r(mean)
sum bkaahat if year == 2035
loc p2 = r(mean)
sum hisphat if year == 2035
loc p3 = r(mean)
sum asiahat if year == 2035
loc p4 = r(mean)
		
twoway 	(line whithat year if year >= 2028, lc(black) lp(shortdash)) ///
		(line whithat year if year <= 2028, lc(black) lp(longdash)) ///
		(line whit year if year <= 2016, lc(black)) ///
		(line bkaahat year if year >= 2028, lc(gs6) lp(shortdash)) ///
		(line bkaahat year if year <= 2028, lc(gs6) lp(longdash)) ///
		(line bkaa year if year <= 2016, lc(gs6)) ///
		(line hisphat year if year >= 2028, lc(gs8) lp(shortdash)) ///
		(line hisphat year if year <= 2028, lc(gs8) lp(longdash)) ///
		(line hisp year if year <= 2016, lc(gs8)) ///
		(line asiahat year if year >= 2028, lc(gs10) lp(shortdash)) ///
		(line asiahat year if year <= 2028, lc(gs10) lp(longdash)) ///
		(line asia year if year <= 2016, lc(gs10)) ///
		(line nhpihat year if year >= 2028, lc(gs12) lp(shortdash)) ///
		(line nhpihat year if year <= 2028, lc(gs12) lp(longdash)) ///
		(line nhpi year if year <= 2016 & year >= 2010, lc(gs12)) ///
		(line aianhat year if year >= 2028, lc(gs14) lp(shortdash)) ///
		(line aianhat year if year <= 2028, lc(gs14) lp(longdash)) ///
		(line aian year if year <= 2016, lc(gs14)) ///
		(line tmorhat year if year >= 2028, lc(gs14) lp(shortdash)) ///
		(line tmorhat year if year <= 2028, lc(gs14) lp(longdash)) ///
		(line tmor year if year <= 2016, lc(gs14)), ///
		scheme(s1color) ///
		legend(col(3) order(3 "Actual Data" 2 "NCES Projection" 1 "This Paper's Projection") ///
		symx(9) size(small)) ///
		ylabel(0(0.1)0.7, angle(0) format(%4.2f)) ytitle(Proportion) yscale(ra(-0.01 0.7)) ///
		xtitle(Year) xlabel(2000(5)2035) xscale(ra(2000 2040)) ///
		text(`p1' 2035.5 "White", place(e) size(small)) ///
		text(`p2' 2035.5 "Black", place(e) size(small)) ///
		text(`p3' 2035.5 "Hispanic", place(e) size(small)) ///
		text(`p4' 2035.5 "Asia", place(e) size(small)) ///
		text(.043 2035.5 "2 or More", place(e) size(small)) ///
		text(-.01 2035.5 "NHPI", place(e) size(small)) ///
		text(.02 2035.5 "AIAN", place(e) size(small)) 
graph export "$figure/FigB2.png", as(png) replace		
