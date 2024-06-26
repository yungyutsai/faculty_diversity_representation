clear
set more off

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

merge 1:1 unitid year using "$wdata/analysis/IPEDS_TTEData_for_Simulation.dta"
drop if _m == 2
drop _m

*****************

lab de institution 1 "Public 4-year" 2 "Non-profit 4-year" 3 "For-profit 4-year" 4 "Public 2-year" 5 "Non-profit 2-year" 6 "For-profit 2-year"
lab val institution institution

lab var ftetotl "Total Student Enrollment (FTE)"
lab var istotl "Total Instructional Staff"

foreach x in avgnhis avgnhris avglvis avglvris{
	cap lab var `x'totl "All Racial/Ethnic Groups"
	lab var `x'whit "White"
	lab var `x'bkaa "Black and African American"
	lab var `x'hisp "Hispanic"
	lab var `x'asia "Asian"
	lab var `x'nhpi "Native Hawaiian and Pacific Islander"
	lab var `x'aian "American Indians and Alaska Natives"
	lab var `x'2mor "Two or More Races"
	lab var `x'unkn "Unknown Races"
	lab var `x'nral "Non Resident Alien"
}

sort unitid year
foreach var in is te nte{
	foreach category in totl whit bkaa hisp asia nhpi aspi aian 2mor unkn othe nral{
		replace avgnhr`var'`category' = . if avgnh`var'totl == 0
		by unitid: replace avglvr`var'`category' = . if `var'`category'[_n-1] == 0
	}
}

summarystat (avgnhistotl avgnhiswhit avgnhisbkaa avgnhishisp avgnhisasia avgnhisnhpi avgnhisaian avgnhis2mor avgnhisunkn avgnhisnral) ///
			(avgnhristotl avgnhriswhit avgnhrisbkaa avgnhrishisp avgnhrisasia avgnhrisnhpi avgnhrisaian avgnhris2mor avgnhrisunkn avgnhrisnral) ///
			(avglvistotl avglviswhit avglvisbkaa avglvishisp avglvisasia avglvisnhpi avglvisaian avglvis2mor avglvisunkn avglvisnral) ///
			(avglvristotl avglvriswhit avglvrisbkaa avglvrishisp avglvrisasia avglvrisnhpi avglvrisaian avglvris2mor avglvrisunkn avglvrisnral) ///
			[aweight=weight] if year==2019, by(institution) all obs(top) format(%15.3fc) pan("Inflow Count" "Hiring Composition" "Outflow Count" "Leaving Rate") save("$table/Tab2.dta") replace

gen te = 1
lab de te 1 "TTT"
lab val te te
gen nte = 1
lab de nte 1 "NTT"
lab val nte nte

foreach x in te nte{
	summarystat (avgnh`x'totl avgnh`x'whit avgnh`x'bkaa avgnh`x'hisp avgnh`x'asia avgnh`x'nhpi avgnh`x'aian avgnh`x'2mor avgnh`x'unkn avgnh`x'nral) (avgnhr`x'totl avgnhr`x'whit avgnhr`x'bkaa avgnhr`x'hisp avgnhr`x'asia avgnhr`x'nhpi avgnhr`x'aian avgnhr`x'2mor avgnhr`x'unkn avgnhr`x'nral) (avglv`x'totl avglv`x'whit avglv`x'bkaa avglv`x'hisp avglv`x'asia avglv`x'nhpi avglv`x'aian avglv`x'2mor avglv`x'unkn avglv`x'nral) (avglvr`x'totl avglvr`x'whit avglvr`x'bkaa avglvr`x'hisp avglvr`x'asia avglvr`x'nhpi avglvr`x'aian avglvr`x'2mor avglvr`x'unkn avglvr`x'nral) [aweight=weight] if year==2019, by(`x') format(%15.3fc) obs(top) pan("Inflow Count" "Hiring Composition" "Outflow Count" "Leaving Rate") save("$table/Tab2_`x'.dta") replace
}

use "$table/Tab2.dta", clear
rename v2 v21
merge 1:1 _n using "$table/Tab2_te.dta", nogen
rename v2 v22
merge 1:1 _n using "$table/Tab2_nte.dta", nogen
rename v2 v23
order v22 v23, a(v21)
