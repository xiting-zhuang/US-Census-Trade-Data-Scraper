cd "R:\CAHNR_Steinbach\project\Xiting\census\"


!del "temp_export_*"
!del "exp_*"
set processors 5

filelist, dir("export")   norecur save("temp_datanames.dta") replace
use  temp_datanames, replace 

 

levelsof filename ,local(filelist) 
g ind = _n 
local max = _N

di `max' 


s

local counter = 0 
foreach i of local filelist{
local counter = `counter' + 1 
use "export/`i'", replace 

keep if comm_lvl == "HS6"
drop if port == "-"
drop if cty_code == "-"
g d = substr(cty_code, 2,3) 
drop if d == "XXX"
replace d = substr(cty_code, 1,2) 
drop if d == "00"

 
keep e_commodity  *_mo  time port  cty_code 
destring e_commodity  port  cty_code, replace 
keep     *_mo  time e_commodity  port  cty_code
save "temp_exp_loop_`counter'", replace 
}




use temp_exp_loop_1, replace 
forvalues i = 2/107{
append using "temp_exp_loop_`i'" , force 
}

 
 
save "census_export_hs6", replace 
s

g year =  yofd(dofm(time))
g m = month(dofm(time))
sort   cty_code port e_commodity  year  time
g air_val_mo = . 

bysort cty_code port e_commodity  year:  replace air_val_mo = air_val_yr[_n] - air_val_yr[_n-1]
replace air_val_mo = air_val_yr if  air_val_mo == . & m == 1 
order air_val_* yrm 








 






!del "temp_exp_loop_*" 



exit, STATA clear
 