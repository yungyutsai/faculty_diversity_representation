clear
set more off

forv yr = 2001(1)2007{
	insheet using "$rdata/IPEDS/staff/s`yr'_f_data_stata.csv", comma clear

	label variable unitid   "Unique identification number of the institution"
	label variable arank    "Tenure status and academic rank of full-time faculty"
	label variable xstaff01 "Imputation field for staff01 - Nonresident alien men"
	label variable staff01  "Nonresident alien men"
	label variable xstaff02 "Imputation field for staff02 - Nonresident alien women"
	label variable staff02  "Nonresident alien women"
	label variable xstaff03 "Imputation field for staff03 - Black non-Hispanic men"
	label variable staff03  "Black non-Hispanic men"
	label variable xstaff04 "Imputation field for staff04 - Black non-Hispanic women"
	label variable staff04  "Black non-Hispanic women"
	label variable xstaff05 "Imputation field for staff05 - American Indian or Alaska Native men"
	label variable staff05  "American Indian or Alaska Native men"
	label variable xstaff06 "Imputation field for staff06 - American Indian or Alaska Native women"
	label variable staff06  "American Indian or Alaska Native women"
	label variable xstaff07 "Imputation field for staff07 - Asian or Pacific Islander men"
	label variable staff07  "Asian or Pacific Islander men"
	label variable xstaff08 "Imputation field for staff08 - Asian or Pacific Islander women"
	label variable staff08  "Asian or Pacific Islander women"
	label variable xstaff09 "Imputation field for staff09 - Hispanic men"
	label variable staff09  "Hispanic men"
	label variable xstaff10 "Imputation field for staff10 - Hispanic women"
	label variable staff10  "Hispanic women"
	label variable xstaff11 "Imputation field for staff11 - White non-Hispanic men"
	label variable staff11  "White non-Hispanic men"
	label variable xstaff12 "Imputation field for staff12 - White non-Hispanic women"
	label variable staff12  "White non-Hispanic women"
	label variable xstaff13 "Imputation field for staff13 - Race/ethnicity unknown men"
	label variable staff13  "Race/ethnicity unknown men"
	label variable xstaff14 "Imputation field for staff14 - Race/ethnicity unknown women"
	label variable staff14  "Race/ethnicity unknown women"
	label variable xstaff15 "Imputation field for staff15 - Grand total men"
	label variable staff15  "Grand total men"
	label variable xstaff16 "Imputation field for staff16 - Grand total women"
	label variable staff16  "Grand total women"
	cap gen staff17 = staff01 + staff02
	cap gen staff18 = staff03 + staff04
	cap gen staff19 = staff05 + staff06
	cap gen staff20 = staff07 + staff08
	cap gen staff21 = staff09 + staff10
	cap gen staff22 = staff11 + staff12
	cap gen staff23 = staff13 + staff14
	cap gen staff24 = staff15 + staff16
	cap label variable xstaff17 "Imputation field for staff17 - Nonresident alien total"
	cap label variable staff17  "Nonresident alien total"
	cap label variable xstaff18 "Imputation field for staff18 - Black non-Hispanic  total"
	cap label variable staff18  "Black non-Hispanic  total"
	cap label variable xstaff19 "Imputation field for staff19 - American Indian or Alaska Native total"
	cap label variable staff19  "American Indian or Alaska Native total"
	cap label variable xstaff20 "Imputation field for staff20 - Asian or Pacific Islander total"
	cap label variable staff20  "Asian or Pacific Islander total"
	cap label variable xstaff21 "Imputation field for staff21 - Hispanic total"
	cap label variable staff21  "Hispanic total"
	cap label variable xstaff22 "Imputation field for staff22 - White non-Hispanic total"
	cap label variable staff22  "White non-Hispanic total"
	cap label variable xstaff23 "Imputation field for staff23 - Race/ethnicity unknown total"
	cap label variable staff23  "Race/ethnicity unknown total"
	cap label variable xstaff24 "Imputation field for staff24 - Grand total"
	cap label variable staff24  "Grand total"
	label define label_arank 22 "Total full-time faculty"
	label define label_arank 7 "Total full-time faculty, Tenured total",add
	label define label_arank 1 "Total full-time faculty, Tenured, Professors",add
	label define label_arank 2 "Total full-time faculty, Tenured, Associate professors",add
	label define label_arank 3 "Total full-time faculty, Tenured, Assistant professors",add
	label define label_arank 4 "Total full-time faculty, Tenured, Instructors",add
	label define label_arank 5 "Total full-time faculty, Tenured, Lecturers",add
	label define label_arank 6 "Total full-time faculty, Tenured, No academic rank",add
	label define label_arank 14 "Total full-time faculty, Non-tenured on tenure track total",add
	label define label_arank 8 "Total full-time faculty, Non-tenured on tenure track, Professors",add
	label define label_arank 9 "Total full-time faculty, Non-tenured on tenure track, Associate professors",add
	label define label_arank 10 "Total full-time faculty, Non-tenured on tenure track, Assistant professors",add
	label define label_arank 11 "Total full-time faculty, Non-tenured on tenure track, Instructors",add
	label define label_arank 12 "Total full-time faculty, Non-tenured on tenure track, Lecturers",add
	label define label_arank 13 "Total full-time faculty, Non-tenured on tenure track, No academic rank",add
	label define label_arank 21 "Total full-time faculty, Non-tenured not on tenure track total",add
	label define label_arank 15 "Total full-time faculty, Non-tenured not on tenure track, Professors",add
	label define label_arank 16 "Total full-time faculty, Non-tenured not on tenure track, Associate professors",add
	label define label_arank 17 "Total full-time faculty, Non-tenured not on tenure track, Assistant professors",add
	label define label_arank 18 "Total full-time faculty, Non-tenured not on tenure track, Instructors",add
	label define label_arank 19 "Total full-time faculty, Non-tenured not on tenure track, Lecturers",add
	label define label_arank 20 "Total full-time faculty, Non-tenured not on tenure track, No academic rank",add
	label define label_arank 23 "Total full-time faculty, Without faculty status",add
	label values arank label_arank
	
	compress
	
	keep if arank == 22 | arank == 7 | arank == 14 //All full-time instructional staff & Tenured total
	
	keep unitid arank staff24 staff15 staff16 staff19 staff20 staff18 staff21 staff22 staff23 staff17
	order unitid arank staff24 staff15 staff16 staff19 staff20 staff18 staff21 staff22 staff23 staff17
	
	rename staff24 totl
	rename staff15 male
	rename staff16 fema
	rename staff19 aian
	rename staff20 aspi //Asian or Pacific Islander
	rename staff18 bkaa
	rename staff21 hisp
	//rename ??? nhpi (Merged with Asian previous to 2007)
	rename staff22 whit
	//rename ??? 2mor (No this category previous to 2007)
	rename staff23 unkn
	rename staff17 nral

	recode arank 22=1 7/14=2
	
	collapse (sum)totl-nral, by(unitid arank)
	reshape wide totl-nral, i(unitid) j(arank)
	
	foreach category in totl male fema whit bkaa hisp asia nhpi aspi aian 2mor nral unkn{
		cap rename `category'1 is`category'
		cap rename `category'2 te`category'
	}
	
	compress
	
	gen year = `yr'
	order year, a(unitid)
	save "$wdata/raw/IPEDS_Faculty`yr'.dta", replace
	
}
