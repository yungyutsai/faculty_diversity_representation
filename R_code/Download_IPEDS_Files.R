library(xml2)     # for funtion "read_html"
library(rvest)    # for function "html_attr","html_table"
library(stringr)  # for function "str_detect"

rm(list=ls())

for(i in c(2001:2021)){
  url <- paste0("https://nces.ed.gov/ipeds/datacenter/data/EAP",i,".zip")
  destfile <- paste0("/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata/IPEDS/staff/eap",i,"_data_stata.zip")
  download.file(url,destfile)
}

for(i in c(2012:2020)){
  url <- paste0("https://nces.ed.gov/ipeds/datacenter/data/S",i,"_OC_Data_Stata.zip")
  destfile <- paste0("/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata/IPEDS/staff/s",i,"_oc_data_stata.zip")
  download.file(url,destfile)
  url <- paste0("https://nces.ed.gov/ipeds/datacenter/data/S",i,"_IS_Data_Stata.zip")
  destfile <- paste0("/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata/IPEDS/staff/s",i,"_is_data_stata.zip")
  url <- paste0("https://nces.ed.gov/ipeds/datacenter/data/S",i,"_SIS_Data_Stata.zip")
  destfile <- paste0("/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata/IPEDS/staff/s",i,"_sis_data_stata.zip")
  url <- paste0("https://nces.ed.gov/ipeds/datacenter/data/S",i,"_NH_Data_Stata.zip")
  destfile <- paste0("/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata/IPEDS/staff/s",i,"_nh_data_stata.zip")
  download.file(url,destfile)
}
for(i in c(2001:2011)){
  url <- paste0("https://nces.ed.gov/ipeds/datacenter/data/S",i,"_ABD_Data_Stata.zip")
  destfile <- paste0("/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata/IPEDS/staff/s",i,"_oc1_data_stata.zip")
  download.file(url,destfile)
  url <- paste0("https://nces.ed.gov/ipeds/datacenter/data/S",i,"_CN_Data_Stata.zip")
  destfile <- paste0("/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata/IPEDS/staff/s",i,"_oc2_data_stata.zip")
  download.file(url,destfile)
  url <- paste0("https://nces.ed.gov/ipeds/datacenter/data/S",i,"_F_Data_Stata.zip")
  destfile <- paste0("/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata/IPEDS/staff/s",i,"_is_data_stata.zip")
  download.file(url,destfile)
  url <- paste0("https://nces.ed.gov/ipeds/datacenter/data/S",i,"_G_Data_Stata.zip")
  destfile <- paste0("/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata/IPEDS/staff/s",i,"_nh_data_stata.zip")
  download.file(url,destfile)
}

# Untar
setwd("/Users/yungyu/Dropbox/02 Research/education/student_faculty_diversity/data/rawdata/IPEDS/staff/")
zipfiles <- list.files(getwd(),"\\.zip{1,}",full.names =T)
path.list<-lapply(zipfiles,function(k){
  untar(k)  
  file.remove(k)
})
rvfiles <- list.files(getwd(),"*rv*",full.names =T)
path.list<-lapply(rvfiles,function(k){
  file.remove(k)
})