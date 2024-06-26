clear
set more off

forv yr = 2001(1)2007{
	insheet using "$rdata/IPEDS/staff/s`yr'_g_data_stata.csv", comma clear

	label variable unitid   "Unique identification number of the institution"
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
	cap label define label_sgtype 1 "New hires"
	cap label define label_sgtype 2 "New hires, Instruction/research/public service staff total",add
	cap label define label_sgtype 3 "New hires, Instruction/research/public service staff, With tenure",add
	cap label define label_sgtype 4 "New hires, Instruction/research/public service staff, Non-tenured on tenure track",add
	cap label define label_sgtype 5 "New hires, Instruction/research/public service staff, Non-tenured not on tenure track",add
	cap label define label_sgtype 15 "New hires, Staff, Instruction/research/public service staff, without faculty status",add
	cap label define label_sgtype 6 "New hires, Staff total",add
	cap label define label_sgtype 7 "New hires, Staff, Professional staff total",add
	cap label define label_sgtype 8 "New hires, Staff, Professional staff, Executive/administrative and managerial",add
	cap label define label_sgtype 9 "New hires, Staff, Professional staff, Other professionals (support service)",add
	cap label define label_sgtype 10 "New hires, Staff, Nonprofessional staff total",add
	cap label define label_sgtype 11 "New hires, Staff, Nonprofessional staff, Technical and paraprofessionals",add
	cap label define label_sgtype 12 "New hires, Staff, Nonprofessional staff, Clerical and secretarial",add
	cap label define label_sgtype 13 "New hires, Staff, Nonprofessional staff, Skilled crafts",add
	cap label define label_sgtype 14 "New hires, Staff, Nonprofessional staff, Service/maintenance",add
	cap label values sgtype label_sgtype
	cap label define label_functcd 1 "Faculty with tenure (Instruction/research/public service)"
	cap label define label_functcd 2 "Faculty non-tenured on tenure track",add
	cap label define label_functcd 3 "Faculty non-tenured not on tenure track",add
	cap label define label_functcd 4 "Executive/Administrative and managerial",add
	cap label define label_functcd 6 "Other professionals (support service)",add
	cap label define label_functcd 7 "Technical and paraprofessionals",add
	cap label define label_functcd 8 "Clerical and secretarial",add
	cap label define label_functcd 9 "Skilled crafts",add
	cap label define label_functcd 10 "Service/maintenance",add
	cap label define label_functcd 11 "Total faculty (men and women)",add
	cap label define label_functcd 12 "Total non-faculty",add
	cap label define label_functcd 13 "Total new hires",add
	cap label define label_functcd 14 "Faculty, without faculty status",add
	cap label define label_functcd 99 "Generated function code not on original survey form",add
	cap label values functcd label_functcd
	
	compress
	
	keep if functcd == 13 | functcd == 11 | functcd == 1 | functcd == 2 //Faculty Total
	
	keep unitid functcd staff24 staff15 staff16 staff19 staff20 staff18 staff21 staff22 staff23 staff17
	order unitid functcd staff24 staff15 staff16 staff19 staff20 staff18 staff21 staff22 staff23 staff17
	
	recode functcd (13=0)(11=1)(1/2=2)

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
	
	collapse (sum)totl-nral, by(unitid functcd)

	reshape wide totl-nral, i(unitid) j(functcd)

	foreach category in totl male fema whit bkaa hisp asia nhpi aspi aian tmor nral unkn{
		cap drop `category'0 //Keep the unitid, because they report new hired data, and probably just because they do not hire new faculty
		cap rename `category'1 nhis`category'
		cap recode nhis`category' . = 0
		cap rename `category'2 nhte`category'
		cap recode nhte`category' . = 0
	}
	
	cap rename nhistmor nhis2mor
	cap rename nhtetmor nhte2mor
	
	compress
	
	gen year = `yr'
	order year, a(unitid)
	save "$wdata/raw/IPEDS_NewHired`yr'.dta", replace
}
