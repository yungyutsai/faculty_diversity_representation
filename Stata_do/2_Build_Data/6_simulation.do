if c(username) == "yungyu" {
	global rdata = "/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata"
	global wdata = "/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/workdata"
	global do = "/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/Stata_do"
	global figure = "/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/figure"
}

use "$wdata/analysis/IPEDS_Balanced_Panel.dta", clear

keep if inrange(year,2015,2019)
gen nhdata = nhistotl ~= .
egen totnhdata = sum(nhdata), by(unitid)
keep if totnhdata == 5

sort unitid year

keep unitid
duplicates drop

expand 27
sort unitid
by unitid: gen year = 2013 + _n

merge 1:1 unitid year using "$wdata/analysis/IPEDS_Balanced_Panel.dta", replace update
drop if _m == 2
drop _m
merge 1:1 unitid year using "$wdata/intermediate/Hiring_Projection.dta", replace update
drop if _m == 2
drop _m

sort unitid year

dis "Calculate net flow and leaving"
foreach var in is te nte{
	foreach category in totl whit bkaa hisp asia nhpi aspi aian 2mor unkn othe nral{
		qui by unitid: gen nf`var'`category' = `var'`category' - `var'`category'[_n-1] // Net flow
		qui gen lv`var'`category' = nh`var'`category' - nf`var'`category' // Leaving
		qui count if lv`var'`category' != . // Number of non-missing
		loc N = r(N)
		qui count if lv`var'`category' < 0 & nh`var'`category' != 0 // Number of negative
		loc n = r(N)
		loc p: dis %4.3f `n'/`N' // Report proportion of negative leaving
		dis "`var', `category'"
		dis "--Negative Proportion: `p'"
	}
}

dis "Recode negative as missing"
foreach var in is te nte{
	foreach category in totl whit bkaa hisp asia nhpi aspi aian 2mor unkn othe nral{
		//qui replace nh`var'`category' = . if lv`var'`category' < 0
		qui replace lv`var'`category' = . if lv`var'`category' < 0
	}
}

** Average net flow from
dis "Calculate average rate in 2016–2019..."
foreach var in is te nte{
	foreach category in totl whit bkaa hisp asia nhpi aspi aian 2mor unkn othe nral{
		dis "`var', `category'"
		qui{
		** Calculate average net flow in 2016–19
		gen v1 = nf`var'`category' if inrange(year,2016,2019)
		egen avgnf`var'`category' = mean(v1), by(unitid)
		drop v1
		dis "--Net Flow: Record Missing as Zero"
		noi recode avgnf`var'`category' . = 0

		** Calculate average hiring composition in 2016–19
		gen v1 = nh`var'`category' if inrange(year,2016,2019)
		egen avgnh`var'`category' = mean(v1), by(unitid)
		drop v1
		gen nhr`var'`category' = nh`var'`category' / nh`var'totl // Hiring rate
		gen v1 = nhr`var'`category' if inrange(year,2016,2019)
		egen avgnhr`var'`category' = mean(v1), by(unitid)
		drop v1
		noi dis "--Hiring: Record Missing as Zero"
		noi recode avgnh`var'`category' . = 0 
		noi dis "--Hiring Composition: Record Missing as Zero"
		noi recode avgnhr`var'`category' . = 0 
			
		** Calculate average leaving rate in 2016–19
		gen v1 = lv`var'`category' if inrange(year,2016,2019)
		egen avglv`var'`category' = mean(v1), by(unitid)
		drop v1
		noi dis "--Leaving: Record Missing as Zero"
		noi recode avglv`var'`category' . = 0
		//replace avglv`var'`category' = 0 if avglv`var'`category' < 0
		by unitid: gen v1 = lv`var'`category' / `var'`category'[_n-1] if inrange(year,2016,2019)
		egen avglvr`var'`category' = mean(v1), by(unitid)
		drop v1
		noi dis "--Leaving Rate: Record Missing as Zero"
		noi replace avglvr`var'`category' = 0 if avglvr`var'`category' == .
		noi dis "--Leaving Rate: Record >1 as 1"
		noi replace avglvr`var'`category' = 1 if avglvr`var'`category' > 1 & avglvr`var'`category' != .
		}
	}
}

** Adjust sum of hiring composition = 1
foreach var in is te nte{
	qui gen v1 = avgnhr`var'whit+avgnhr`var'bkaa+avgnhr`var'hisp+avgnhr`var'asia+avgnhr`var'nhpi+avgnhr`var'aian+avgnhr`var'2mor+avgnhr`var'unkn+avgnhr`var'nral
	foreach category in whit bkaa hisp asia nhpi aspi aian 2mor unkn othe nral{
		qui replace avgnhr`var'`category' = avgnhr`var'`category' / v1
		recode avgnhr`var'`category' . = 0 
	}
	drop v1
}
replace avgnhristotl = 1
replace avgnhrtetotl = 1
replace avgnhrntetotl = 1

** Define underrepresented group and minority group
cap drop v1
foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral{
	gen under`category' = propis`category' < propfte`category'
	gen v1 = under`category' if year == 2021
	egen under`category'2021 = mean(v1), by(unitid)
	drop v1
	
	gen minor`category' = propis`category' < 1/9
	gen v1 = minor`category' if year == 2021
	egen minor`category'2021 = mean(v1), by(unitid)
	drop v1
	
	gen v1 = propfte`category' if year == 2021
	egen propfte`category'2021 = mean(v1), by(unitid)
	drop v1
}

rename propftetmor_hat propfte2mor_hat
	
save "$wdata/analysis/IPEDS_TTEData_for_Simulation.dta", replace

use "$wdata/analysis/IPEDS_TTEData_for_Simulation.dta", clear

forv r = 1.05(0.05)2.05 { //forv r = 1.05(0.05)2.05; foreach r in 1.5
	dis "Simulation using ratio `r'..."
	dis "---+-- 20% --+-- 40% --+-- 60% --+-- 80% --+-- 100%"
	qui{
	use  "$wdata/analysis/IPEDS_TTEData_for_Simulation.dta", clear
	noi _dots `i' 0
	** Generate variables
	foreach var in is te nte{
		foreach category in totl whit bkaa hisp asia nhpi aian 2mor unkn nral{
			foreach scenario in b hd rd hr rr{
				gen `var'`category'_`scenario' = `var'`category' if year <= 2021
			}
		}
	}
	foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral{
		foreach scenario in hd rd hr rr{
			gen under`category'2021_`scenario' = under`category'2021
			gen minor`category'2021_`scenario' = minor`category'2021
		}
	}
	
	** Simulate faculty composition under each senario
	forv i = 2022(1)2040{
		noi _dots `i' 0
		loc j = `i' - 1
		
		** Baseline assumption
		foreach var in te nte{
			foreach category in totl whit bkaa hisp asia nhpi aian 2mor unkn nral{
				by unitid: replace `var'`category'_b = `var'`category'_b[_n-1] + nh`var'_hat * avgnhr`var'`category' - (`var'`category'_b[_n-1] * avglvr`var'`category') if year == `i'
				replace `var'`category'_b = 0 if `var'`category'_b < 0 & year == `i'
			}
		}
		foreach category in totl whit bkaa hisp asia nhpi aian 2mor unkn nral{
			replace is`category'_b = te`category'_b + nte`category'_b if year == `i'
		}
		
		** Calculate adjusted hiring composition and leaving rate of each senario
		foreach scenario in h r {
			foreach var in te nte{
				cap gen avgnhr`var'under = 0
				replace avgnhr`var'under = 0
				cap gen avgnhr`var'minor = 0
				replace avgnhr`var'minor = 0
				** Calculate sum of hiring composition of underrepresented group and minority group
				foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral{
					replace avgnhr`var'under = avgnhr`var'under + avgnhr`var'`category' if under`category'`j'_`scenario'r == 1
					replace avgnhr`var'minor = avgnhr`var'minor + avgnhr`var'`category' if minor`category'`j'_`scenario'd == 1
				}
				cap gen avgnhr`var'under2 = .
				replace avgnhr`var'under2 = avgnhr`var'under * `r' // Boost hiring composition
				replace avgnhr`var'under2 = 1 if avgnhr`var'under2 > 1 & avgnhr`var'under2 != . // Adjust for sum of composition > 1 to 1
				cap gen avgnhr`var'minor2 = .
				replace avgnhr`var'minor2 = avgnhr`var'minor * `r' // Boost hiring composition
				replace avgnhr`var'minor2 = 1 if avgnhr`var'minor2 > 1 & avgnhr`var'minor2 != . // Adjust for sum of composition > 1 to 1
				
				foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral{
					* Representation Senario
					cap gen avgnhr`var'`category'_`scenario'r = .
					replace avgnhr`var'`category'_`scenario'r = avgnhr`var'`category' * avgnhr`var'under2 / avgnhr`var'under if under`category'`j'_`scenario'r == 1
					replace avgnhr`var'`category'_`scenario'r = avgnhr`var'`category' * (1-avgnhr`var'under2) / (1-avgnhr`var'under) if under`category'`j'_`scenario'r == 0 // sum(hiring compostion for overrepresented group) = 1 - sum(hiring compostion for underrepresented groups)
					cap gen avglvr`var'`category'_`scenario'r = .
					replace avglvr`var'`category'_`scenario'r = avglvr`var'`category' * (2-`r') if under`category'`j'_`scenario'r == 1
					replace avglvr`var'`category'_`scenario'r = avglvr`var'`category' if under`category'`j'_`scenario'r == 0
					* Diversirty Senario
					cap gen avgnhr`var'`category'_`scenario'd = .
					replace avgnhr`var'`category'_`scenario'd = avgnhr`var'`category' * avgnhr`var'minor2 / avgnhr`var'minor if minor`category'`j'_`scenario'd == 1
					replace avgnhr`var'`category'_`scenario'd = avgnhr`var'`category' * (1-avgnhr`var'minor2) / (1-avgnhr`var'minor) if minor`category'`j'_`scenario'd == 0
					cap gen avglvr`var'`category'_`scenario'd = .
					replace avglvr`var'`category'_`scenario'd = avglvr`var'`category' * (2-`r') if minor`category'`j'_`scenario'd == 1
					replace avglvr`var'`category'_`scenario'd = avglvr`var'`category' if minor`category'`j'_`scenario'r == 0
				}
			}
		}
		
		noi _dots `i' 0
		** Hiring and Retention Assumption
		foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral{
			foreach scenario in d r{ // D = Diversity; R = Representation
			
				** (1) Hiring assumption:
				
				*** A. TTT (`r' times hiring composition)
				by unitid: replace te`category'_h`scenario' = ///
				te`category'_h`scenario'[_n-1] /// Stock in t-1
				+ nhte_hat * avgnhrte`category'_h`scenario' /// Inflow (Boost)
				- (te`category'_h`scenario'[_n-1] * avglvrte`category') if year == `i' // Outflow (Baseline)
				
				replace te`category'_h`scenario' = 0 if te`category'_h`scenario' < 0 & year == `i' // Adjust negative to 0
				replace te`category'_h`scenario' = te`category'_b if te`category'_h`scenario' == . & year == `i' // Adjust missing to baseline senario

				*** B. NTT (`r' times hiring composition)
				
				by unitid: replace nte`category'_h`scenario' = ///
				nte`category'_h`scenario'[_n-1] /// Stock in t-1
				+ nhnte_hat * avgnhrnte`category'_h`scenario' /// Inflow (Boost)
				- (nte`category'_h`scenario'[_n-1] * avglvrnte`category') if year == `i' // Outflow (Baseline)
				
				replace nte`category'_h`scenario' = 0 if nte`category'_h`scenario' < 0 & year == `i' // Adjust negative to 0
				replace nte`category'_h`scenario' = nte`category'_b if nte`category'_h`scenario' == . & year == `i' // Adjust missing to baseline senario
				
				*** C. TTT + NTT
				replace is`category'_h`scenario' = te`category'_h`scenario' + nte`category'_h`scenario' if year == `i'
				
				** (2) Hiring + retention assumption:
				
				*** A. TTT (`r' times hiring composition)
				by unitid: replace te`category'_r`scenario' = ///
				te`category'_r`scenario'[_n-1] /// Stock in t-1
				+ nhte_hat * avgnhrte`category'_r`scenario' /// Inflow (Boost)
				- (te`category'_r`scenario'[_n-1] * avglvrte`category'_r`scenario') if year == `i' // Outflow (Reduced)
				
				replace te`category'_r`scenario' = 0 if te`category'_r`scenario' < 0 & year == `i' // Adjust negative to 0
				replace te`category'_r`scenario' = te`category'_b if te`category'_r`scenario' == . & year == `i' // Adjust missing to baseline senario

				*** B. NTT (`r' times hiring composition + (2-`r') times leaving rate)
				
				by unitid: replace nte`category'_r`scenario' = ///
				nte`category'_r`scenario'[_n-1] /// Stock in t-1
				+ nhnte_hat * avgnhrnte`category'_r`scenario' /// Inflow (Boost)
				- (nte`category'_r`scenario'[_n-1] * avglvrnte`category'_r`scenario') if year == `i' // Outflow (Reduced)
				
				replace nte`category'_r`scenario' = 0 if nte`category'_r`scenario' < 0 & year == `i' // Adjust negative to 0
				replace nte`category'_r`scenario' = nte`category'_b if nte`category'_r`scenario' == . & year == `i' // Adjust missing to baseline senario
				
				*** C. TTT + NTT
				replace is`category'_r`scenario' = te`category'_r`scenario' + nte`category'_r`scenario' if year == `i'
			}
		}
		
		noi _dots `i' 0
		noi _dots `i' 0
		** Calculate composition (make % sum up as 100%)
		foreach scenario in b hd rd hr rr{
			foreach var in is {
				cap gen `var'totl_`scenario' = .
				replace `var'totl_`scenario' = `var'whit_`scenario' + `var'bkaa_`scenario' + `var'hisp_`scenario' + `var'asia_`scenario' + `var'nhpi_`scenario' + `var'aian_`scenario' + `var'2mor_`scenario' + `var'unkn_`scenario' + `var'nral_`scenario' if year == `i'
				foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral{
					cap gen prop`var'`category'_`scenario' = .
					replace prop`var'`category'_`scenario' = `var'`category'_`scenario' / `var'totl_`scenario' if year == `i'
				}
			}
		}
		
		noi _dots `i' 0
		noi _dots `i' 0
		** Redefine Underrepresented and Minority Group
		cap drop v1
		foreach category in whit bkaa hisp asia nhpi aian 2mor unkn nral{
			foreach scenario in b hd rd hr rr{
				cap gen under`category'_`scenario' = .
				replace under`category'_`scenario' = propis`category'_`scenario' < propfte`category'_hat //Aim to reach 100% representation
				gen v1 = under`category'_`scenario' if year == `i'
				egen under`category'`i'_`scenario' = mean(v1), by(unitid)
				drop v1
				
				cap gen minor`category'_`scenario' = .
				replace minor`category'_`scenario' = propis`category'_`scenario' < 1/9 //Aim to reach equally distribution
				gen v1 = minor`category'_`scenario' if year == `i'
				egen minor`category'`i'_`scenario' = mean(v1), by(unitid)
				drop v1
			}
		}
	}
	
	noi _dots `i' 0
	noi _dots `i' 0
	** Calculate index
	foreach scenario in b hd rd hr rr{
		foreach var in is {
			** Diversity Index
			gen `var'_D9_`scenario' = (1-(prop`var'whit_`scenario'^2 + prop`var'bkaa_`scenario'^2 + prop`var'hisp_`scenario'^2 + prop`var'asia_`scenario'^2 + prop`var'nhpi_`scenario'^2 + prop`var'aian_`scenario'^2 + prop`var'2mor_`scenario'^2 + prop`var'unkn_`scenario'^2 + prop`var'nral_`scenario'^2))/8*9
			replace `var'_D9_`scenario' = 1 if `var'_D9_`scenario' > 1 & `var'_D9_`scenario' ~= .
			replace `var'_D9_`scenario' = 0 if `var'_D9_`scenario' < 0 & `var'_D9_`scenario' ~= .
			
			** Representativness Index
			gen `var'_R9_`scenario' = 	1 - sqrt( ( ///
							(prop`var'whit_`scenario' - propftewhit_hat)^2 + ///
							(prop`var'bkaa_`scenario' - propftebkaa_hat)^2 + ///
							(prop`var'hisp_`scenario' - propftehisp_hat)^2 + ///
							(prop`var'asia_`scenario' - propfteasia_hat)^2 + ///
							(prop`var'nhpi_`scenario' - propftenhpi_hat)^2 + ///
							(prop`var'aian_`scenario' - propfteaian_hat)^2 + ///
							(prop`var'2mor_`scenario' - propfte2mor_hat)^2 + ///
							(prop`var'unkn_`scenario' - propfteunkn_hat)^2 + ///
							(prop`var'nral_`scenario' - propftenral_hat)^2 ) / 2 )
							
			replace `var'_R9_`scenario' = 1 if `var'_R9_`scenario' > 1 & `var'_R9_`scenario' ~= .
			replace `var'_R9_`scenario' = 0 if `var'_R9_`scenario' < 0 & `var'_R9_`scenario' ~= .
			
			** Representativness Index (Use Initial Student Composition)
			gen `var'_R9v2_`scenario' = 	1 - sqrt( ( ///
							(prop`var'whit_`scenario' - propftewhit2021)^2 + ///
							(prop`var'bkaa_`scenario' - propftebkaa2021)^2 + ///
							(prop`var'hisp_`scenario' - propftehisp2021)^2 + ///
							(prop`var'asia_`scenario' - propfteasia2021)^2 + ///
							(prop`var'nhpi_`scenario' - propftenhpi2021)^2 + ///
							(prop`var'aian_`scenario' - propfteaian2021)^2 + ///
							(prop`var'2mor_`scenario' - propfte2mor2021)^2 + ///
							(prop`var'unkn_`scenario' - propfteunkn2021)^2 + ///
							(prop`var'nral_`scenario' - propftenral2021)^2 ) / 2 )
							
			replace `var'_R9v2_`scenario' = 1 if `var'_R9v2_`scenario' > 1 & `var'_R9v2_`scenario' ~= .
			replace `var'_R9v2_`scenario' = 0 if `var'_R9v2_`scenario' < 0 & `var'_R9v2_`scenario' ~= .
		}
	}
	
	noi _dots `i' 0
	noi _dots `i' 0
	keep unitid year tetotl_b-ntenral_rr propiswhit_b-propisnral_rr under* minor* is_D9_b-is_R9v2_rr
	drop under*20* minor*20*
	
	loc p: dis %4.2f `r'
	loc p = substr("`p'",-2,2)
	foreach var of varlist prop* *D9* *R9*{
		rename `var' `var'`p'
	}
	
	compress
	noi _dots `i' 0
	save "$wdata/analysis/simulation/IPEDS_Prediction_Scenario_v`p'.dta", replace
	noi _dots `i' 0
	}
}
