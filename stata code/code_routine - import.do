cd "R:\CAHNR_Steinbach\project\Xiting\census\"

set processors 5

filelist, dir("import")   norecur save("temp_datanames1.dta") replace
use  temp_datanames1, replace 
levelsof filename ,local(filelist) 
g ind = _n 
local max = _N

local counter = 0 
foreach i of local filelist{
local counter = `counter' + 1 
use "import/`i'", replace 

keep if comm_lvl == "HS6"
drop if port == "-"
drop if cty_code == "-"
 
g d = substr(cty_code, 2,3) 
drop if d == "XXX"
replace d = substr(cty_code, 1,2) 
drop if d == "00"

destring i_commodity port  cty_code ,replace 
keep i_commodity  *_mo  time port  cty_code 
save "temp_imp_loop_`counter'", replace 
}

use temp_imp_loop_1, replace 
forvalues i = 2/`max'{
append using "temp_imp_loop_`i'" , force 
}
 

save "census_import_hs6", replace 
 s
 s
exit, STATA clear

  