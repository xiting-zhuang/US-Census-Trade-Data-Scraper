*********************************************
***********Sate-level Export Data************
*********************************************
**********Version: December 28, 2021***********
*********************************************
*********************************************
set processors 1
clear all
cd "R:\CAHNR_Steinbach\project\Xiting\census\import"
*!sort and refine the state-level export data of each month for two state-parts

local var2 "PORT"
local var "I_COMMODITY,I_COMMODITY_LDESC,I_COMMODITY_SDESC,AIR_VAL_YR,AIR_VAL_MO,AIR_WGT_MO,AIR_WGT_YR,GEN_VAL_MO,GEN_VAL_YR,CNT_VAL_MO,CNT_VAL_YR,CNT_WGT_MO,CNT_WGT_YR,VES_VAL_MO,VES_VAL_YR,VES_WGT_MO,VES_WGT_YR,YEAR,COMM_LVL,CTY_CODE,CTY_NAME,LAST_UPDATE,MONTH,PORT_NAME,SUMMARY_LVL"
/*
*local month 01 02 03 04 05 06 07 08 09 10  
local month   04   

forvalues j = 2013(1)2013{
foreach i of local month{
*/





// set up sample macros
local year   2019  
local month  05   

// how many words (show check both X and Y and compare)
local n : word count `year'

// loop through the pairs of words
 forvalues count = 1/`n' {
     local j : word `count' of `year'
     local i : word `count' of `month'

capture: copy "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=`var2'&time=`j'-`i'&key=54fde0748a218a72c6452cd24445afc2ee0fca2a" "imp_`j'_`i'.json"
capture: import delimited "imp_`j'_`i'.json",varnames(1) clear
replace port = subinstr(port,`"[""', "",.)
replace port = subinstr(port, `"""', "",.)
levelsof port ,local(port_loop)
di `port_loop'

use "../blankdata_import", replace 
foreach port of local port_loop{
preserve 
capture: copy "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=`var'&time=`j'-`i'&PORT=`port'&key=54fde0748a218a72c6452cd24445afc2ee0fca2a" "imp_`j'_`i'.json"
	capture: import delimited "imp_`j'_`i'.json",varnames(1) clear

	capture tostring port, replace 
	replace port = subinstr(port,`"[""', "",.)
	replace port = subinstr(port, `"""', "",.)
	replace port = subinstr(port, `""]"', "",.)
	replace port = subinstr(port, `"]"', "",.)
	replace port = subinstr(port,`""]"', "",.)

	replace port = "0" + port if strlen(port) == 3 
	save "temp_import_`j'_`i'", replace 
restore 
append using "temp_import_`j'_`i'", force
}


replace i_commodity = subinstr(i_commodity, `"[""', "",.)
replace i_commodity = subinstr(i_commodity, `"""', "",.)
replace time = subinstr(time, `""]"', "",.)
replace time = subinstr(time, `""]]"', "",.)
replace time = subinstr(time, "-", "/",.)
 
 
capture drop date
gen date = monthly(time, "YM")
format %tmNN/CCYY date
drop time
rename date time
capture tostring  port , replace 
replace port = "0" if strlen(port) == 3 
compress	

save "`j'`i'.dta", replace

erase "imp_`j'_`i'.json"
erase "temp_import_`j'_`i'.dta"

}
 s
clear all 




s


local var2 "PORT"
local var "I_COMMODITY,I_COMMODITY_LDESC,I_COMMODITY_SDESC,AIR_VAL_YR,AIR_VAL_MO,AIR_WGT_MO,AIR_WGT_YR,GEN_VAL_MO,GEN_VAL_YR,CNT_VAL_MO,CNT_VAL_YR,CNT_WGT_MO,CNT_WGT_YR,VES_VAL_MO,VES_VAL_YR,VES_WGT_MO,VES_WGT_YR,YEAR,COMM_LVL,CTY_CODE,CTY_NAME,LAST_UPDATE,MONTH,PORT,PORT_NAME,SUMMARY_LVL"
local month 01 02 03  12

forvalues j = 2021(1)2021{
foreach i of local month{

capture: copy "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=`var2'&time=`j'-`i'&key=54fde0748a218a72c6452cd24445afc2ee0fca2a" "imp_`j'_`i'.json"
capture: import delimited "imp_`j'_`i'.json",varnames(1) clear
replace port = subinstr(port,`"[""', "",.)
replace port = subinstr(port, `"""', "",.)
levelsof port ,local(port_loop)
di `port_loop'

use "../blankdata_import", replace 
foreach port of local port_loop{
preserve 
capture: copy "https://api.census.gov/data/timeseries/intltrade/imports/porths?get=`var'&time=`j'-`i'&PORT=`port'&key=54fde0748a218a72c6452cd24445afc2ee0fca2a" "imp_`j'_`i'.json"
	capture: import delimited "imp_`j'_`i'.json",varnames(1) clear
	capture drop port 
	g port = "`port'"
	save "temp_import_`j'_`i'", replace 
restore 
append using "temp_import_`j'_`i'", force
}


replace i_commodity = subinstr(i_commodity, `"[""', "",.)
replace i_commodity = subinstr(i_commodity, `"""', "",.)
replace time = subinstr(time, `""]"', "",.)
replace time = subinstr(time, `""]]"', "",.)
replace time = subinstr(time, "-", "/",.)
 
 
capture drop date
gen date = monthly(time, "YM")
format %tmNN/CCYY date
drop time
rename date time
 
compress	


save "`j'`i'.dta", replace

erase "imp_`j'_`i'.json"
erase "temp_import_`j'_`i'.dta"

}
}

