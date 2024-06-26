clear
set more off

use "$wdata/analysis/IPEDS_Balanced_Panel.dta", clear

gen v1 = ftetotl if year == 2001
egen weight = mean(v1), by(unitid)

sort unitid year
by unitid: replace control = control[_n-1] if _n > 1
by unitid: replace icleve = icleve[_n-1] if _n > 1


gen institution = 0
replace institution = 1 if control == 1 & icleve == 4
replace institution = 2 if control == 2 & icleve == 4
replace institution = 3 if control == 3 & icleve == 4
replace institution = 4 if control == 1 & icleve == 2
replace institution = 5 if control == 2 & icleve == 2
replace institution = 6 if control == 3 & icleve == 2

*****************

collapse (mean)propfte* propis* [aweight=weight], by(institution year)
	

foreach category in whit bkaa hisp asia nhpi aspi aian 2mor unkn othe nral{

sum propfte`category'
local min_propfte`category' = r(min)
local max_propfte`category' = r(max)
sum propis`category'
local min_propis`category' = r(min)
local max_propis`category' = r(max)

if (`min_propfte`category'' <= `min_propis`category''){
	local min_`category' = `min_propfte`category''
}
else {
	local min_`category' = `min_propis`category''
}
if (`max_propfte`category'' >= `max_propis`category''){
	local max_`category' = `max_propfte`category''
}
else {
	local max_`category' = `max_propis`category''
}
	
if ((`max_`category'' - `min_`category'')/0.05 >= 5){
	local gap_`category' = 0.05
	local min_`category' = floor(`min_`category''/0.05)*0.05
	local max_`category' = ceil(`max_`category''/0.05)*0.05
	
}
if ((`max_`category'' - `min_`category'')/0.05 < 5) & ((`max_`category'' - `min_`category'')/0.03 >= 5){
	local gap_`category' = 0.03
	local min_`category' = floor(`min_`category''/0.03)*0.03
	local max_`category' = ceil(`max_`category''/0.03)*0.03
}
if ((`max_`category'' - `min_`category'')/0.03 < 5) & ((`max_`category'' - `min_`category'')/0.02 >= 5){
	local gap_`category' = 0.02
	local min_`category' = floor(`min_`category''/0.02)*0.02
	local max_`category' = ceil(`max_`category''/0.02)*0.02
}
if ((`max_`category'' - `min_`category'')/0.02 < 5){
	local gap_`category' = 0.01
	local min_`category' = floor(`min_`category''/0.01)*0.01
	local max_`category' = ceil(`max_`category''/0.01)*0.01
}

}

foreach category in whit bkaa hisp aspi aian othe nral{ //asia nhpi 2mor unkn 
	gen propgap`category' = propis`category' - propfte`category'

	if "`category'" == "whit"{
		local racenm "White"
	}
	if "`category'" == "bkaa"{
		local racenm "Black"
	}
	if "`category'" == "hisp"{
		local racenm "Hispanic"
	}
	if "`category'" == "asia"{
		local racenm "Asian"
	}
	if "`category'" == "nhpi"{
		local racenm "Native Hawaiian or Pacific Islander"
	}
	if "`category'" == "aspi"{
		local racenm "Asian and Pacific Islander"
	}
	if "`category'" == "aian"{
		local racenm "American Indian or Alaska Native"
	}
	if "`category'" == "2mor"{
		local racenm "Two or More Races"
	}
	if "`category'" == "unkn"{
		local racenm "Unknown Races"
	}
	if "`category'" == "othe"{
		local racenm "Two or More + Unknown Races"
	}
	if "`category'" == "nral"{
		local racenm "Non Resident Alien"
	}
	
	foreach var in gap { // fte is gap fte
		
		if "`var'" == "fte"{
			loc ytitle = "% `racenm' Students"
		}
		if "`var'" == "is"{
			loc ytitle = "% `racenm' Faculty"
		}
		if "`var'" == "gap"{
			loc ytitle = "Difference in % `racenm' F/S"
		}
		
		forv i = 1(1)6{
			sum prop`var'`category' if year == 2021 & institution == `i'
			local loc`i' = r(mean)
		}

		if "`var'" == "gap" & "`category'" == "aian"{
			local loc2 = `loc2' + 0.0005
		}
		if "`var'" == "gap" & "`category'" == "aspi"{
			local loc6 = `loc6' + 0.001
		}
		if "`var'" == "gap" & "`category'" == "aspi"{
			local loc4 = `loc4' - 0.001
		}
		if "`var'" == "gap" & "`category'" == "bkaa"{
			local loc2 = `loc2' + 0.002
		}
		if "`var'" == "gap" & "`category'" == "nral"{
			local loc4 = `loc4' + 0.001
		}
		if "`var'" == "gap" & "`category'" == "othe"{
			local loc2 = `loc2' + 0.002
		}
		if "`var'" == "gap" & "`category'" == "othe"{
			local loc4 = `loc4' - 0.002
		}
		if "`var'" == "gap" & "`category'" == "whit"{
			local loc5 = `loc5' + 0.005
		}
		if "`var'" == "fte" & "`category'" == "bkaa"{
			local loc1 = `loc1' + 0.005
		}
		if "`var'" == "fte" & "`category'" == "hisp"{
			local loc4 = `loc4' + 0.004
		}
		if "`var'" == "fte" & "`category'" == "hisp"{
			local loc6 = `loc6' - 0.002
		}
		if "`var'" == "fte" & "`category'" == "othe"{
			local loc2 = `loc2' + 0.002
		}
		if "`var'" == "fte" & "`category'" == "othe"{
			local loc4 = `loc4' - 0.002
		}
		if "`var'" == "fte" & "`category'" == "whit"{
			local loc4 = `loc4' + 0.007
		}
		if "`var'" == "is" & "`category'" == "aian"{
			local loc2 = `loc2' + 0.001
		}
		if "`var'" == "is" & "`category'" == "aian"{
			local loc1 = `loc1' + 0.001
		}
		if "`var'" == "is" & "`category'" == "aian"{
			local loc4 = `loc4' + 0.001
		}
		if "`var'" == "is" & "`category'" == "aian"{
			local loc6 = `loc6' - 0.001
		}
		if "`var'" == "is" & "`category'" == "aspi"{
			local loc4 = `loc4' + 0.003
		}
		if "`var'" == "is" & "`category'" == "bkaa"{
			local loc1 = `loc1' - 0.0004
		}
		if "`var'" == "is" & "`category'" == "hisp"{
			local loc5 = `loc5' - 0.0015
		}
		if "`var'" == "is" & "`category'" == "hisp"{
			local loc6 = `loc6' + 0.0015
		}
		if "`var'" == "is" & "`category'" == "nral"{
			local loc6 = `loc6' - 0.0004
		}
		if "`var'" == "is" & "`category'" == "othe"{
			local loc1 = `loc1' + 0.0008
		}
		if "`var'" == "is" & "`category'" == "whit"{
			local loc1 = `loc1' + 0.004
		}
		if "`var'" == "is" & "`category'" == "whit"{
			local loc4 = `loc4' + 0.004
		}
		if "`var'" == "is" & "`category'" == "whit"{
			local loc5 = `loc5' - 0.004
		}
		if "`var'" == "is" & "`category'" == "whit"{
			local loc6 = `loc6' - 0.004
		}
		
		
		loc format = "%4.2f"
		if "`category'" == "aian"{
			loc format = "%4.3f"
		}
		
		twoway 	(line prop`var'`category' year if institution == 1, lw(medthick) lc(black)) ///
				(line prop`var'`category' year if institution == 2, lw(medthick) lp(longdash) lc(gs2)) ///
				(line prop`var'`category' year if institution == 3, lw(medthick) lp(shortdash) lc(gs4)) ///
				(line prop`var'`category' year if institution == 4, lw(vthin) lc(gs6)) ///
				(line prop`var'`category' year if institution == 5, lw(vthin) lp(longdash) lc(gs8))  ///
				(line prop`var'`category' year if institution == 6, lw(vthin) lp(shortdash) lc(gs10)), ///
				legend(off) xscale(ra(2001 2027)) xlabel(2001(2)2021) ///
				ylabel(,angle(0) format(`format')) scheme(s1color) ///
				ytitle("`ytitle'") xtitle(Year) ///
				text(`loc1' 2021.25 "Public 4-year", place(e) size(small) color(black)) ///
				text(`loc2' 2021.25 "Non-profit 4-year", place(e) size(small) color(gs2)) ///
				text(`loc3' 2021.25 "For-profit 4-year", place(e) size(small) color(gs4)) ///
				text(`loc4' 2021.25 "Public 2-year", place(e) size(small) color(gs6)) ///
				text(`loc5' 2021.25 "Non-profit 2-year", place(e) size(small) color(gs8)) ///
				text(`loc6' 2021.25 "For-profit 2-year", place(e) size(small) color(gs10))
				
		graph export "$figure/Fig1_`category'.png", replace
	}
}
