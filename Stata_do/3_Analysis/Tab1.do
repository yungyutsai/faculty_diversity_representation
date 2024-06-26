do "$do/ado/summarystat.ado"

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

*****************

lab de institution 1 "Public 4-year" 2 "Non-profit 4-year" 3 "For-profit 4-year" 4 "Public 2-year" 5 "Non-profit 2-year" 6 "For-profit 2-year"
lab val institution institution

lab var ftetotl "Total Student Enrollment (FTE)"
lab var istotl "Total Instructional Staff"

foreach x in propfte propis{
	cap lab var `x'totl "All Racial/Ethnic Groups"
	lab var `x'whit "Prop. White"
	lab var `x'bkaa "Prop. Black and African American"
	lab var `x'hisp "Prop. Hispanic"
	lab var `x'asia "Prop. Asian"
	lab var `x'nhpi "Prop. Native Hawaiian and Pacific Islander"
	lab var `x'aian "Prop. American Indians and Alaska Natives"
	lab var `x'2mor "Prop. Two or More Races"
	lab var `x'unkn "Prop. Unknown Races"
	lab var `x'nral "Prop. Non Resident Alien"
}

summarystat (ftetotl propftewhit propftebkaa propftehisp propfteasia propftenhpi propfteaian propfte2mor propfteunkn propftenral fte_D7 fte_D9) (istotl propiswhit propisbkaa propishisp  propisasia propisnhpi propisaian propis2mor propisunkn propisnral is_D7 is_D9) (is_R7 is_R9) [aweight=weight] if year == 2015, by(institution) all obs(top) format(%15.3fc) pan("Student Demographics" "Faculty Demographics" "Representativeness Index") save("$table/Tab1.dta") replace

use "$table/Tab1.dta", clear
