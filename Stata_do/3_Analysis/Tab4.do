clear 
set more off

do "$do/ado/texsaveyt.ado"

clear
set more off

cap program drop crossttest
program define crossttest

foreach x in b hd rd hr rr{
	sum `x' [aw=weight]	
	loc mean`x' = r(mean)
	loc sd`x' = r(sd)
	foreach y in b hd rd hr rr{
		cap drop diff
		gen diff = `x' - `y'
		mean diff [aw=weight]	
		loc diff`x'vs`y' = r(table)[1,1]
		loc se`x'vs`y' = r(table)[2,1]
		loc p`x'vs`y' = r(table)[4,1]
	}
}

clear

set obs 10

gen senario = ""
replace senario = "(1) Baseline" in 1
replace senario = "(2) Diversity Hiring" in 3
replace senario = "(3) Diversity Hiring + Retention" in 5
replace senario = "(4) Representation Hiring" in 7
replace senario = "(5) Representation Hiring + Retention" in 9

gen estimate = .

loc i = 1
foreach x in b hd rd hr rr{
	replace estimate = `mean`x'' in `i'
	loc i = `i' + 2
}

loc i = 2
foreach x in b hd rd hr rr{
	replace estimate = `sd`x'' in `i'
	loc i = `i' + 2
}

loc i = 1
foreach x in b hd rd hr rr{
	gen diff`i' = .
	loc j = 1
	foreach y in b hd rd hr rr{ //row
		loc k = `j' + 1
		if "`x'" != "`y'"{
			replace diff`i' = `diff`y'vs`x'' in `j'
			replace diff`i' = `se`y'vs`x'' in `k'

		}
		loc j = `j' + 2
	}
	loc i = `i' + 1
}

tostring est, replace format(%9.3f) force
replace est = "(" + est + ")" if mod(_n,2) == 0

tostring diff*, replace format(%9.3f) force
forv i = 1(1)5{
	replace diff`i' = "[" + diff`i' + "]" if mod(_n,2) == 0 & diff`i' ~= "."
	replace diff`i' = "-" if diff`i' == "."
}

loc i = 1
foreach x in b hd rd hr rr{ //column
	loc j = 1
	foreach y in b hd rd hr rr{ //row
		if "`x'" != "`y'"{
			replace diff`i' = diff`i' + "*" if `p`y'vs`x'' < 0.1 in `j'
			replace diff`i' = diff`i' + "*" if `p`y'vs`x'' < 0.05 in `j'
			replace diff`i' = diff`i' + "*" if `p`y'vs`x'' < 0.01 in `j'
		}
		loc j = `j' + 2
	}
	loc i = `i' + 1
}
end


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

keep if year == 2035

preserve

foreach x in b hd rd hr rr{
	gen `x' = is_D9_`x'50
}

crossttest

save "$table/Tab4_A.dta", replace

restore 

preserve

foreach x in b hd rd hr rr{
	gen `x' = is_R9_`x'50
}


crossttest

save "$table/Tab4_B.dta", replace

restore 

fawegwag

foreach i in 1 2 3 4 5 6{
	
	preserve
	
	foreach x in b hd rd hr rr{
		gen `x' = is_D9_`x'50
	}
	
	keep if institution == `i'
	
	crossttest

	save "$table/TabA1_`i'.dta", replace
	
	restore
	
}


foreach i in 1 2 3 4 5 6{
	
	preserve
	
	foreach x in b hn ht rn rt{
		gen `x' = is_R9_`x'50
	}
	
	keep if institution == `i'
	
	crossttest

	save "$table/TabA2_`i'.dta", replace
	
	restore
	
}

clear

set obs 1

ap using "$table/Tab4_A.dta"
set obs 12
ap using "$table/Tab4_B.dta"

foreach var of varlist _all{
	replace `var' = subinstr(`var',"0.",".",.)
}

replace senario = "\multicolumn{6}{l}{\bf Panel A: Diversity Index}}" in 1
replace senario = "\multicolumn{6}{l}{\bf Panel B: Representativness Index}}" in 12

texsaveyt 	_all using "$tex/Tab4_temp.tex", replace ///
			title ("Predicted Faculty Diversity in 2035 and Paired t-test across Scenarios") nonames ///
			headerlines("Senario & Estimate & \multicolumn{4}{c}{Paired t-test} \\ \cmidrule(l){3-6} & in 2035 & (1) & (2) & (3) & (4)") ///
			hlines(0 11) nofix size(footnotesize) align(lccccc) ///
			label(ttest) frag rh(1) cs(2) ///
			footnote("Standard deviation in parentheses. Standard error in squared brackets. All statistics are weighted by number of faculty in 2001.")

filefilter "$tex/Tab4_temp.tex" "$tex/Tab4.tex", from("&&&&&") to("") replace
rm "$tex/Tab4_temp.tex"
