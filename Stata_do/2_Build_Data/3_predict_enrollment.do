clear
set more off

use "$wdata/intermediate/NCES_Enrollment_Projection.dta", clear

keep instype
duplicates drop
expand 28
bysort instype: gen year = _n + 2012

merge 1:1 instype year using "$wdata/intermediate/NCES_Enrollment_Projection.dta"
drop _m

merge 1:1 instype year using "$wdata/intermediate/NCES_Enrollment_Projection_19702028.dta"
drop _m

keep if year >= 2000

sort instype year

foreach x in Public4-year Public2-year Private4-year Private2-year{
	foreach y in projenrft projenrpt{
		reg `y' projenrfte if instype == "`x'"
		predict yhat
		replace `y' = yhat if instype == "`x'" & `y' == .
		drop yhat
	}
}

merge m:1 year using "$wdata/intermediate/Age1829_Population_Projection.dta"
drop _m

sort instype year

gen projenrft_hat = .
gen projenrpt_hat = .
gen projenrfte_hat = .


encode instype, gen(inscd)
reg projenrft c.pop_1824totl#i.inscd c.pop_2529totl#i.inscd c.pop_1824whit#i.inscd c.pop_2529whit#i.inscd c.pop_1824bkaa#i.inscd c.pop_2529bkaa#i.inscd c.pop_1824hisp#i.inscd c.pop_2529hisp#i.inscd c.pop_1824asia#i.inscd c.pop_2529asia#i.inscd i.inscd
reg projenrft pop_1824totl pop_2529totl pop_1824whit pop_2529whit pop_1824bkaa pop_2529bkaa pop_1824hisp pop_2529hisp pop_1824asia pop_2529asia i.inscd

foreach x in Public4-year Public2-year Private4-year Private2-year{
	foreach y in projenrft projenrpt projenrfte{
		reg `y' pop_1824totl pop_2529totl pop_1824whit pop_2529whit pop_1824bkaa pop_2529bkaa pop_1824hisp pop_2529hisp pop_1824asia pop_2529asia if instype == "`x'"
		predict yhat
		replace `y'_hat = yhat if instype == "`x'"
		drop yhat
	}
}

gen projenr = projenrft + projenrpt
gen projenr_hat = projenrft_hat + projenrpt_hat

save "$wdata/intermediate/Enrollment_Projection_Final.dta", replace		
