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

keep if year == 2035

keep unitid weight year propfte* propis* is_D9* is_R9*

drop propftewhit propftebkaa propftehisp propfteasia propftenhpi propfteaspi propfteaian propfte2mor propfteunkn propfteothe propftenral propiswhit propisbkaa propishisp propisasia propisnhpi propisaspi propisaian propis2mor propisunkn propisothe propisnral propftetmor *v2* is_D9 is_R9
rename propftetmor_hat propfte2mor_hat

foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral { 
	foreach senario in b hd rd hr rr{
		rename propis`category'_`senario'50 propis`category'_`senario'
	}
}

foreach senario in b hd rd hr rr{
	rename is_R9_`senario'50 R_`senario'
	rename is_D9_`senario'50 D_`senario'
}

cap gen totprop0 = .
cap gen totprop1 = .

foreach senario in hd rd hr rr{
	foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral{
		cap gen propis`category' = .

		replace propis`category' = propis`category'_`senario'
		replace totprop1 = 1 - propis`category'_`senario'
		replace totprop0 = 0
		
		foreach category2 in whit bkaa hisp asia nhpi aian 2mor unkn nral{
			if "`category2'" != "`category'"{
				replace totprop0 = totprop0 + propis`category2'_b
			}
		}
		foreach category2 in whit bkaa hisp asia nhpi aian 2mor unkn nral{
			if "`category2'" != "`category'"{
				cap gen propis`category2' = .
				replace propis`category2' = propis`category2'_b / totprop0 * totprop1
			}
		}
		gen D_`senario'_`category' = (1-(propiswhit^2 + propisbkaa^2 + propishisp^2 + propisasia^2 + propisnhpi^2 + propisaian^2 + propis2mor^2 + propisunkn^2 + propisnral^2))/8*9
		replace D_`senario'_`category' = 1 if D_`senario'_`category' > 1 & D_`senario'_`category' ~= .
				
		gen R_`senario'_`category' = 1 - sqrt( ( ///
						(propiswhit - propftewhit)^2 + ///
						(propisbkaa - propftebkaa)^2 + ///
						(propishisp - propftehisp)^2 + ///
						(propisasia - propfteasia)^2 + ///
						(propisnhpi - propftenhpi)^2 + ///
						(propisaian - propfteaian)^2 + ///
						(propis2mor - propfte2mor)^2 + ///
						(propisunkn - propfteunkn)^2 + ///
						(propisnral - propftenral)^2 ) / 2 )
						
		replace R_`senario'_`category' = 1 if R_`senario'_`category' > 1 & R_`senario'_`category' ~= .
		replace R_`senario'_`category' = 0 if R_`senario'_`category' < 0 & R_`senario'_`category' ~= .
	}
}

save  "$wdata/bootstrap/Decomposition_Senario_Temp.dta", replace

collapse (mean)D* R* [aw=weight]

gen id = 1
reshape long D_ R_, i(id) j(var) string

rename D_ D
rename R_ R

gen senario = substr(var,1,3)
gen category = substr(var,strpos(var,"_")+1,.) if strpos(var,"_")!=0

gen v1 = D if var == "b"
egen Db = mean(v1)
drop v1
gen v1 = R if var == "b"
egen Rb = mean(v1)
drop v1

drop if category == ""

gen D_Con = (D-Db) 
gen R_Con = (R-Rb) 

keep category senario D_Con R_Con
rename category race

gen no = .
replace no = 9 if race == "whit"
replace no = 8 if race == "bkaa"
replace no = 7 if race == "hisp"
replace no = 6 if race == "asia"
replace no = 5 if race == "nhpi"
replace no = 4 if race == "aian"
replace no = 3 if race == "2mor"
replace no = 2 if race == "unkn"
replace no = 1 if race == "nral"

save  "$wdata/bootstrap/Decomposition_Senario_Main.dta", replace


**********************************************************************

forv i = 1(1)1000{
	if `i' == 1 {
		dis "Bootstrap (1,000)"
		dis "----+--- 1 ---+--- 2 ---+--- 3 ---+--- 4 ---+--- 5"
	}
	_dots `i' 0
	qui{
	set seed `i'
	use "$wdata/bootstrap/Decomposition_Senario_Temp.dta", clear
	bsample
	
	collapse (mean)D* R* [aw=weight]

	gen id = 1
	reshape long D_ R_, i(id) j(var) string

	rename D_ D
	rename R_ R

	gen senario = substr(var,1,3)
	gen category = substr(var,strpos(var,"_")+1,.) if strpos(var,"_")!=0

	gen v1 = D if var == "b"
	egen Db = mean(v1)
	drop v1
	gen v1 = R if var == "b"
	egen Rb = mean(v1)
	drop v1

	drop if category == ""

	gen D_Con = (D-Db) 
	gen R_Con = (R-Rb) 

	keep category senario D_Con R_Con
	rename category race

	gen no = .
	replace no = 9 if race == "whit"
	replace no = 8 if race == "bkaa"
	replace no = 7 if race == "hisp"
	replace no = 6 if race == "asia"
	replace no = 5 if race == "nhpi"
	replace no = 4 if race == "aian"
	replace no = 3 if race == "2mor"
	replace no = 2 if race == "unkn"
	replace no = 1 if race == "nral"

	gen sample = `i'

	save "$wdata/bootstrap/Decomposition_Senario_Bsample`i'.dta", replace
	}
}

clear
forv i = 1(1)1000{
	ap using "$wdata/bootstrap/Decomposition_Senario_Bsample`i'.dta"
}

collapse (sd)D_Con R_Con, by(senario race no)
rename D_Con D_se
rename R_Con R_se
merge 1:1 senario race no using "$wdata/bootstrap/Decomposition_Senario_Main.dta"
drop _m

rename D_Con D_b
rename R_Con R_b

gen D_upper = D_b + 1.96 * D_se
gen D_lower = D_b - 1.96 * D_se
gen R_upper = R_b + 1.96 * R_se
gen R_lower = R_b - 1.96 * R_se

replace senario = substr(senario,1,2)
replace no = no+0.3 if senario == "hd"
replace no = no+0.1 if senario == "rd"
replace no = no-0.1 if senario == "hr"
replace no = no-0.3 if senario == "rr"


twoway 	(bar D_b no if senario == "hd", hori barw(0.2) fc(gs3) lc(gs1))  ///
		(rcap D_upper D_lower no if senario == "hd", hori color(gs1) lw(thin) msiz(small)) ///
		(bar D_b no if senario == "rd", hori barw(0.2) fc(gs6) lc(gs4))  ///
		(rcap D_upper D_lower no if senario == "rd", hori color(gs4) lw(thin) msiz(small)) ///
		(bar D_b no if senario == "hr", hori barw(0.2) fc(gs9) lc(gs7))  ///
		(rcap D_upper D_lower no if senario == "hr", hori color(gs7) lw(thin) msiz(small)) ///
		(bar D_b no if senario == "rr", hori barw(0.2) fc(gs12) lc(gs10))  ///
		(rcap D_upper D_lower no if senario == "rr", hori color(gs10) lw(thin) msiz(small)), ///
		scheme(s1color) xtitle(Change in Diversity Index Compared to Baseline) xlabel(0(0.02)0.1, format(%4.2f)) ///
		ytitle(" ") ylabel(9 "White" 8 "Black" 7 "Hispanic" 6 "Asian" 5 "NHPI" 4 "AIAN" 3 "2 or More" 2 "Unknown" 1 "NRA", angle(0) labsize(small)) ///
		xline(0, lc(black)) legend(col(1) order(1 "Diversity Hiring" 3 "Diversity Hiring + Retention" 5 "Representation Hiring" 7 "Representation Hiring + Retention") size(small) ring(0) pos(5) symx(6) title(Hiring Scenario, size(small)))
graph export "$figure/FigA3a_Diversity.png", as(png) replace		


twoway 	(bar R_b no if senario == "hd", hori barw(0.2) fc(gs3) lc(gs1))  ///
		(rcap R_upper R_lower no if senario == "hd", hori color(gs1) lw(thin) msiz(small)) ///
		(bar R_b no if senario == "rd", hori barw(0.2) fc(gs6) lc(gs4))  ///
		(rcap R_upper R_lower no if senario == "rd", hori color(gs4) lw(thin) msiz(small)) ///
		(bar R_b no if senario == "hr", hori barw(0.2) fc(gs9) lc(gs7))  ///
		(rcap R_upper R_lower no if senario == "hr", hori color(gs7) lw(thin) msiz(small)) ///
		(bar R_b no if senario == "rr", hori barw(0.2) fc(gs12) lc(gs10))  ///
		(rcap R_upper R_lower no if senario == "rr", hori color(gs10) lw(thin) msiz(small)), ///
		scheme(s1color) xtitle(Change in Representation Index Compared to Baseline) xlabel(0(0.01)0.04, format(%4.3f)) ///
		ytitle(" ") ylabel(9 "White" 8 "Black" 7 "Hispanic" 6 "Asian" 5 "NHPI" 4 "AIAN" 3 "2 or More" 2 "Unknown" 1 "NRA", angle(0) labsize(small)) ///
		xline(0, lc(black)) legend(col(1) order(1 "Diversity Hiring" 3 "Diversity Hiring + Retention" 5 "Representation Hiring" 7 "Representation Hiring + Retention") size(small) ring(0) pos(5) symx(6) title(Hiring Scenario, size(small)))
graph export "$figure/FigA3b_Representation.png", as(png) replace		
