cd "R:\CAHNR_Steinbach\project\Xiting\census\export"

local year     2013 2014 2015 2016 2017 2018 2019 2020 2021 
local month       01 02 03 04 05 06 07 08 09 10 11 12       

// how many words (show check both X and Y and compare)
local n : word count `year'

// loop through the pairs of words
 forvalues count = 1/`n' {
     local j : word `count' of `year'
     local i : word `count' of `month'

capture	use "`j'`i'.dta", replace
 	sort   cty_code port time e_commodity
 	quietly by cty_code port time e_commodity:  gen dup = cond(_N==1,0,_n)
capture	keep if dup >= 1 
capture	save "temp_check_exp_`j'`i'", replace 

di "`j'`i'"
 
}


 
 
 
 
 cd "R:\CAHNR_Steinbach\project\Xiting\census\import"

// set up sample macros
local year     2013 2014 2015 2016 2017 2018 2019 2020 2021 
local month       01 02 03 04 05 06 07 08 09 10 11 12
// how many words (show check both X and Y and compare)
local n : word count `year'

// loop through the pairs of words
 forvalues count = 1/`n' {
     local j : word `count' of `year'
     local i : word `count' of `month'

  
	capture 	use "`j'`i'.dta", replace


 
capture	sort   cty_code port time i_commodity
capture	quietly by cty_code port time i_commodity:  gen dup = cond(_N==1,0,_n)
capture	keep if dup >= 1 
capture	save "temp_check_imp_`j'`i'", replace 

di "`j'`i'"
}




s
!del "temp_check_imp_*"
!del "temp_check_exp_*"

