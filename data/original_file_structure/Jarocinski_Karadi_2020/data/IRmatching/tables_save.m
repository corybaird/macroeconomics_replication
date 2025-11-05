function tables_save

%Creates LaTeX tables about the parameters and the steady state values

clc;
%run the code calculating steady states and creating params file
cd dynare;
dynare GKHH_dynare.mod
cd ..;

fid  =   fopen('../../../../text/tables/params_GKHH.tex','w');

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
fprintf(fid,'$\\bar{S}^h$ & %1.3f & Relative steady state direct HH holding of debt \\\\ \n', sh);
%fprintf(fid,'$\\kappa$ & %1.3f & Portfolio adjustment cost \\\\ \n', params_ss.kappa);
fprintf(fid,'$\\varrho_{k,x}$ & %1.3f & Rate of geometric decline of a corporate bond with duration $x$ \\\\ \n',varrho_kx);
%fprintf(fid,'$\\varrho_{x}$& %1.3f  & Rate of geometric decline of a government bond with duration $x$ \\\\  \\hline \n', params_ss.varrho_x); 

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
fprintf(fid,'$\\epsilon$ & %1.3f & Elasticity of substitution \\\\\n', epsilon);
%fprintf(fid,'$\\gamma$ & %1.3f & Probability of keeping the price constant\\\\ \n', gam);
%fprintf(fid,'$\\gamma_P$ & %1.3f & Price indexation parameter\\\\ \\hline \n', params_ss.gam_P);

fprintf(fid,'\\multicolumn{3}{c}{Government} \\\\ \\hline \n');
fprintf(fid,'$\\frac{G}{Y}$ & %1.3f & Steady state proportion of government expenditures \\\\\n', GoverY);
%fprintf(fid,'$\\rho_i$ & %1.3f & Interest rate smoothing parameter \\\\\n', params_ss.rhoIr);
fprintf(fid,'$\\kappa_\\pi$ & %1.3f & Inflation coefficient in the Taylor rule \\\\\n', kappaPi);
fprintf(fid,'$\\kappa_X$ & %1.3f & Markup coefficient in the Taylor rule \\\\ \n', kappaX);
%fprintf(fid,'$\\nu_K$ & %1.3f & Credit policy coefficient of the credit premium \\\\\n', params_ss.nu_K);
%fprintf(fid,'$\\nu_B$ & %1.3f & Bond policy coefficient of the bond premium \\\\\n', params_ss.nu_B);
%fprintf(fid,'$\\xi$ & %1.4f & Interest penalty for government credit \\\\\n', params_ss.ksi);
%fprintf(fid,'$\\tau$ & %1.4f & Proportional efficiency loss of government credit \\\\ \n', params_ss.tau);
%fprintf(fid,'$\\iota$ & %1.4f & Steady state interest subsidy for intermediate credit \\\\ \n', params_ss.iota);

%fprintf(fid,'\\multicolumn{3}{c}{Shocks} \\\\ \\hline \n');
%fprintf(fid,'$\\rho_\\xi$ & %1.3f & Persistence of capital quality shock \\\\ \n',params_ss.rhoKsi);
%fprintf(fid,'$\\sigma_\\xi$ & %1.3f & Std. dev. of capital quality shock \\\\ \n',params_ss.sigmaKsi);
%fprintf(fid,'$\\rho_ir$ & %1.3f & Persistence of monetary policy shock \\\\ \n',params_ss.rhoShockIr);
%fprintf(fid,'$\\sigma_ir$ & %1.3f & Std. dev. of the monetary policy shock \\\\ \n',params_ss.sigmaIr);
%fprintf(fid,'$\\rho_{a}$ & %1.3f & Persistence of TFP shock \\\\ \n',params_ss.rhoA);
%fprintf(fid,'$\\sigma_{a}$ & %1.3f & Std. dev. of TFP shock \\\\ \n',params_ss.sigmaA);
%fprintf(fid,'$\\rho_{g}$ & %1.3f & Persistence of the government expenditure shock \\\\ \n',params_ss.rhoG);
%fprintf(fid,'$\\sigma_{g}$ & %1.3f & Std. dev. of the government expenditure shock \\\\ \n',params_ss.sigmaG);
fprintf(fid,'\\hline\\hline\n');
fprintf(fid,'\\end{tabular}\n');
%fprintf(fid,'\\end{table}\n');



fclose(fid);

fid  =   fopen('../../../../text/tables/ss_values_GKHH.tex','w');

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

% fprintf(fid,'\n\n\n');
% fprintf(fid,'\\begin{table}[h!]\n');
% fprintf(fid,'\\caption{Test values}\n');
% fprintf(fid,'\\begin{tabular}{c|c|c|l}\n');
% fprintf(fid,'\\hline\\hline\n');
% fprintf(fid,'$Q$ & %1.3f & Market value of capital \\\\ \n', vars_ss.Q);
% fprintf(fid,'$\\delta$ & %1.3f & Capital depreciation rate \\\\ \n', params_ss.delta);
% fprintf(fid,'$\\phi$ & %1.3f & Capital leverage \\\\\n', vars_ss.phi);
% fprintf(fid,'\\hline\\hline\n');
% fprintf(fid,'\\end{tabular}\n');
% fprintf(fid,'\\end{table}\n');