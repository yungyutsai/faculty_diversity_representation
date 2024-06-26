clear
set more off

forv yr = 2008(1)2011{
	insheet using "$rdata/IPEDS/staff/s`yr'_f_data_stata.csv", comma clear

	label variable unitid   "Unique identification number of the institution"
	label variable arank    "Tenure status and academic rank of full-time instruction/research/public service staff"
	label variable xhrtotlt "Imputation field for hrtotlt - Grand total"
	label variable hrtotlt  "Grand total"
	label variable xhrtotlm "Imputation field for hrtotlm - Grand total men"
	label variable hrtotlm  "Grand total men"
	label variable xhrtotlw "Imputation field for hrtotlw - Grand total women"
	label variable hrtotlw  "Grand total women"
	label variable xhraiant "Imputation field for hraiant - American Indian or Alaska Native total"
	label variable hraiant  "American Indian or Alaska Native total"
	label variable xhraianm "Imputation field for hraianm - American Indian or Alaska Native men"
	label variable hraianm  "American Indian or Alaska Native men"
	label variable xhraianw "Imputation field for hraianw - American Indian or Alaska Native women"
	label variable hraianw  "American Indian or Alaska Native women"
	label variable xhrasiat "Imputation field for hrasiat - Asian total"
	label variable hrasiat  "Asian total"
	label variable xhrasiam "Imputation field for hrasiam - Asian men"
	label variable hrasiam  "Asian men"
	label variable xhrasiaw "Imputation field for hrasiaw - Asian women"
	label variable hrasiaw  "Asian women"
	label variable xhrbkaat "Imputation field for hrbkaat - Black or African American total"
	label variable hrbkaat  "Black or African American total"
	label variable xhrbkaam "Imputation field for hrbkaam - Black or African American men"
	label variable hrbkaam  "Black or African American men"
	label variable xhrbkaaw "Imputation field for hrbkaaw - Black or African American women"
	label variable hrbkaaw  "Black or African American women"
	label variable xhrhispt "Imputation field for hrhispt - Hispanic or Latino total"
	label variable hrhispt  "Hispanic or Latino total"
	label variable xhrhispm "Imputation field for hrhispm - Hispanic or Latino men"
	label variable hrhispm  "Hispanic or Latino men"
	label variable xhrhispw "Imputation field for hrhispw - Hispanic or Latino women"
	label variable hrhispw  "Hispanic or Latino women"
	label variable xhrnhpit "Imputation field for hrnhpit - Native Hawaiian or Other Pacific Islander total"
	label variable hrnhpit  "Native Hawaiian or Other Pacific Islander total"
	label variable xhrnhpim "Imputation field for hrnhpim - Native Hawaiian or Other Pacific Islander men"
	label variable hrnhpim  "Native Hawaiian or Other Pacific Islander men"
	label variable xhrnhpiw "Imputation field for hrnhpiw - Native Hawaiian or Other Pacific Islander women"
	label variable hrnhpiw  "Native Hawaiian or Other Pacific Islander women"
	label variable xhrwhitt "Imputation field for hrwhitt - White total"
	label variable hrwhitt  "White total"
	label variable xhrwhitm "Imputation field for hrwhitm - White men"
	label variable hrwhitm  "White men"
	label variable xhrwhitw "Imputation field for hrwhitw - White women"
	label variable hrwhitw  "White women"
	label variable xhr2mort "Imputation field for hr2mort - Two or more races total"
	label variable hr2mort  "Two or more races total"
	label variable xhr2morm "Imputation field for hr2morm - Two or more races men"
	label variable hr2morm  "Two or more races men"
	label variable xhr2morw "Imputation field for hr2morw - Two or more races women"
	label variable hr2morw  "Two or more races women"
	label variable xhrunknt "Imputation field for hrunknt - Race/ethnicity unknown total"
	label variable hrunknt  "Race/ethnicity unknown total"
	label variable xhrunknm "Imputation field for hrunknm - Race/ethnicity unknown men"
	label variable hrunknm  "Race/ethnicity unknown men"
	label variable xhrunknw "Imputation field for hrunknw - Race/ethnicity unknown women"
	label variable hrunknw  "Race/ethnicity unknown women"
	label variable xhrnralt "Imputation field for hrnralt - Nonresident alien total"
	label variable hrnralt  "Nonresident alien total"
	label variable xhrnralm "Imputation field for hrnralm - Nonresident alien men"
	label variable hrnralm  "Nonresident alien men"
	label variable xhrnralw "Imputation field for hrnralw - Nonresident alien women"
	label variable hrnralw  "Nonresident alien women"
	** For 2008/09 (This two years have different variable names) **
	cap label variable xdvhrait "Imputation field for dvhrait - American Indian or Alaska Native total - derived"
	cap label variable dvhrait  "American Indian or Alaska Native total - derived"
	cap label variable xdvhraim "Imputation field for dvhraim - American Indian or Alaska Native men - derived"
	cap label variable dvhraim  "American Indian or Alaska Native men - derived"
	cap label variable xdvhraiw "Imputation field for dvhraiw - American Indian or Alaska Native women - derived"
	cap label variable dvhraiw  "American Indian or Alaska Native women - derived"
	cap label variable xdvhrapt "Imputation field for dvhrapt - Asian/Native Hawaiian/Other Pacific Islander total - derived"
	cap label variable dvhrapt  "Asian/Native Hawaiian/Other Pacific Islander total - derived"
	cap label variable xdvhrapm "Imputation field for dvhrapm - Asian/Native Hawaiian/Other Pacific Islander men - derived"
	cap label variable dvhrapm  "Asian/Native Hawaiian/Other Pacific Islander men - derived"
	cap label variable xdvhrapw "Imputation field for dvhrapw - Asian/Native Hawaiian/Other Pacific Islander women - derived"
	cap label variable dvhrapw  "Asian/Native Hawaiian/Other Pacific Islander women - derived"
	cap label variable xdvhrbkt "Imputation field for dvhrbkt - Black or African American/Black non-Hispanic total - derived"
	cap label variable dvhrbkt  "Black or African American/Black non-Hispanic total - derived"
	cap label variable xdvhrbkm "Imputation field for dvhrbkm - Black or African American/Black non-Hispanic men - derived"
	cap label variable dvhrbkm  "Black or African American/Black non-Hispanic men - derived"
	cap label variable xdvhrbkw "Imputation field for dvhrbkw - Black or African American/Black non-Hispanic women - derived"
	cap label variable dvhrbkw  "Black or African American/Black non-Hispanic women - derived"
	cap label variable xdvhrhst "Imputation field for dvhrhst - Hispanic or Latino/Hispanic total - derived"
	cap label variable dvhrhst  "Hispanic or Latino/Hispanic total - derived"
	cap label variable xdvhrhsm "Imputation field for dvhrhsm - Hispanic or Latino/Hispanic men - derived"
	cap label variable dvhrhsm  "Hispanic or Latino/Hispanic men - derived"
	cap label variable xdvhrhsw "Imputation field for dvhrhsw - Hispanic or Latino/Hispanic women - derived"
	cap label variable dvhrhsw  "Hispanic or Latino/Hispanic women - derived"
	cap label variable xdvhrwht "Imputation field for dvhrwht - White/White non-Hispanic total - derived"
	cap label variable dvhrwht  "White/White non-Hispanic total - derived"
	cap label variable xdvhrwhm "Imputation field for dvhrwhm - White/White non-Hispanic men - derived"
	cap label variable dvhrwhm  "White/White non-Hispanic men - derived"
	cap label variable xdvhrwhw "Imputation field for dvhrwhw - White/White non-Hispanic women - derived"
	cap label variable dvhrwhw  "White/White non-Hispanic women - derived"
	if `yr' == 2008 | `yr' == 2009{
		replace hraiant = dvhrait if hraiant == .
		replace hrasiat = dvhrapt if hrasiat == .
		replace hrbkaat = dvhrbkt if hrbkaat == .
		replace hrhispt = dvhrhst if hrhispt == .
		//replace hrnhpit = // No variable
		replace hrwhitt = dvhrwht if hrwhitt == .
		//replace hr2mort = // No variable
		//replace hrunknt = hrunknt //No Change
		//replace hrnralt = hrnralt //No Change
	}
	** For 2008/09 **
	label define label_arank 22 "Total full-time Instruction/research/public service"
	label define label_arank 7 "Total full-time Instruction/research/public service, Tenured total",add
	label define label_arank 1 "Total full-time Instruction/research/public service, Tenured, Professors",add
	label define label_arank 2 "Total full-time Instruction/research/public service, Tenured, Associate professors",add
	label define label_arank 3 "Total full-time Instruction/research/public service, Tenured, Assistant professors",add
	label define label_arank 4 "Total full-time Instruction/research/public service, Tenured, Instructors",add
	label define label_arank 5 "Total full-time Instruction/research/public service, Tenured, Lecturers",add
	label define label_arank 6 "Total full-time Instruction/research/public service, Tenured, No academic rank",add
	label define label_arank 14 "Total full-time Instruction/research/public service, Non-tenured on tenure track total",add
	label define label_arank 8 "Total full-time Instruction/research/public service, Non-tenured on tenure track, Professors",add
	label define label_arank 9 "Total full-time Instruction/research/public service, Non-tenured on tenure track, Associate professors",add
	label define label_arank 10 "Total full-time Instruction/research/public service, Non-tenured on tenure track, Assistant professors",add
	label define label_arank 11 "Total full-time Instruction/research/public service, Non-tenured on tenure track, Instructors",add
	label define label_arank 12 "Total full-time Instruction/research/public service, Non-tenured on tenure track, Lecturers",add
	label define label_arank 13 "Total full-time Instruction/research/public service, Non-tenured on tenure track, No academic rank",add
	label define label_arank 21 "Total full-time Instruction/research/public service, Non-tenured not on tenure track total",add
	label define label_arank 15 "Total full-time Instruction/research/public service, Non-tenured not on tenure track, Professors",add
	label define label_arank 16 "Total full-time Instruction/research/public service, Non-tenured not on tenure track, Associate professors",add
	label define label_arank 17 "Total full-time Instruction/research/public servicey, Non-tenured not on tenure track, Assistant professors",add
	label define label_arank 18 "Total full-time Instruction/research/public service, Non-tenured not on tenure track, Instructors",add
	label define label_arank 19 "Total full-time Instruction/research/public service, Non-tenured not on tenure track, Lecturers",add
	label define label_arank 20 "Total full-time Instruction/research/public service, Non-tenured not on tenure track, No academic rank",add
	label define label_arank 23 "Total full-time Instruction/research/public service, Without faculty status",add
	label values arank label_arank
	
	compress
	
	keep if arank == 22 | arank == 7 | arank == 14 //All full-time instructional staff & Tenured total
	
	keep unitid arank hrtotlt hrtotlm hrtotlw hraiant hrasiat hrbkaat hrhispt hrnhpit hrwhitt hr2mort hrunknt hrnralt
	rename hrtotlt totl
	rename hrtotlm male
	rename hrtotlw fema
	rename hraiant aian
	rename hrasiat asia
	rename hrbkaat bkaa
	rename hrhispt hisp
	rename hrnhpit nhpi
	rename hrwhitt whit
	rename hr2mort tmor
	rename hrunknt unkn
	rename hrnralt nral
	
	recode arank 22=1 7/14=2
	
	collapse (sum)totl-nral, by(unitid arank)
	reshape wide totl-nral, i(unitid) j(arank)
	
	foreach category in totl male fema whit bkaa hisp asia nhpi aspi aian tmor nral unkn{
		cap rename `category'1 is`category'
		cap rename `category'2 te`category'
	}
	
	rename istmor is2mor
	rename tetmor te2mor
	
	compress
	
	gen year = `yr'
	order year, a(unitid)
	save "$wdata/raw/IPEDS_Faculty`yr'.dta", replace
}
