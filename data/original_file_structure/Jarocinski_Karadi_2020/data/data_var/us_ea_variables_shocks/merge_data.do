* 1) convert files to .dta

import delimited using "us_shocks.csv", varnames(1) clear
gen dm = ym(year,month), before(year)
format dm %tm
drop year month
save us_shocks.dta, replace

import delimited using "us_variables.csv", varnames(1) clear
gen dm = ym(year,month), before(year)
format dm %tm
drop year month
save us_variables.dta, replace

import delimited using "ea_shocks.csv", varnames(1) clear
gen dm = ym(year,month), before(year)
format dm %tm
drop year month
save ea_shocks.dta, replace

import delimited using "ea_variables.csv", varnames(1) clear
gen dm = ym(year,month), before(year)
format dm %tm
drop year month
save ea_variables.dta, replace


* 2) merge
use us_shocks.dta, clear
merge 1:1 dm using us_variables.dta, nogenerate
merge 1:1 dm using ea_shocks.dta, nogenerate
merge 1:1 dm using ea_variables, nogenerate

!del *.dta
sort dm

gen year = year(dofm(dm))
gen month = month(dofm(dm))
order year month 
drop dm
export delimited using "../data.csv", delimiter(",") replace
