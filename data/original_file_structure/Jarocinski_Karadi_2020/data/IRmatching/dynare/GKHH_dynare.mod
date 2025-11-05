parameters  varphi sig alfa delta GoverY eta_i epsilon gam hh gam_P kappaPi 
            sigma_ksi sigma_ir sigma_a sigma_betta rhoKsi rhoIr 
            kappaX rhoShockIr rhoA rhoShockBetta kappa sh rhoG sigma_g 
            omega theta chi Shbar varrho_kx 
            varrho_x varrho_1
            Y_ss K_ss S_ss D_ss L_ss I_ss C_ss Q_ss varrho_ss Lambda_ss Z_ss w_ss N_ss Ne_ss Rk_ss R_ss prem_K_ss phi_ss Omega_ss pm_ss X_ss ir_ss 
            betta_ss Sh_ss G_ss Rkx_ss Qx_ss ykx_ss qx_ss yx_ss q1_ss y1_ss ir_ann_ss y1_ann_ss Y_ann_ss
            ksi_ss infl_ss a_ss shockIr_ss shockBetta_ss g_ss ebp_ss ebp_ann_ss;

var Y K S D L I C Q varrho Lambda Z w N Ne Rk R prem_K phi Omega pm X ir 
            betta Sh G Rkx Qx ykx qx yx q1 y1 ir_ann y1_ann Y_ann 
            ksi infl a shockIr shockBetta g ebp ebp_ann;

varexo e_ksi e_a e_ir e_betta e_g;


% Targeted moments
LMom    =   1/3;        %Steady state labor supply
RkmRMom =   0.01/4;     %steady state premium (quarterly)
phiMom  =   6;          %steady state leverage
dxMom   =   6.5;        %Duration of the excess bond premium
d1Mom   =   0.99;

%Setting parameters
betta_ss=   0.99;       %Discount rate
varphi  =   0.276;      %Inverse Frisch elasticity of labor supply       
hh      =   0.815;      %Household habit parameter

sig   =   0.97155955;   %The bankers' survival probability

alfa    =   0.33;       %Capital share
delta   =   0.025;      %Depreciation rate
GoverY  =   0.2;        %Government expenditures over GDP
eta_i   =   1.728;      %elasticity of capital adjusment cost
kappa   =   0.12546849;  %0.14191600;  %5e-3;       %HH portfolio adjustment cost
sh      =   0.5;        %Relative steady state HH holding of debt

%Retail firms
epsilon =   4.167;      %Elasticity of substitution between goods %problem with 1: C-D
gam     =   0.71807836;  %0.61110637;  %0.779;      %Calvo parameter
gam_P   =   0.00001273;          %Indexation parameter

%Monetary Policy parameters
rhoIr  =   0;  %0.85;       %Taylor rule smoothing coefficient
kappaPi=   1.5;             %Taylor rule Inflation coefficient
kappaX =   -0.5/4;          %Taylor rule markup coefficient

%Shocks
sigma_ksi   =   0.05;       %size of the capital quality shock
rhoKsi      =   0.66;       %persistence of the capital quality shock
rhoShockIr  =   0.55284706;          %Persistence of a monetary policy shock
sigma_ir    =   0.00138155;   %0.00047181;  %0.00085;    %monetary policy shock
rhoA        =   0.95;       %persistence of the TFP shock
sigma_a     =   0.01;       %size of the TFP shock
rhoShockBetta  = 0.5;       %persistence of the preference shock
sigma_betta =   0.01;       %size of the preference shock;
sigma_g     =   0.01;       %size of the government expenditure shock
rhoG       =   0.95;        %persistence of the government expenditure shock
%sigma_Ne    =   0;         %wealth shock

%Solving the steady state
R_ss = 1/betta_ss;
Rk_ss = R_ss + RkmRMom;
Z_ss = Rk_ss-(1-delta);
k_ss = (epsilon/(alfa*(epsilon-1))*Z_ss)^(1/(alfa-1));
K_ss = k_ss*LMom;
Sh_ss = sh*K_ss;
N_ss = (K_ss-Sh_ss)/phiMom;
D_ss = (phiMom-1)*N_ss;
Y_ss = K_ss^alfa*LMom^(1-alfa);
G_ss = GoverY*Y_ss;
C_ss = Y_ss-delta*K_ss-G_ss;
varrho_ss = (1-betta_ss*hh)*((1-hh)*C_ss)^(-1);
Omega_ss = (1-sig)/(1-sig*betta_ss*(phiMom*RkmRMom+R_ss));
theta = betta_ss*Omega_ss*RkmRMom + 1/phiMom*betta_ss*Omega_ss*R_ss;
omega = (1-sig*(RkmRMom*phiMom+R_ss))*N_ss;
Ne_ss  =   sig*(RkmRMom*phiMom+R_ss)*N_ss;
Nn_ss  =   omega;
chi = (epsilon-1)/epsilon*(1-alfa)*k_ss^alfa/(LMom^varphi*varrho_ss^(-1));
Lambda_ss = 1;
X_ss = epsilon/(epsilon-1);
pm_ss = 1/X_ss;
I_ss = delta*K_ss;
Q_ss = 1;
w_ss  =   pm_ss*(1-alfa)*Y_ss/LMom;
S_ss   = K_ss;
prem_K_ss  =   Rk_ss-R_ss;
ir_ss  =   R_ss;
infl_ss = 0;

%RkmR_ss = Rk_ss-R_ss;
L_ss = LMom;
phi_ss = phiMom;
Shbar = Sh_ss-(Rk_ss-R_ss)/kappa;

varrho_kx = Rk_ss*(1-1/(4*dxMom));
varrho_x = R_ss*(1-1/(4*dxMom));
varrho_1 = R_ss*(1-1/(4*d1Mom));

Rkx_ss = Rk_ss;
Qx_ss = 1/(Rkx_ss-varrho_kx);
ykx_ss = Rkx_ss;
qx_ss = 1/(R_ss-varrho_x);
yx_ss = R_ss;
q1_ss = 1/(R_ss-varrho_1);
y1_ss = R_ss;
ebp_ss = ykx_ss-yx_ss;
%P_ss   =  1;

ebp_ann_ss = ebp_ss*4;
ir_ann_ss = exp(log(ir_ss)*4);
y1_ann_ss = exp(log(y1_ss)*4);
Y_ann_ss = Y_ss*4;

%shock variables
a_ss       =   0;
ksi_ss     =   0;
g_ss       =   0;
shockIr_ss =   0;
shockBetta_ss = 0;

%shocks
e_a_ss     =   0;
e_ksi_ss   =   0;
e_g_ss     =   0;
%e_Ne_ss    =   0;
e_ir_ss    =   0;
e_betta_ss  = 0;

model;
// Model local variables
# lambda = ((1-gam)*(1-betta_ss*gam)/gam);

//Household
//1. Marginal utility of consumption
exp(varrho)  =   (exp(C)-hh*exp(C(-1)))^(-1)-exp(betta)*hh*(exp(C(+1))-hh*exp(C))^(-1);

//2. Stochastic discount rate
exp(Lambda)  =   exp(varrho)/exp(varrho(-1));

//3. Euler equation
exp(betta)*exp(Lambda(+1))*exp(R)  =   1;

//4. Labor market equilibrium
chi*exp(L)^varphi    =   exp(varrho)*exp(pm)*(1-alfa)*exp(Y)/exp(L);

//Financial Intermediaries
//5. Marginal value of a unit of assets
exp(phi)    =   exp(betta)*exp(Omega(+1))*exp(R)/(theta-exp(betta)*exp(Omega(+1))*(exp(Rk(+1))-exp(R)));

//6. Expected shadow value of a unit of wealth
exp(Omega)  =   exp(Lambda)*(1-sig+sig*theta*(exp(phi)));

//Aggregate capital, net worth
//7. Leverage
exp(phi) = exp(Q)*(exp(S)-exp(Sh))/exp(N);

//8. Deposits
exp(D) = exp(Q)*(exp(S)-exp(Sh))-exp(N);

//9. Aggregate net worth
exp(N)      =   exp(Ne)+omega;

//10. Existing banks' net worth accumulation
//*exp(-e_Ne)
exp(Ne)     =   sig*((exp(Rk)-exp(R(-1)))*exp(phi(-1))+exp(R(-1)))*exp(N(-1));

//11. Corporate bond
exp(Rkx) = (1+varrho_kx*exp(Qx))/exp(Qx(-1));

//12. Arbitrage with corporate bond
exp(betta)*exp(Omega(+1))*(exp(Rkx(+1))-exp(R)) = exp(betta)*exp(Omega(+1))*(exp(Rk(+1))-exp(R));

//13. Yield to maturity of corporate bond
exp(ykx) = 1/exp(Qx)+varrho_kx;

//14. Sovereign bond
exp(qx) = (1+varrho_x*exp(qx(+1)))/exp(R);

//15. Yield to maturity of corporate bond
exp(yx) = 1/exp(qx)+varrho_x;

//16. Excess bond premium
ebp = exp(ykx)-exp(yx)-ebp_ss;

//Intermediate goods producer
//17. Marginal value product of effective capital
exp(Z)   =   exp(pm)*alfa*exp(Y)/exp(K);

//18. Return to capital
exp(Rk)     =   exp(ksi)*(exp(Z)+exp(Q)*(1-delta))/exp(Q(-1));

//19. Intermediate good production function
exp(Y)     =   exp(a)*exp(K)^alfa*exp(L)^(1-alfa);

//Capital Goods Producer
//20. Optimal investment decision
exp(Q)  =   1+eta_i/2*((exp(I))/(exp(I(-1)))-1)^2+eta_i*((exp(I))/(exp(I(-1)))-1)*(exp(I))/(exp(I(-1)))-exp(betta)*exp(Lambda(+1))*eta_i*((exp(I(+1)))/(exp(I))-1)*((exp(I(+1)))/(exp(I)))^2;

//21. New Keynesian Phillips curve 
infl-gam_P*infl(-1) = betta_ss*(infl(+1)-gam_P*infl)+lambda*(pm-log(pm_ss));

//22. Fisher equation
exp(ir)  =   exp(R)*exp(infl(+1));

//Government
//23. Interest rate rule
ir      =   rhoIr*ir(-1)+(1-rhoIr)*(log(R_ss)+kappaPi*(infl)-kappaX*(pm-log(pm_ss)))+shockIr;  

//Equilibrium
//24. Aggregate resource constraint
exp(Y)   =   exp(C)+exp(I)+exp(G)+eta_i/2*((exp(I))/(exp(I(-1)))-1)^2*(exp(I));

//25. Government expenditures
exp(G) = G_ss*exp(g);

//26. Capital accumulation equation
exp(S)  =   exp(K)*(1-delta)+exp(I);

//27. Effective capital
exp(K) = exp(ksi)*exp(S(-1));

//28. HH Bond holdings
exp(Sh) = Shbar+exp(Lambda(+1))*(exp(Rk(+1))-exp(R))/kappa;

//Final goods producer
//29. Markup
exp(X)  =   1/exp(pm);

//Shocks
//30. TFP shock
a  =   rhoA*a(-1)+sigma_a*e_a;

//31. Capital quality shock
ksi=   rhoKsi*ksi(-1)+sigma_ksi*e_ksi(-2);

//32. Monetary policy shock
shockIr  =   rhoShockIr*shockIr(-1)+sigma_ir*e_ir;

//33. Preference shock
shockBetta  =   rhoShockBetta*shockBetta(-1)-sigma_betta*e_betta;

//34. Preference shock
exp(betta) = betta_ss*exp(shockBetta);

//35. Government expenditure shock
g = rhoG*g(-1)+sigma_g*e_g;

//Some extra variables for convenience
//36. Wages
exp(w)      =   exp(pm)*(1-alfa)*exp(Y)/exp(L);

//37. Premium
exp(prem_K)   =   exp(Rk(+1))/exp(R);

//38. 1 year sovereign bond
exp(q1) = (1+varrho_1*exp(q1(+1)))/exp(R);

//39. Yield to maturity of corporate bond
exp(y1) = 1/exp(q1)+varrho_1;

//40. Annualized interest rates
ir_ann = ir*4;

//41. Annualized excess bond premium
ebp_ann = ebp*4;

//42. Annualized 1-year rate
y1_ann = y1*4;

//43. Annualized GDP
Y_ann = Y*4;

//40. Price level
//exp(P) = exp(P(-1))*exp(infl);
end;


initval;
Y=log(Y_ss);
K=log(K_ss);
S=log(S_ss);
D=log(D_ss);
L=log(L_ss);
I=log(I_ss);
C=log(C_ss);
Q=log(Q_ss);
varrho=log(varrho_ss);
Lambda=log(Lambda_ss);
Z=log(Z_ss);
w=log(w_ss);
N=log(N_ss);
Ne=log(Ne_ss);
Rk=log(Rk_ss);
R=log(R_ss);
prem_K=log(prem_K_ss);
phi=log(phi_ss);
Omega=log(Omega_ss);
pm=log(pm_ss);
X=log(X_ss);
ir=log(ir_ss);
betta=log(betta_ss);
Sh=log(Sh_ss);
G=log(G_ss);
Rkx=log(Rkx_ss);
Qx=log(Qx_ss);
ykx=log(ykx_ss);
qx=log(qx_ss);
yx=log(yx_ss);
q1=log(q1_ss);
y1=log(y1_ss);
ir_ann=log(ir_ann_ss);
y1_ann=log(y1_ann_ss);
Y_ann=log(Y_ann_ss);
ksi=ksi_ss;
infl=infl_ss;
a=a_ss;
shockIr=shockIr_ss;
shockBetta=shockBetta_ss;
g=g_ss;
ebp=0;
ebp_ann=0;
e_ksi=e_ksi_ss;
e_a=e_a_ss;
e_ir=e_ir_ss;
e_betta=e_betta_ss;
e_g=e_g_ss;
end;

%steady; check;

shocks;
var e_ksi=1;
var e_a=1;
var e_ir=1;
var e_betta=1;
var e_g=1;
end;

stoch_simul(order=1, irf=12, periods=0,noprint,nograph);


%if (0>1)

fid  =   fopen('../../../../../text/tables/params_GKHH.tex','w');

%fprintf(fid,'\n');
%fprintf(fid,'\\begin{table}[h!]\n');
%fprintf(fid,'\\caption{Parameter values}\n');
fprintf(fid,'\\begin{tabular}{c|c|l}\n');
fprintf(fid,'\\hline\\hline\n');
%fprintf(fid,'Symbol & Value & Description \\\\ \\hline \n');

fprintf(fid,'\\multicolumn{3}{c}{Households}\\\\ \\hline \n');
fprintf(fid,'$\\beta$ & %1.3f & Discount rate \\\\\n', betta_ss);
fprintf(fid,'$h$ & %1.3f & Habit parameter \\\\\n', hh);
fprintf(fid,'$\\chi$ & %1.3f & Relative utility weight of labor \\\\\n', chi);
fprintf(fid,'$\\varphi$ & %1.3f & Inverse Frisch elasticity of labor supply \\\\ \n', varphi);
fprintf(fid,'$\\bar{S}_h/S$ & %1.3f & Steady state direct HH holding of debt \\\\ \n', Sh_ss/K_ss);
%fprintf(fid,'$\\kappa$ & %1.3f & Portfolio adjustment cost \\\\ \n', kappa);
fprintf(fid,'$\\varrho_{k,x}$ & %1.3f & Rate of geometric decline of a corporate bond with duration $x$ \\\\ \n',varrho_kx);
%fprintf(fid,'$\\varrho_{x}$& %1.3f  & Rate of geometric decline of a government bond with duration $x$ \\\\  \\hline \n', varrho_x); 

fprintf(fid,'\\multicolumn{3}{c}{Financial Intermediaries}\\\\ \\hline \n');
fprintf(fid,'$\\theta$ & %1.3f & Fraction of capital that can be diverted \\\\\n', theta);
fprintf(fid,'$\\omega$ & %1.4f & Start-up fund for the entering bankers \\\\\n', omega);
fprintf(fid,'$\\sigma$ & %1.3f & Survival rate of the bankers \\\\ \\hline \n',sig);

fprintf(fid,'\\multicolumn{3}{c}{Intermediate good firms}\\\\ \\hline \n');
fprintf(fid,'$\\alpha$ & %1.3f & Capital share \\\\\n', alfa);
fprintf(fid,'$\\delta$ & %1.3f & Depreciation rate \\\\ \\hline \n', delta);

fprintf(fid,'\\multicolumn{3}{c}{Capital Producing Firms} \\\\ \\hline \n');
fprintf(fid,'$\\eta_i$ & %1.3f & Inverse elasticity of net investment to the price of capital\\\\ \\hline \n', eta_i);

fprintf(fid,'\\multicolumn{3}{c}{Retail Firms} \\\\ \\hline \n');
fprintf(fid,'$\\epsilon$ & %1.3f & Elasticity of substitution \\\\ \\hline \n', epsilon);
%fprintf(fid,'$\\gamma$ & %1.3f & Probability of keeping the price constant\\\\ \n', gam);
%fprintf(fid,'$\\gamma_P$ & %1.3f & Price indexation parameter\\\\ \\hline \n', gam_P);

fprintf(fid,'\\multicolumn{3}{c}{Government} \\\\ \\hline \n');
fprintf(fid,'$\\frac{G}{Y}$ & %1.3f & Steady state proportion of government expenditures \\\\\n', GoverY);
%fprintf(fid,'$\\rho_i$ & %1.3f & Interest rate smoothing parameter \\\\\n', rhoIr);
fprintf(fid,'$\\kappa_\\pi$ & %1.3f & Inflation coefficient in the Taylor rule \\\\\n', kappaPi);
fprintf(fid,'$\\kappa_X$ & %1.3f & Markup coefficient in the Taylor rule \\\\ \\hline  \n', kappaX);
%fprintf(fid,'$\\nu_K$ & %1.3f & Credit policy coefficient of the credit premium \\\\\n', nu_K);
%fprintf(fid,'$\\nu_B$ & %1.3f & Bond policy coefficient of the bond premium \\\\\n', nu_B);
%fprintf(fid,'$\\xi$ & %1.4f & Interest penalty for government credit \\\\\n', ksi);
%fprintf(fid,'$\\tau$ & %1.4f & Proportional efficiency loss of government credit \\\\ \n', tau);
%fprintf(fid,'$\\iota$ & %1.4f & Steady state interest subsidy for intermediate credit \\\\ \n', iota);

%fprintf(fid,'\\multicolumn{3}{c}{Shocks} \\\\ \\hline \n');
%fprintf(fid,'$\\rho_\\xi$ & %1.3f & Persistence of capital quality shock \\\\ \n',rhoKsi);
%fprintf(fid,'$\\sigma_\\xi$ & %1.3f & Std. dev. of capital quality shock \\\\ \n',sigmaKsi);
%fprintf(fid,'$\\rho_ir$ & %1.3f & Persistence of monetary policy shock \\\\ \n',rhoShockIr);
%fprintf(fid,'$\\sigma_ir$ & %1.3f & Std. dev. of the monetary policy shock \\\\ \n',sigmaIr);
%fprintf(fid,'$\\rho_{a}$ & %1.3f & Persistence of TFP shock \\\\ \n',rhoA);
%fprintf(fid,'$\\sigma_{a}$ & %1.3f & Std. dev. of TFP shock \\\\ \n',sigmaA);
%fprintf(fid,'$\\rho_{g}$ & %1.3f & Persistence of the government expenditure shock \\\\ \n',rhoG);
%fprintf(fid,'$\\sigma_{g}$ & %1.3f & Std. dev. of the government expenditure shock \\\\ \n',sigmaG);
fprintf(fid,'\\hline\\hline\n');
fprintf(fid,'\\end{tabular}\n');
%fprintf(fid,'\\end{table}\n');



fclose(fid);

fid  =   fopen('../../../../../text/tables/ss_values_GKHH.tex','w');

%fprintf(fid,'\\begin{table}[h!]\n');
%fprintf(fid,'\\caption{Steady state values}\n');
fprintf(fid,'\\begin{tabular}{c|c|l}\n');
fprintf(fid,'\\hline\\hline\n');
fprintf(fid,'Symbol & QE2 & Description \\\\ \\hline \n');
fprintf(fid,'\\multicolumn{3}{c}{Macrovariables}\\\\ \\hline \n');
fprintf(fid,'$Y$ & %1.3f & Output \\\\\n', Y_ss);
fprintf(fid,'$K$ & %1.3f & Capital \\\\\n', K_ss);
fprintf(fid,'$L$ & %1.3f & Labor \\\\\n', L_ss);
fprintf(fid,'$C$ & %1.3f & Consumption \\\\\n', C_ss);
fprintf(fid,'$I$ & %1.3f & Investment \\\\ \n', I_ss);
fprintf(fid,'$G$ & %1.3f & Government consumption \\\\ \n', G_ss);
fprintf(fid,'$Z$ & %1.3f & Marginal product value of capital \\\\ \\hline \n', Z_ss);
fprintf(fid,'$Q$ & %1.3f & Market value of capital \\\\ \n', Q_ss);
fprintf(fid,'$Q_{k,x}$ & %1.3f & Market value of a corporate bond with duration $x$ \\\\ \n', Qx_ss);
%fprintf(fid,'$q_{x}$ & %1.3f & Market value of a government bond with duration $x$\\\\ \n', vars_ss.qx);
fprintf(fid,'$\\varrho$ & %1.3f & Marginal utility of consumption \\\\ \n', varrho_ss);
fprintf(fid,'$\\Lambda$ & %1.3f & Stochastic discount factor \\\\ \n', Lambda_ss);
fprintf(fid,'$S_{h}$ & %1.3f & HH direct asset holding \\\\ \\hline \n', Sh_ss);

fprintf(fid,'\\multicolumn{3}{c}{Financial Intermediaries}\\\\ \\hline \n');
fprintf(fid,'$N$ & %1.3f & Net worth \\\\\n', N_ss);
fprintf(fid,'$R_k-R$ & %1.3f\\%% & Annualized Premium \\\\\n', (Rk_ss-R_ss)*400);
fprintf(fid,'$R_k$ & %1.3f\\%% & Annualized capital return \\\\\n', (Rk_ss-1)*400);
fprintf(fid,'$\\phi$ & %1.3f & Leverage \\\\\n', phi_ss);
fprintf(fid,'\\hline\\hline\n');
fprintf(fid,'\\end{tabular}\n');
%fprintf(fid,'\\end{table}\n');

fclose(fid);

%end;