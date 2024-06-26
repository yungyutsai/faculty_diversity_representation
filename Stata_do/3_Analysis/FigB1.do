clear
set more off

use "$wdata/intermediate/Enrollment_Projection_Final.dta", replace

foreach x in projenr projenrft projenrpt projenrfte{
	foreach y in "" "_hat"{
		replace `x'`y' = `x'`y' / 1000000
	}
}

sort instype year

keep if year <= 2035
sum projenrfte_hat if instype == "Private2-year" & year == 2035
loc p1 = r(mean)
sum projenrfte_hat if instype == "Private4-year" & year == 2035
loc p2 = r(mean)
sum projenrfte_hat if instype == "Public2-year" & year == 2035
loc p3 = r(mean)
sum projenrfte_hat if instype == "Public4-year" & year == 2035
loc p4 = r(mean)

twoway	(line projenrfte_hat year if instype == "Public4-year" & year >= 2028, lc(black) lp(shortdash)) ///
		(line projenrfte year if instype == "Public4-year" & year <= 2028, lc(black) lp(longdash)) ///
		(line projenrfte year if instype == "Public4-year" & year <= 2016, lc(black)) ///
		(line projenrfte_hat year if instype == "Public2-year" & year >= 2028, lc(gs6)lp(shortdash)) ///
		(line projenrfte year if instype == "Public2-year" & year <= 2028, lc(gs6) lp(longdash)) ///
		(line projenrfte year if instype == "Public2-year" & year <= 2016, lc(gs6)) ///
		(line projenrfte_hat year if instype == "Private4-year" & year >= 2028, lc(gs9)lp(shortdash)) ///
		(line projenrfte year if instype == "Private4-year" & year <= 2028, lc(gs9) lp(longdash)) ///
		(line projenrfte year if instype == "Private4-year" & year <= 2016, lc(gs9)) ///
		(line projenrfte_hat year if instype == "Private2-year" & year >= 2028, lc(gs12)lp(shortdash)) ///
		(line projenrfte year if instype == "Private2-year" & year <= 2028, lc(gs12) lp(longdash)) ///
		(line projenrfte year if instype == "Private2-year" & year <= 2016, lc(gs12)), ///
		legend(col(3) order(3 "Actual Data" 2 "NCES Projection" 1 "This Paper's Projection") ///
		symx(9) size(small)) ///
		ylabel(0(1)8, angle(0)) xlabel(2000(5)2035) xscale(ra(2000 2040.5)) ///
		scheme(s1color) ytitle(Full-time Equivalent Enrollment (Million)) xtitle(Year) ///
		text(`p1' 2035.2 "Private 2-year", place(e) size(small)) ///
		text(`p2' 2035.2 "Private 4-year", place(e) size(small)) ///
		text(`p3' 2035.2 "Public 2-year", place(e) size(small)) ///
		text(`p4' 2035.2 "Public 4-year", place(e) size(small)) 
graph export "$figure/FigB1b.png", as(png) replace		

collapse (sum)projenr*, by(year)

foreach x in projenr projenrft projenrpt projenrfte{
	foreach y in "" "_hat"{
		recode `x'`y'  0 = .
	}
}

keep if year <= 2035
sum projenr_hat if year == 2035
loc p1 = r(mean)
sum projenrfte_hat if year == 2035
loc p2 = r(mean)
sum projenrft_hat if year == 2035
loc p3 = r(mean)
sum projenrpt_hat if year == 2035
loc p4 = r(mean)

twoway	(line projenr_hat year if year >= 2028, lc(black) lp(shortdash)) ///
		(line projenr year if year <= 2028, lc(black) lp(longdash)) ///
		(line projenr year if year <= 2016, lc(black)) ///
		(line projenrfte_hat year if year >= 2028, lc(gs6) lp(shortdash)) ///
		(line projenrfte year if year <= 2028, lc(gs6) lp(longdash)) ///
		(line projenrfte year if year <= 2016, lc(gs6)) ///
		(line projenrft_hat year if year >= 2028, lc(gs9) lp(shortdash)) ///
		(line projenrft year if year <= 2028, lc(gs9) lp(longdash)) ///
		(line projenrft year if year <= 2016, lc(gs9)) ///
		(line projenrpt_hat year if year >= 2028, lc(gs12) lp(shortdash)) ///
		(line projenrpt year if year <= 2028, lc(gs12) lp(longdash)) ///
		(line projenrpt year if year <= 2016, lc(gs12)), ///
		legend(col(3) order(3 "Actual Data" 2 "NCES Projection" 1 "This Paper's Projection") ///
		symx(9) size(small)) ///
		ylabel(6(2)22, angle(0)) xlabel(2000(5)2035) xscale(ra(2000 2040.5)) ///
		scheme(s1color) ytitle(Enrollment (Million)) xtitle(Year) ///
		text(`p1' 2036 "Total" "Enrollment", place(e) size(small) just(left)) ///
		text(`p2' 2036 "Full-time" "Equivalent" "Enrollment", place(e) size(small) just(left)) ///
		text(`p3' 2036 "Full-time" "Enrollment", place(e) size(small) just(left)) ///
		text(`p4' 2036 "Part-time" "Enrollment", place(e) size(small) just(left)) 
graph export "$figure/FigB1a.png", as(png) replace
