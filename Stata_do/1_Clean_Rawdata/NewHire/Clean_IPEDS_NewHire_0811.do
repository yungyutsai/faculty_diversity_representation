clear
set more off

forv yr = 2008(1)2011{
	insheet using "$rdata/IPEDS/staff/s`yr'_g_data_stata.csv", comma clear

	label variable unitid   "Unique identification number of the institution"
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
	
	keep if sgtype == 1 | sgtype == 2 | sgtype == 3 | sgtype == 4 //Instruction/research/public service staff total; tenured Faulty; tenured track faculty
	
	recode sgtype (1=0)(2=1)(3/4=2)
	
	keep unitid sgtype hrtotlt hrtotlm hrtotlw hraiant hrasiat hrbkaat hrhispt hrnhpit hrwhitt hr2mort hrunknt hrnralt
	
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
	
	collapse (sum)totl-nral, by(unitid sgtype)
	
	reshape wide totl-nral, i(unitid) j(sgtype)

	foreach category in totl male fema whit bkaa hisp asia nhpi aspi aian tmor nral unkn{
		cap drop `category'0 //Keep the unitid, because they report new hired data, and probably just because they do not hire ne faculty
		cap rename `category'1 nhis`category'
		cap recode nhis`category' . = 0
		cap rename `category'2 nhte`category'
		cap recode nhte`category' . = 0
	}
		
	rename nhistmor nhis2mor
	rename nhtetmor nhte2mor
	
	compress
	
	gen year = `yr'
	order year, a(unitid)
	save "$wdata/raw/IPEDS_NewHired`yr'.dta", replace
}
