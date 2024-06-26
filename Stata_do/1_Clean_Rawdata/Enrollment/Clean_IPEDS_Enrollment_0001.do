clear
set more off

forv i = 2000(1)2001{
	
	import delimited "$rdata/IPEDS/ef/ef`i'a.csv", clear
	
	gen eftotlt = efrace15 + efrace16
	gen efwhitt = efrace11 + efrace12
	gen efbkaat = efrace03 + efrace04
	gen efhispt = efrace09 + efrace10
	gen efaspit = efrace07 + efrace08 //Asian and Pacific Islander
	gen efaiant = efrace05 + efrace06
	gen efnralt = efrace01 + efrace02
	gen efunknt = efrace13 + efrace14
		
	keep unitid section lstudy ef*t
	
	gen year = `i' //Use fall semester to define year
	order unitid year
		
	label variable unitid   "Unique identification number of the institution"
	label variable section  "Attendance status of student"
	label variable lstudy   "Level of student"
	label variable eftotlt  "Enrollment total"
	
	label define label_section 1 "Full-time"
	label define label_section 2 "Part-time",add
	label define label_section 3 "All students",add
	label values section label_section
	label define label_lstudy 1 "Undergraduate"
	label define label_lstudy 3 "Graduate",add
	label define label_lstudy 4 "All students",add
	label values lstudy label_lstudy
	
	keep if lstudy == 4
	keep if section == 1 | section == 2
	
	gen type = "ft" if section == 1
	replace type = "pt" if section == 2
	
	keep year unitid type ef*
	reshape wide ef*, i(year unitid) j(type) string
	
	foreach x in totl whit bkaa hisp asia nhpi aspi aian 2mor nral unkn{
		cap recode ef`x'tft . = 0
		cap recode ef`x'tpt . = 0
		cap rename ef`x'tft ft`x'
		cap rename ef`x'tpt pt`x'
		cap gen fte`x' = ft`x' + 1/3 * pt`x'
		cap gen tot`x' = ft`x' + pt`x'
	}
		
	save "$wdata/raw/IPEDS_Enroll`i'.dta", replace
}
