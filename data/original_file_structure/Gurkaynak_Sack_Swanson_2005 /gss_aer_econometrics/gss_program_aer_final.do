version 7
capture log close
log using gss_results_aer_final.log, t replace 

*****************************************************************************
*                                                                           *  
*       Sensitivity of Long Term Interest Rates to Economic News:           *
*          Evidence and Implications for Macroeconomic Models               *
*                                                                           *
*                                                                           *
*         Program to generate the responses of forward rates to             *
*         monetary policy and other macroeconomic release surprises.        *
*                                                                           *
*         The code to create Table 1 and Figures 2 and 3 in the published   *
*         version of the paper.                                             *
*                                                                           *
*         Program is written fro STATA 7 or higher, Unix version.           *  
*                                                                           *
*     Code will crash because data file does not include expected values.   *
*                                                                           *
*                      SEE THE README FILE                                  *
*                                                                           *
*    Please e-mail Refet Gurkaynak at refet@bilkent.edu.tr for questions.   *
*                                                                           *
*    Dec. 17, 2004                                                          *
*                                                                           *
*****************************************************************************

!date


set mem 5m
set matsize 50

use gss_data_aer_final.dta

set more off


********************************************
***                                      ***
***     MACROECONOMIC DATA RELEASES      ***
***                                      ***
********************************************


****************************
*Generate Surprise Series  *
*Treat missing values and  *
*non release dates as zero *
*surprises.                *
*Normalize series by st.   *
*dev. of surprises.        *
****************************

for var *rel \ var *exp: gen Xspr=X-Y 
for var *spr: egen Xstdev=sd(X)
for var *spr: replace X=0 if X==.

for var *spr \ var *stdev: gen Xsd=X/Y


************************************************************
*Calculate monetary policy surprises in basis points       *
*Set mps=0 in days of employment report releases           *
*Note that Oct 15, 98 and Dec 18, 90 are treated as having *
*taken place one day later due to announcement time.       *
************************************************************

gen mps=mpspr
replace mps=0 if date=="12/07/90" | date=="02/01/91" | date=="03/08/91" | date=="07/05/91" | date=="12/06/91" | date=="07/02/92" | date=="09/04/92" | date=="02/04/94"

replace mps=mps*100

drop mpsprsd



*******************************************************************************
*Generate changes in forward rates.  These are first                          *     *differenced fwd rates, adjusted for missing variables due to holidays etc.   *
*Note the naming convention: chx is the forward rate beginning in x years.    * 
******************************************************************************* 

for num 0/14: gen chX=fwdX-fwdX[_n-1]\replace chX=fwdX-fwdX[_n-2] if fwdX~=. & fwdX[_n-1]==. \replace chX=fwdX[_n+1]-fwdX[_n-1] if fwdX==. & fwdX[_n-1]~=. \ replace chX=chX*100



*******************************************************************************
*Do STEPWISE REGRESSION of the response of 1 year yield (0yr fwd rate) for    *
*release shocks.  Start with all variables, drop the least significant until  *
*all remaining are significant at 1%.                                        *
*******************************************************************************

* Data from Sep.11-17, 2001 and retls dates oct01-jan02 omitted.    *

sw reg ch0 mps *sprsd if year<2003 & date~="01/15/02" & date~="12/13/01" &date~="11/14/01" &date~="10/12/01" & date~="09/11/01" &date~="09/12/01" & date~="09/13/01" & date~="09/14/01" & date~="09/15/01" & date~="09/16/01" & date~="09/17/01",r pr(0.01) 


********************************************************************************
**Keep the significant ones and add Core_PPI because it is very significant in *
**the longer run.                                                              *
**Also add the monteray policy surprises, in basis points.                     *
********************************************************************************


local macrosprsd "mps caparelsprsd cconfrelsprsd cpixferelsprsd ecicwrelsprsd gdpadvrelsprsd iclmrelsprsd ldersrelsprsd napmrelsprsd nhomesrelsprsd nfpayrelsprsd ppixferelsprsd retlsrelsprsd unemprelsprsd"

reg ch0 `macrosprsd' if year<2003 & date~="01/15/02" & date~="12/13/01" &date~="11/14/01" &date~="10/12/01" & date~="09/11/01" &date~="09/12/01" & date~="09/13/01" & date~="09/14/01" & date~="09/15/01" & date~="09/16/01" & date~="09/17/01",r



********************************************************************************
*Generate variables.  cX is coefficient of variable X, clX is the lower bound  *
*of 5% confidence interval and chX is the upper bound.                         *
* The variable years indexes the forward rate used.                            *
********************************************************************************

gen years=_n if _n<16

for var  `macrosprsd': gen cX=. \ gen clX=. \ gen chX=.


***Run the regressions for all forward rates and save coefficients.  Row 'n' has ***coefficient for forward rate 'n-1'.  

forvalues XX=0/14 {
reg ch`XX' `macrosprsd' if year<2003 & date~="01/15/02" & date~="12/13/01" &date~="11/14/01" &date~="10/12/01" & date~="09/11/01" &date~="09/12/01" & date~="09/13/01" & date~="09/14/01" & date~="09/15/01" & date~="09/16/01" & date~="09/17/01",r

for YY in var `macrosprsd': replace cYY=_b[YY] if _n==`XX'+1 \ replace clYY=_b[YY]-invttail((e(df_r)),0.025)*_se[YY] if _n==`XX'+1 \ replace chYY=_b[YY]+invttail((e(df_r)),0.025)*_se[YY] if _n==`XX'+1 
   }

*******************
* Generate graphs *
*******************

version 7

set textsize 135


graph clcconfrelsprsd ccconfrelsprsd chcconfrelsprsd years, yline (0) c(l[-]ll[-]) s(iii) ylabel xlabel(1, 3 to 15) b1("   Cons. Confidence")    b2("Years ahead") l1("Response of forward rates") gap(10) border key1("") saving(gcconfrelspr, replace) 

graph clretlsrelsprsd cretlsrelsprsd chretlsrelsprsd years, yline (0) c(l[-]ll[-]) s(iii) ylabel xlabel(1, 3 to 15) b1("    Retail Sales")    b2("Years ahead") l1("Response of forward rates") gap(10) border key1("") saving(gretlsrelspr, replace) 

graph clnapmrelsprsd cnapmrelsprsd chnapmrelsprsd years, yline (0) c(l[-]ll[-]) s(iii) ylabel xlabel(1, 3 to 15) b1("    NAPM (ISM)")    b2("Years ahead") l1("Response of forward rates") gap(10) border key1("") saving(gnapmrelspr, replace) 

graph cliclmrelsprsd ciclmrelsprsd chiclmrelsprsd years, yline (0) c(l[-]ll[-]) s(iii) ylabel xlabel(1, 3 to 15) b1("   Initial Claims")    b2("Years ahead") l1("Response of forward rates") gap(10) border key1("") saving(giclmrelspr, replace) 

graph clnfpayrelsprsd cnfpayrelsprsd chnfpayrelsprsd years, yline (0) c(l[-]ll[-]) s(iii) ylabel xlabel(1, 3 to 15) b1("   Nonfarm Payrolls")    b2("Years ahead") l1("Response of forward rates") gap(10) border key1("") saving(gnfpayrelspr, replace) 

graph clunemprelsprsd cunemprelsprsd chunemprelsprsd years, yline (0) c(l[-]ll[-]) s(iii) ylabel xlabel(1, 3 to 15) b1("   Unemployment")    b2("Years ahead") l1("Response of forward rates") gap(10) border key1("") saving(gunemprelspr, replace) 

graph clecicwrelsprsd cecicwrelsprsd checicwrelsprsd years, yline (0) c(l[-]ll[-]) s(iii) ylabel xlabel(1, 3 to 15) b1("    Emp. Cost Ind.")    b2("Years ahead") l1("Response of forward rates") gap(10) border key1("") saving(gecicwrelspr, replace) 

graph clcpixferelsprsd ccpixferelsprsd chcpixferelsprsd years, yline (0) c(l[-]ll[-]) s(iii) ylabel xlabel(1, 3 to 15) b1("   Core CPI")    b2("Years ahead") l1("Response of forward rates") gap(10) border key1("") saving(gcpixferelspr, replace) 

graph clppixferelsprsd cppixferelsprsd chppixferelsprsd years, yline (0) c(l[-]ll[-]) s(iii) ylabel xlabel(1, 3 to 15) b1("   Core PPI")    b2("Years ahead") l1("Response of forward rates") gap(10) border key1("") saving(gppixferelspr, replace) 



set textsize 85

graph using gcconfrelspr gretlsrelspr gnapmrelspr giclmrelspr gnfpayrelspr gunemprelspr gecicwrelspr gcpixferelspr gppixferelspr, margin(10) 

* print @Graph, xsize(7) ysize(9)
translate @Graph gss_figure_2.eps, xsize(7) ysize(9) replace

set textsize 100


*********************************************
*  Do the monetary policy surprise graph    *
* *******************************************  

graph clmps cmps chmps years, yline(0) c(l[-]ll[-]) s(iii) ylabel xlabel(1, 3 to 15) xscale(1,14) l1("Response of forward rates") b2("Years ahead") gap(2) border key1(" ")
translate @Graph gss_figure_3.eps, replace





log close
