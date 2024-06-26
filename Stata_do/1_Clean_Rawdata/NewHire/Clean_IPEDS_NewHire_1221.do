clear
set more off

forv yr = 2012(1)2021{
	insheet using "$rdata/IPEDS/staff/s`yr'_nh_data_stata.csv", comma clear

	label variable unitid   "Unique identification number of the institution"
	label variable snhcat   "Staff category"
	label variable occupcat "Occupation"
	label variable facstat  "Faculty and tenure status"
	label variable sgtype   "Old new hire categories that are consitent with new codes"
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
	cap label define label_snhcat 10000 "All full-time new hires"
	cap label define label_snhcat 20000 "Instructional, research and public service",add
	cap label define label_snhcat 21000 "Instructional staff",add
	cap label define label_snhcat 21010 "Instructional staff with faculty status, total",add
	cap label define label_snhcat 21020 "Instructional staff with faculty status, Tenured",add
	cap label define label_snhcat 21030 "Instructional staff with faculty status, On Tenure Track",add
	cap label define label_snhcat 21040 "Instructional staff with faculty status, Not on Tenure Track/No Tenure system",add
	cap label define label_snhcat 21042 "Instructional staff with faculty status, Not on Track/No Tenure sys, annual contract",add
	cap label define label_snhcat 21043 "Instructional staff with faculty status, Not on Track/No Tenure sys, less-than-annual contract",add
	cap label define label_snhcat 21041 "Instructional staff with faculty status, Not on Track/No Tenure sys, multi-year and indefinite contracts",add
	cap label define label_snhcat 21044 "Instructional staff with faculty status, not on Tenure/No Tenure sys, multi-year contract",add
	cap label define label_snhcat 21045 "Instructional staff with faculty status, not on Tenure/No Tenure sys, indefinite contract",add
	cap label define label_snhcat 21050 "Instructional staff without faculty status",add
	cap label define label_snhcat 22000 "Research",add
	cap label define label_snhcat 23000 "Public service",add
	cap label define label_snhcat 25000 "Library and Student and Academic Affairs and Other Education Services",add
	cap label define label_snhcat 30000 "Management Occupations",add
	cap label define label_snhcat 31000 "Business and Financial Operations",add
	cap label define label_snhcat 32000 "Computer, Engineering, and Science",add
	cap label define label_snhcat 33000 "Community, Social Service, Legal, Arts,Design, Entertainment, Sports and Media",add
	cap label define label_snhcat 34000 "Healthcare Practioners and Technical",add
	cap label define label_snhcat 35000 "Service occupations",add
	cap label define label_snhcat 36000 "Sales and related occupations",add
	cap label define label_snhcat 37000 "Office and Administrative Support",add
	cap label define label_snhcat 38000 "Natural Resources, Construction, and Maintenance",add
	cap label define label_snhcat 39000 "Production, Transportation, and Material Moving",add
	label values snhcat label_snhcat
	cap label define label_occupcat 100 "All full-time new hires"
	cap label define label_occupcat 200 "Instructional, research and public service staff",add
	cap label define label_occupcat 210 "Instructional staff",add
	cap label define label_occupcat 220 "Research",add
	cap label define label_occupcat 230 "Public service",add
	cap label define label_occupcat 250 "Librarians/Library Technicians/Archivists and Curators, and Museum technicians/Student and Academic Affairs and Other Education Services",add
	cap label define label_occupcat 300 "Management",add
	cap label define label_occupcat 310 "Business and Financial Operations",add
	cap label define label_occupcat 320 "Computer, Engineering, and Science",add
	cap label define label_occupcat 330 "Community, Social Service, Legal, Arts,Design, Entertainment, Sports and Media",add
	cap label define label_occupcat 340 "Healthcare Practioners and Technical",add
	cap label define label_occupcat 350 "Service Occupations",add
	cap label define label_occupcat 360 "Sales and Related Occupations",add
	cap label define label_occupcat 370 "Office and Administrative Support",add
	cap label define label_occupcat 380 "Natural Resources, Construction, and Maintenance",add
	cap label define label_occupcat 390 "Production, Transportation, and Material Moving",add
	cap label values occupcat label_occupcat
	cap label define label_facstat 0 "All full-time new hires"
	cap label define label_facstat 10 "With faculty status, total",add
	cap label define label_facstat 20 "With faculty status, tenured",add
	cap label define label_facstat 30 "With faculty status, on tenure track",add
	cap label define label_facstat 40 "With faculty status not on tenure track/No tenure system, total",add
	cap label define label_facstat 41 "With faculty status not on tenure track/No tenure system, multi-year and indefinite contract",add
	cap label define label_facstat 44 "With faculty status not on tenure track/No tenure system, multi-year contract",add
	cap label define label_facstat 45 "With faculty status not on tenure track/No tenure system, indefinite contract",add
	cap label define label_facstat 42 "With faculty status not on tenure track/No tenure system, annual contract",add
	cap label define label_facstat 43 "With faculty status not on tenure track/No tenure system, less-than-annual contract",add
	cap label define label_facstat 50 "Without faculty status",add
	cap label values facstat label_facstat
	cap label define label_sgtype 1 "Full-time new hires (New hire code prior to 2012)"
	cap label define label_sgtype 2 "Full-time postecondary teachers (occupation code prior to 2012)",add
	cap label define label_sgtype -2 "Not applicable, current occupation does not map to occupations prior to 2012",add
	label values sgtype label_sgtype
	
	compress
	
	keep if occupcat == 100 | snhcat == 21000 | snhcat == 21020 | snhcat == 21030
	
	recode snhcat (10000=0)(21000=1)(21020/21030=2)
	
	keep unitid snhcat hrtotlt hrtotlm hrtotlw hraiant hrasiat hrbkaat hrhispt hrnhpit hrwhitt hr2mort hrunknt hrnralt
	
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
	
	collapse (sum)totl-nral, by(unitid snhcat)

	reshape wide totl-nral, i(unitid) j(snhcat)

	foreach category in totl male fema whit bkaa hisp asia nhpi aspi aian tmor nral unkn{
		cap drop `category'0 //Keep the unitid, because they report new hired data, and probably just because they do not hire nwe faculty
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
