clear
set more off

forv yr = 2012(1)2021{
	insheet using "$rdata/IPEDS/staff/s`yr'_is_data_stata.csv", comma clear

	label variable unitid   "Unique identification number of the institution"
	label variable siscat   "Instructional staff category"
	label variable facstat  "Faculty and tenure status"
	label variable arank    "Academic rank"
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
	label define label_siscat 1 "All full-time instructional staff"
	label define label_siscat 100 "Instructional staff with faculty status",add
	label define label_siscat 101 "Instructional staff, professors",add
	label define label_siscat 102 "Instructional staff, associate professors",add
	label define label_siscat 103 "Instructional staff, assistant professors",add
	label define label_siscat 104 "Instructional staff, instructors",add
	label define label_siscat 105 "Instructional staff, lecturers",add
	label define label_siscat 106 "Instructional staff, no academic rank",add
	label define label_siscat 200 "Tenured total",add
	label define label_siscat 201 "Tenured, professors",add
	label define label_siscat 202 "Tenured, associate professors",add
	label define label_siscat 203 "Tenured, assistant professors",add
	label define label_siscat 204 "Tenured, instructors",add
	label define label_siscat 205 "Tenured, lecturers",add
	label define label_siscat 206 "Tenured, no academic rank",add
	label define label_siscat 300 "On-Tenure track total",add
	label define label_siscat 301 "On-tenure track, professors",add
	label define label_siscat 302 "On-tenure track, associate professors",add
	label define label_siscat 303 "On-tenure track, assistant professors",add
	label define label_siscat 304 "On-tenure track, instructors",add
	label define label_siscat 305 "On-tenure track, lecturers",add
	label define label_siscat 306 "On-tenure track, no academic rank",add
	label define label_siscat 400 "Not on tenure track/No tenure system system total",add
	label define label_siscat 401 "Not on tenure/no tenure system, professors",add
	label define label_siscat 402 "Not on tenure/no tenure system, associate professors",add
	label define label_siscat 403 "Not on tenure/no tenure system, assistant professors",add
	label define label_siscat 404 "Not on tenure/no tenure system, instructors",add
	label define label_siscat 405 "Not on tenure/no tenure system, lecturers",add
	label define label_siscat 406 "Not on tenure/no tenure system, no academic rank",add
	label define label_siscat 410 "Not on tenure track/no tenure system, multi-year and indefinite contracts, total",add
	label define label_siscat 411 "Not on tenure track/no tenure system, multi-year and indefinite contracts, professors",add
	label define label_siscat 412 "Not on tenure track/no tenure system, multi-year and indefinite contracts, asssociate professors",add
	label define label_siscat 413 "Not on tenure track/no tenure system, multi-year and indefinite contracts, assistant professors",add
	label define label_siscat 414 "Not on tenure track/no tenure system, multi-year and indefinite contracts, instructors",add
	label define label_siscat 415 "Not on tenure track/no tenure system, multi-year and indefinite contracts contract,lecturers",add
	label define label_siscat 416 "Not on tenure track/no tenure system, multi-year and indefinite contracts, no academic rank",add
	label define label_siscat 420 "Not on tenure track/no tenure system, annual contract, total",add
	label define label_siscat 421 "Not on tenure track/no tenure system, annual contract, professors",add
	label define label_siscat 422 "Not on tenure track/no tenure system, annual contract, asssociate professors",add
	label define label_siscat 423 "Not on tenure track/no tenure system, annual contract, assistant professors",add
	label define label_siscat 424 "Not on tenure track/no tenure system, annual contract, instructors",add
	label define label_siscat 425 "Not on tenure track/no tenure system, annual contract,lecturers",add
	label define label_siscat 426 "Not on tenure track/no tenure system, annual contract, no academic rank",add
	label define label_siscat 430 "Not on tenure track/no tenure system, less-than-annual contract, total",add
	label define label_siscat 431 "Not on tenure track/no tenure system, less-than-annual contract, professors",add
	label define label_siscat 432 "Not on tenure track/no tenure system, less-than-annual contract, asssociate professors",add
	label define label_siscat 433 "Not on tenure track/no tenure system, less-than-annual contract, assistant professors",add
	label define label_siscat 434 "Not on tenure track/no tenure system, less-than-annual contract, instructors",add
	label define label_siscat 435 "Not on tenure track/no tenure system, less-than-annual contract,lecturers",add
	label define label_siscat 436 "Not on tenure track/no tenure system, less-than-annual contract, no academic rank",add
	label define label_siscat 440 "Not on tenure track/no tenure system, multi-year contract, total",add
	label define label_siscat 441 "Not on tenure track/no tenure system, multi-year contract, professors",add
	label define label_siscat 442 "Not on tenure track/no tenure system, multi-year contract, associate professors",add
	label define label_siscat 443 "Not on tenure track/no tenure system, multi-year contract, assistant professors",add
	label define label_siscat 444 "Not on tenure track/no tenure system, multi-year contract, instructors",add
	label define label_siscat 445 "Not on tenure track/no tenure system, multi-year contract, lecturers",add
	label define label_siscat 446 "Not on tenure track/no tenure system, multi-year contract, no academic rank",add
	label define label_siscat 450 "Not on tenure track/no tenure system, multi-year contract, total",add
	label define label_siscat 451 "Not on tenure track/no tenure system, indefinite contract, professors",add
	label define label_siscat 452 "Not on tenure track/no tenure system, indefinite contract, associate professors",add
	label define label_siscat 453 "Not on tenure track/no tenure system, indefinite contract, assistant professors",add
	label define label_siscat 454 "Not on tenure track/no tenure system, indefinite contract, instructors",add
	label define label_siscat 455 "Not on tenure track/no tenure system, indefinite contract, lecturers",add
	label define label_siscat 456 "Not on tenure track/no tenure system, indefinite contract, no academic rank",add
	label define label_siscat 500 "Without faculty status",add
	label values siscat label_siscat
	label define label_facstat 0 "All full-time instructional staff"
	label define label_facstat 10 "With faculty status, total",add
	label define label_facstat 20 "With faculty status, tenured",add
	label define label_facstat 30 "With faculty status, on tenure track",add
	label define label_facstat 40 "With faculty status not on tenure track/No tenure system, total",add
	label define label_facstat 41 "With faculty status not on tenure track/No tenure system, multi-year and indefinite contract",add
	label define label_facstat 44 "With faculty status not on tenure track/No tenure system, multi-year contract",add
	label define label_facstat 45 "With faculty status not on tenure track/No tenure system, indefinite contract",add
	label define label_facstat 42 "With faculty status not on tenure track/No tenure system, annual contract",add
	label define label_facstat 43 "With faculty status not on tenure track/No tenure system, less-than-annual contract",add
	label define label_facstat 50 "Without faculty status",add
	label values facstat label_facstat
	label define label_arank 0 "All ranks"
	label define label_arank 1 "Professors",add
	label define label_arank 2 "Associate professors",add
	label define label_arank 3 "Assistant professors",add
	label define label_arank 4 "Instructors",add
	label define label_arank 5 "Lecturers",add
	label define label_arank 6 "No academic rank",add
	label values arank label_arank
	
	compress
	
	keep if siscat == 1 | siscat == 200 | siscat == 300 //All full-time instructional staff & Tenured total
	
	keep unitid siscat hrtotlt hrtotlm hrtotlw hraiant hrasiat hrbkaat hrhispt hrnhpit hrwhitt hr2mort hrunknt hrnralt
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

	recode siscat 200/300=2
	
	collapse (sum)totl-nral, by(unitid siscat)
	reshape wide totl-nral, i(unitid) j(siscat)
	
	foreach category in totl male fema whit bkaa hisp asia nhpi aspi aian tmor nral unkn{
		cap rename `category'1 pis`category'
		cap rename `category'2 te`category'
	}
	
	rename pistmor pis2mor
	rename tetmor te2mor
	
	compress
	
	gen year = `yr'
	order year, a(unitid)
	save "$wdata/raw/IPEDS_Faculty`yr'.dta", replace
}
