#!/bin/bash

if [ -e "cmrfiles" ] 
then

echo "The directory 'cmrfiles' already exists.  Please delete and try again."

else

mkdir cmrfiles
cp cmr_model.mod cmrfiles
cp cmr_declarations.mod cmrfiles
cp cmr_estimated_params.mod cmrfiles
cp cmr_estimated_params_init.mod cmrfiles
cp cmr_indicator_variables.mod cmrfiles
cp cmr_parameters.mod cmrfiles
cp cmr_shocks.mod cmrfiles
cp cmr_steadystate.m cmrfiles
cp data_BAAoverTB.mat cmrfiles
cp cmr_package.sh cmrfiles

mkdir cmrfiles/dynare_code
cp dynare_code/disp_th_moments.m cmrfiles/dynare_code
cp dynare_code/draw_prior_density.m cmrfiles/dynare_code
cp dynare_code/prior_bounds.m cmrfiles/dynare_code
cp dynare_code/priordens.m cmrfiles/dynare_code
cp dynare_code/set_prior.m cmrfiles/dynare_code

mkdir cmrfiles/table2
cp table2/cmr.mod cmrfiles/table2
cp table2/cmr_mode.mat cmrfiles/table2

mkdir cmrfiles/table3
cp table3/cmr.mod cmrfiles/table3
cp table3/cmr_mode.mat cmrfiles/table3
cp table3/find_ss_4table.m cmrfiles/table3
cp table3/model_ss_table.m cmrfiles/table3

mkdir cmrfiles/table4
mkdir cmrfiles/table4/baseline
cp table4/baseline/cmr.mod cmrfiles/table4/baseline
cp table4/baseline/cmr.log cmrfiles/table4/baseline
cp table4/baseline/cmr_mode.mat cmrfiles/table4/baseline

mkdir cmrfiles/table4/no_signals
cp table4/no_signals/cmr.mod cmrfiles/table4/no_signals
cp table4/no_signals/cmr.log cmrfiles/table4/no_signals
cp table4/no_signals/cmr_mode.mat cmrfiles/table4/no_signals

mkdir cmrfiles/table4/signals_on_epsil_muzstar
cp table4/signals_on_epsil_muzstar/cmr.mod cmrfiles/table4/signals_on_epsil_muzstar
cp table4/signals_on_epsil_muzstar/cmr.log cmrfiles/table4/signals_on_epsil_muzstar
cp table4/signals_on_epsil_muzstar/cmr_declarations.mod cmrfiles/table4/signals_on_epsil_muzstar
cp table4/signals_on_epsil_muzstar/cmr_estimated_params.mod cmrfiles/table4/signals_on_epsil_muzstar
cp table4/signals_on_epsil_muzstar/cmr_estimated_params_init.mod cmrfiles/table4/signals_on_epsil_muzstar
cp table4/signals_on_epsil_muzstar/cmr_model.mod cmrfiles/table4/signals_on_epsil_muzstar
cp table4/signals_on_epsil_muzstar/cmr_parameters.mod cmrfiles/table4/signals_on_epsil_muzstar
cp table4/signals_on_epsil_muzstar/cmr_shocks.mod cmrfiles/table4/signals_on_epsil_muzstar
cp table4/signals_on_epsil_muzstar/cmr_steadystate.m cmrfiles/table4/signals_on_epsil_muzstar
cp table4/signals_on_epsil_muzstar/cmr_mode.mat cmrfiles/table4/signals_on_epsil_muzstar

mkdir cmrfiles/table4/signals_on_epsil_zetai
cp table4/signals_on_epsil_zetai/cmr.mod cmrfiles/table4/signals_on_epsil_zetai
cp table4/signals_on_epsil_zetai/cmr.log cmrfiles/table4/signals_on_epsil_zetai
cp table4/signals_on_epsil_zetai/cmr_declarations.mod cmrfiles/table4/signals_on_epsil_zetai
cp table4/signals_on_epsil_zetai/cmr_estimated_params.mod cmrfiles/table4/signals_on_epsil_zetai
cp table4/signals_on_epsil_zetai/cmr_estimated_params_init.mod cmrfiles/table4/signals_on_epsil_zetai
cp table4/signals_on_epsil_zetai/cmr_model.mod cmrfiles/table4/signals_on_epsil_zetai
cp table4/signals_on_epsil_zetai/cmr_parameters.mod cmrfiles/table4/signals_on_epsil_zetai
cp table4/signals_on_epsil_zetai/cmr_shocks.mod cmrfiles/table4/signals_on_epsil_zetai
cp table4/signals_on_epsil_zetai/cmr_steadystate.m cmrfiles/table4/signals_on_epsil_zetai
cp table4/signals_on_epsil_zetai/cmr_mode.mat cmrfiles/table4/signals_on_epsil_zetai

mkdir cmrfiles/table4/signals_on_epsilon
cp table4/signals_on_epsilon/cmr.mod cmrfiles/table4/signals_on_epsilon
cp table4/signals_on_epsilon/cmr.log cmrfiles/table4/signals_on_epsilon
cp table4/signals_on_epsilon/cmr_model.mod cmrfiles/table4/signals_on_epsilon
cp table4/signals_on_epsilon/cmr_steadystate.m cmrfiles/table4/signals_on_epsilon
cp table4/signals_on_epsilon/cmr_mode.mat cmrfiles/table4/signals_on_epsilon

mkdir cmrfiles/table4/signals_on_equity_shock
cp table4/signals_on_equity_shock/cmr.mod cmrfiles/table4/signals_on_equity_shock
cp table4/signals_on_equity_shock/cmr.log cmrfiles/table4/signals_on_equity_shock
cp table4/signals_on_equity_shock/cmr_model.mod cmrfiles/table4/signals_on_equity_shock
cp table4/signals_on_equity_shock/cmr_mode.mat cmrfiles/table4/signals_on_equity_shock

mkdir cmrfiles/table4/signals_on_mp_shock
cp table4/signals_on_mp_shock/cmr.mod cmrfiles/table4/signals_on_mp_shock
cp table4/signals_on_mp_shock/cmr.log cmrfiles/table4/signals_on_mp_shock
cp table4/signals_on_mp_shock/cmr_model.mod cmrfiles/table4/signals_on_mp_shock
cp table4/signals_on_mp_shock/cmr_mode.mat cmrfiles/table4/signals_on_mp_shock

mkdir cmrfiles/table4/signals_on_muzstar
cp table4/signals_on_muzstar/cmr.mod cmrfiles/table4/signals_on_muzstar
cp table4/signals_on_muzstar/cmr.log cmrfiles/table4/signals_on_muzstar
cp table4/signals_on_muzstar/cmr_model.mod cmrfiles/table4/signals_on_muzstar
cp table4/signals_on_muzstar/cmr_mode.mat cmrfiles/table4/signals_on_muzstar

mkdir cmrfiles/table4/signals_on_muzstar_zetai
cp table4/signals_on_muzstar_zetai/cmr.mod cmrfiles/table4/signals_on_muzstar_zetai
cp table4/signals_on_muzstar_zetai/cmr.log cmrfiles/table4/signals_on_muzstar_zetai
cp table4/signals_on_muzstar_zetai/cmr_declarations.mod cmrfiles/table4/signals_on_muzstar_zetai
cp table4/signals_on_muzstar_zetai/cmr_estimated_params.mod cmrfiles/table4/signals_on_muzstar_zetai
cp table4/signals_on_muzstar_zetai/cmr_estimated_params_init.mod cmrfiles/table4/signals_on_muzstar_zetai
cp table4/signals_on_muzstar_zetai/cmr_model.mod cmrfiles/table4/signals_on_muzstar_zetai
cp table4/signals_on_muzstar_zetai/cmr_parameters.mod cmrfiles/table4/signals_on_muzstar_zetai
cp table4/signals_on_muzstar_zetai/cmr_shocks.mod cmrfiles/table4/signals_on_muzstar_zetai
cp table4/signals_on_muzstar_zetai/cmr_steadystate.m cmrfiles/table4/signals_on_muzstar_zetai
cp table4/signals_on_muzstar_zetai/cmr_mode.mat cmrfiles/table4/signals_on_muzstar_zetai

mkdir cmrfiles/table4/signals_on_spending_shock
cp table4/signals_on_spending_shock/cmr.mod cmrfiles/table4/signals_on_spending_shock
cp table4/signals_on_spending_shock/cmr.log cmrfiles/table4/signals_on_spending_shock
cp table4/signals_on_spending_shock/cmr_model.mod cmrfiles/table4/signals_on_spending_shock
cp table4/signals_on_spending_shock/cmr_mode.mat cmrfiles/table4/signals_on_spending_shock

mkdir cmrfiles/table4/signals_on_technology
cp table4/signals_on_technology/cmr.mod cmrfiles/table4/signals_on_technology
cp table4/signals_on_technology/cmr.log cmrfiles/table4/signals_on_technology
cp table4/signals_on_technology/cmr_declarations.mod cmrfiles/table4/signals_on_technology
cp table4/signals_on_technology/cmr_estimated_params.mod cmrfiles/table4/signals_on_technology
cp table4/signals_on_technology/cmr_estimated_params_init.mod cmrfiles/table4/signals_on_technology
cp table4/signals_on_technology/cmr_model.mod cmrfiles/table4/signals_on_technology
cp table4/signals_on_technology/cmr_parameters.mod cmrfiles/table4/signals_on_technology
cp table4/signals_on_technology/cmr_shocks.mod cmrfiles/table4/signals_on_technology
cp table4/signals_on_technology/cmr_steadystate.m cmrfiles/table4/signals_on_technology
cp table4/signals_on_technology/cmr_mode.mat cmrfiles/table4/signals_on_technology

mkdir cmrfiles/table4/signals_on_zetai
cp table4/signals_on_zetai/cmr.mod cmrfiles/table4/signals_on_zetai
cp table4/signals_on_zetai/cmr.log cmrfiles/table4/signals_on_zetai
cp table4/signals_on_zetai/cmr_model.mod cmrfiles/table4/signals_on_zetai
cp table4/signals_on_zetai/cmr_mode.mat cmrfiles/table4/signals_on_zetai

mkdir cmrfiles/table4/uncorrelated_signals
cp table4/uncorrelated_signals/cmr.mod cmrfiles/table4/uncorrelated_signals
cp table4/uncorrelated_signals/cmr.log cmrfiles/table4/uncorrelated_signals
cp table4/uncorrelated_signals/cmr_mode.mat cmrfiles/table4/uncorrelated_signals

mkdir cmrfiles/figure1
cp figure1/cmr.mod cmrfiles/figure1
cp figure1/cmr_mode.mat cmrfiles/figure1

mkdir cmrfiles/figure2
cp figure2/cmr.mod cmrfiles/figure2

mkdir cmrfiles/figure3
cp figure3/cmr.mod cmrfiles/figure3
cp figure3/correlate.m cmrfiles/figure3
cp figure3/difftrans.m cmrfiles/figure3
cp figure3/hpfast.m cmrfiles/figure3
cp figure3/se.m cmrfiles/figure3
cp figure3/corr_.m cmrfiles/figure3
cp figure3/cross_corr.m cmrfiles/figure3
cp figure3/do_plot.m cmrfiles/figure3
cp figure3/pltt.m cmrfiles/figure3

mkdir cmrfiles/figure4
cp figure4/cmr.mod cmrfiles/figure4

mkdir cmrfiles/figure5
cp figure5/cmr.mod cmrfiles/figure5
cp figure5/cmr_mode.mat cmrfiles/figure5
cp figure5/cmr_mode_cee.mat cmrfiles/figure5
cp figure5/recession_dates.m cmrfiles/figure5
cp figure5/recession_bars.m cmrfiles/figure5

mkdir cmrfiles/figure7
cp figure7/cmr.mod cmrfiles/figure7
cp figure7/cmr_mode.mat cmrfiles/figure7
cp figure7/hpfast.m cmrfiles/figure7

mkdir cmrfiles/figure8
cp figure8/cmr.mod cmrfiles/figure8
cp figure8/cmr_mode.mat cmrfiles/figure8
 
mkdir cmrfiles/doc
cp doc/cmr-ref.pdf cmrfiles/doc
cp doc/cmr-ref.texi cmrfiles/doc
cp doc/fdl.texi cmrfiles/doc
cp doc/gpl.texi cmrfiles/doc
cp doc/coding.texi cmrfiles/doc
cp doc/graphs.texi cmrfiles/doc
cp doc/tables.texi cmrfiles/doc
cp doc/intro.texi cmrfiles/doc
cp doc/names.texi cmrfiles/doc
cp doc/using.texi cmrfiles/doc

zip -qr cmrfiles.zip cmrfiles
rm -Rf cmrfiles

fi

