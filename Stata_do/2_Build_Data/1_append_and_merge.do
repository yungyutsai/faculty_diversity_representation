clear
set more off

clear
** Append IPEDS Head Data
forv yr = 2001(1)2021{ 
	dis "Append Year `yr'"
	qui ap using "$wdata/raw/IPEDS_Head`yr'.dta", force
	qui cap gen year = `yr'
	qui cap replace year = `yr' if year == .
}

compress

gen carnegie = .

foreach x in 21 18 15 c{
	replace carnegie = 4 if carnegie == . & inrange(c`x'basic,1,9) //Associate's Colleges
	replace carnegie = 5 if carnegie == . & inrange(c`x'basic,10,13) //Special Focus Two-Year
	replace carnegie = 4 if carnegie == . & c`x'basic == 14 //Baccalaureate/Associate's Colleges: Associate's Dominant
	replace carnegie = 3 if carnegie == . & c`x'basic == 23 //Baccalaureate/Associate's Colleges: Mixed Baccalaureate/Associate's
	replace carnegie = 3 if carnegie == . & inrange(c`x'basic,21,22) //Baccalaureate Colleges
	replace carnegie = 5 if carnegie == . & inrange(c`x'basic,24,32) //Special Focus Four-Year
	replace carnegie = 2 if carnegie == . & inrange(c`x'basic,18,20) //Master's Colleges & Universities
	replace carnegie = 1 if carnegie == . & inrange(c`x'basic,15,17) //Doctoral Universities
	replace carnegie = 6 if carnegie == . & c`x'basic == 33 //Tribal Colleges
}

replace carnegie = 1 if carnegie == . & inrange(c00basic,15,16) //Doctoral/Research Universities
replace carnegie = 2 if carnegie == . & inrange(c00basic,21,22) //Masters Colleges and Universities
replace carnegie = 3 if carnegie == . & inrange(c00basic,31,33) //Baccalaureate Colleges
replace carnegie = 4 if carnegie == . & c00basic == 40 //Associates Colleges
replace carnegie = 5 if carnegie == . & inrange(c00basic,51,59) //Special Focus Colleges
replace carnegie = 6 if carnegie == . & c00basic == 60 //Tribal colleges

order unitid year instnm stabbr fips obereg iclevel control deggrant hbcu hospital medical carnegie
keep unitid year instnm stabbr fips obereg iclevel control deggrant hbcu hospital medical carnegie

recode iclevel 1=4 2=2 3=1 -3=.
lab de iclevel 4 "4 or more" 2 "at leas 2 ,but less than 4" 1 "less than 2"
lab val iclevel iclevel

replace deggrant = deggrant == 1
replace hbcu = hbcu == 1
replace hospital = hospital == 1
replace medical = medical == 1

lab val deggrant .
lab val hbcu .
lab val hospital .
lab val medical .

sort unitid year

forv i = 1(1)25{
	by unitid: replace carnegie = carnegie[_n+1] if carnegie == .
	by unitid: replace carnegie = carnegie[_n-1] if carnegie == .
}

gsort unitid -year
gen carnegie_newest = carnegie if year == 2021
by unitid: replace carnegie_newest = carnegie_newest[_n-1] if _n != 1
order carnegie_newest, a(carnegie)

duplicates t unitid, gen(count)
keep if count == 20
drop count

save "$wdata/intermediate/IPEDS_Head.dta", replace

use "$wdata/intermediate/IPEDS_Head.dta", clear

gen enroll = 0
gen faculty = 0
gen newhired = 0

forv yr = 2001(1)2021{
	merge 1:1 unitid year using "$wdata/raw/IPEDS_Enroll`yr'.dta", update
	replace enroll = 1 if _m >= 3
	drop if _m == 2
	drop _m
	
	merge 1:1 unitid year using "$wdata/raw/IPEDS_Faculty`yr'.dta", update
	replace faculty = 1 if _m >= 3
	drop if _m == 2
	drop _m
	
	merge 1:1 unitid year using "$wdata/raw/IPEDS_NewHired`yr'.dta", update
	replace newhired = 1 if _m >= 3
	drop if _m == 2
	drop _m
}

save "$wdata/intermediate/IPEDS_Merged_All.dta", replace


** Clean and Imputed Data
use "$wdata/intermediate/IPEDS_Merged_All.dta", clear

** Complete Missing Value
sort unitid year

foreach var of varlist ft* pt* fte* tot*{ //Recode missing as zero if student data is reported (some years some racial groups do not exist)
	recode `var' . = 0 if enroll == 1
}

drop pis*
foreach var of varlist is* { //Recode missing as zero if faculty data is reported (some years some racial groups do not exist)
	recode `var' . = 0 if faculty == 1
}

foreach var of varlist te*{ //Recode missing as zero if tenured track faculty data is reported (some years some racial groups do not exist)
	recode `var' . = 0 if faculty == 1 & tetotl ~= .
}

foreach var of varlist nh*{ //Recode missing as zero if hiring data is reported (some years some racial groups do not exist)
	recode `var' . = 0 if newhired == 1
}

foreach var in ft pt fte tot is te nhis nhte{
	replace `var'aspi = `var'asia + `var'nhpi if `var'aspi == 0
	gen `var'othe = `var'unkn + `var'2mor
}	

sort unitid year
* Use Midpoint of two (to five) years to complete missing values
foreach var in ft pt fte tot is te nhis nhte{
	foreach category in totl whit bkaa hisp asia nhpi aspi aian 2mor unkn othe nral{
		by unitid: replace `var'`category' = `var'`category'[_n-1] + (`var'`category'[_n+4] - `var'`category'[_n-1])/5 if `var'`category' == . & `var'`category'[_n+1] == . & `var'`category'[_n+2] == . & `var'`category'[_n+3] == .
		by unitid: replace `var'`category' = `var'`category'[_n-1] + (`var'`category'[_n+3] - `var'`category'[_n-1])/4 if `var'`category' == . & `var'`category'[_n+1] == . & `var'`category'[_n+2] == .
		by unitid: replace `var'`category' = `var'`category'[_n-1] + (`var'`category'[_n+2] - `var'`category'[_n-1])/3 if `var'`category' == . & `var'`category'[_n+1] == .
		by unitid: replace `var'`category' = (`var'`category'[_n-1] + `var'`category'[_n+1])/2 if `var'`category' == .
	}
}

gen menroll = tottotl == .
gen mfaculty = istotl == .
gen mnewhired = nhistotl == .

foreach x in enroll faculty newhired{
	egen totm`x' = sum(m`x'), by(unitid)
}

order unitid year instnm stabbr fips obereg iclevel control carnegie carnegie_newest deggrant hbcu hospital medical enroll faculty newhired menroll mfaculty mnewhired totmenroll totmfaculty totmnewhired ft* pt* fte* tot* is* te* nhis* nhte*

lab var unitid "Unique identification number of the institution"
lab var year "Year (Fall semester)"
lab var instnm "Institution name"
lab var stabbr "State abbreviation"
lab var fips "FIPS state code"
lab var obereg "Bureau of Economic Analysis (BEA) regions"
lab var iclevel "Level of institution"
lab var control "Control of institution"
lab var carnegie "Carnegie Categorization"
lab var carnegie_newest "Carnegie Categorization of the Newest Year"
lab var deggrant "Degree-granting status"
lab var hbcu "Historically Black College or University"
lab var hospital "Institution has hospital"
lab var medical "Institution grants a medical degree"
lab var enroll "Have enrollment data"
lab var faculty "Have faculty data"
lab var newhired "Have hiring data"
lab var menroll "Missing enrollment data"
lab var mfaculty "Missing faculty data"
lab var mnewhired "Missing hiring data"
lab var totmenroll "Total Missing enrollment data"
lab var totmfaculty "Total Missing faculty data"
lab var totmnewhired "Total Missing hiring data"

foreach x in ft pt fte tot is te nhis nhte{
	if "`x'" == "ft"{
		loc var = "Full time enrollment"
	}
	if "`x'" == "pt"{
		loc var = "Part time enrollment"
	}
	if "`x'" == "fte"{
		loc var = "FTE enrollment"
	}
	if "`x'" == "tot"{
		loc var = "Total enrollment"
	}
	if "`x'" == "is"{
		loc var = "Instructional staff"
	}
	if "`x'" == "te"{
		loc var = "Tenured/tenure track faculty"
	}
	if "`x'" == "nhis"{
		loc var = "New hired instructional staff"
	}
	if "`x'" == "nhte"{
		loc var = "New hired tenured/tenure track faculty"
	}
	foreach y in totl whit bkaa hisp asia nhpi aspi aian 2mor unkn othe nral{
		if "`y'" == "totl"{
			loc grp = "Total"
		}
		if "`y'" == "whit"{
			loc grp = "White"
		}
		if "`y'" == "bkaa"{
			loc grp = "Black and African American"
		}
		if "`y'" == "hisp"{
			loc grp = "Hispanic"
		}
		if "`y'" == "asia"{
			loc grp = "Asian"
		}
		if "`y'" == "nhpi"{
			loc grp = "Pacific Islander"
		}
		if "`y'" == "aspi"{
			loc grp = "Asian & Pacific Islander"
		}
		if "`y'" == "aian"{
			loc grp = "American Indian or Alaska Native"
		}
		if "`y'" == "2mor"{
			loc grp = "Two or more races"
		}
		if "`y'" == "unkn"{
			loc grp = "Unknown"
		}
		if "`y'" == "othe"{
			loc grp = "Two or more races + Unknown"
		}
		if "`y'" == "nral"{
			loc grp = "Nonresident Alien"
		}
		lab var `x'`y' "`var' (`grp')"
	}
}

lab var ismale "Instructional staff (Male)"
lab var isfema "Instructional staff (Female)"
lab var temale "Tenured/tenure track faculty (Male)"
lab var tefema "Tenured/tenure track faculty (Female)"
lab var nhismale "New hired instructional staff (Male)"
lab var nhisfema "New hired instructional staff (Female)"
lab var nhtemale "New hired TTE faculty (Male)"
lab var nhtefema "New hired TTE faculty (Female)"

compress
save "$wdata/analysis/IPEDS_Merged_All_Imputed.dta", replace
