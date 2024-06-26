if "`c(username)'" == "yungyu" {
	global rdata = "/Users/yungyu/Dropbox/02 Research/education/faculty_diversity_representation/data/rawdata"
	global wdata = "/Users/yungyu/Dropbox/02 Research/education/faculty_diversity_representation/data/workdata"
	global do = "/Users/yungyu/Dropbox/02 Research/education/faculty_diversity_representation/data/Stata_do"
	global table = "/Users/yungyu/Dropbox/02 Research/education/faculty_diversity_representation/data/table"
	global figure = "/Users/yungyu/Dropbox/02 Research/education/faculty_diversity_representation/data/figure"
}

** Clean IPEDS raw data
do "$do/1_Clean_Rawdata/Enrollment/Clean_IPEDS_Enrollment_0001.do" //Year 2000 to 2001
do "$do/1_Clean_Rawdata/Enrollment/Clean_IPEDS_Enrollment_0221.do" //Year 2002 to 2021

do "$do/1_Clean_Rawdata/Faculty/Clean_IPEDS_Faculty_0107.do" //Year 2001 to 2007
do "$do/1_Clean_Rawdata/Faculty/Clean_IPEDS_Faculty_0811.do" //Year 2008 to 2011
do "$do/1_Clean_Rawdata/Faculty/Clean_IPEDS_Faculty_1221.do" //Year 2012 to 2021

do "$do/1_Clean_Rawdata/Head/Clean_IPEDS_Head_0001.do" //Year 2000 to 2001
do "$do/1_Clean_Rawdata/Head/Clean_IPEDS_Head_0203.do" //Year 2002 to 2003
do "$do/1_Clean_Rawdata/Head/Clean_IPEDS_Head_0420.do" //Year 2004 to 2021

do "$do/1_Clean_Rawdata/NewHire/Clean_IPEDS_NewHire_0107.do" //Year 2001 to 2007
do "$do/1_Clean_Rawdata/NewHire/Clean_IPEDS_NewHire_0811.do" //Year 2008 to 2011
do "$do/1_Clean_Rawdata/NewHire/Clean_IPEDS_NewHire_1221.do" //Year 2012 to 2021

** Clean NCES raw data
do "$do/1_Clean_Rawdata/Projection/1_enrollment.do"

** Clean Census Bureau raw data
do "$do/1_Clean_Rawdata/Projection/2_population.do"

** Build Data
do "$do/2_Build_Data/1_append_and_merge.do"
do "$do/2_Build_Data/2_sample_selection.do"
do "$do/2_Build_Data/3_predict_enrollment.do"
do "$do/2_Build_Data/4_predict_enrollment_race.do"
do "$do/2_Build_Data/5_predict_hire.do"
do "$do/2_Build_Data/6_simulation.do"

** Tables & Figures
do "$do/3_Analysis/Fig1.do"
do "$do/3_Analysis/Fig2.do"
do "$do/3_Analysis/Fig3.do"
do "$do/3_Analysis/Tab1.do"
do "$do/3_Analysis/Tab2.do"
do "$do/3_Analysis/Tab4.do"
do "$do/3_Analysis/FigA1.do"
do "$do/3_Analysis/FigA2.do"
do "$do/3_Analysis/FigA3.do"
do "$do/3_Analysis/FigB1.do"
do "$do/3_Analysis/FigB2.do"
do "$do/3_Analysis/FigB3.do"
do "$do/3_Analysis/FigC1.do"
do "$do/3_Analysis/FigC2.do"
do "$do/3_Analysis/TabC1.do"
