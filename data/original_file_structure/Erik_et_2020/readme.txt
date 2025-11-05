
README for the data and codes for the paper: Erik, Burcu, Marco J. Lombardi, Dubravko Mihaljek, and Hyun Song Shin. 2020. "The Dollar, Bank Leverage, and Real Economic Activity: An Evolving Relationship." AEA Papers and Proceedings, 110: 529-34.
(https://www.aeaweb.org/articles/pdf/doi/10.1257/pandp.20201097)

Data availability
	All data are saved in "data_figures_tables.xlsx" and "data_underlying.xlsx" except those that cannot be shared based on the agreements with the data providers. These are bank level data in Figure 1; country level PMI in Figures 4 & 5 and global manufacturing PMI in Table 1. Researchers can subscribe to these data through contacting Datastream Worldscope and/or IHS Markit (there is a cost).
	Further details can be found in the following sheets:
		- "info" and "source_<figure(f)/table(t)_number>" in "data_figures_tables.xlsx",
		- "sources" in "data_underlying.xlsx".

	List of sources by type:
		- Commercial: Bloomberg, Datastream, Datastream Worldscope, Dealogic, Euroclear, ICE BofAML indices, IHS Markit, MSCI, Thomson Reuters, Xtrakter Ltd
		- Public use: BIS locational banking statistics, CPB Netherlands Bureau of Economic Policy Analysis, Federal Reserve (Flow of Funds), Federal Reserve Bank of St Louis (FRED)
		- Confidential: National data (reported to the BIS)

	Data access description: 
		- For commercial data, researchers can subscribe to the data through contacting data providers cited in (there is a cost).
		- For public use data, researchers can access the data using the following links:
			. BIS locational banking statistics: https://www.bis.org/statistics/bankstats.htm
			. CPB Netherlands Bureau of Economic Policy Analysis: https://www.cpb.nl/en/worldtrademonitor
			. Federal Reserve (Flow of Funds): https://www.federalreserve.gov/releases/z1/
			. Federal Reserve Bank of St Louis (FRED): https://fred.stlouisfed.org/
		- For confidential data, aggregated version compiled by the BIS can be found in the BIS website under Global Liquidity Indicators:
			. Total credit denominated in USD to non-banks in EMEs: https://stats.bis.org/statx/srs/tseries/GLI/Q.USD.4T.N.A.I.B.771?t=e2&c=&m=USD&p=20193&i=2.4
			. Loans denominated in USD to non-banks in EMEs: https://stats.bis.org/statx/srs/tseries/GLI/Q.USD.4T.N.B.I.G.771?t=e2&c=&m=USD&p=20193&i=27.4


Dataset list and sources
	- Total assets and book equity of 17 US and 26 euro area banks: Datastream Worldscope
	- Total assets and equity for the broker-dealer sector in the US: Federal Reserve, Flow of Funds
	- CBOE Volatility Index: Bloomberg
	- Federal Reserve Board trade-weighted US dollar indices: Federal Reserve Bank of St Louis (FRED)
	- Five-year cross-currency basis spreads: Bloomberg
	- Equity price indices: Bloomberg, Datastream, MSCI
	- Weights (GDP PPP): IMF World Economic Outlook
	- Manufacturing PMIs: IHS Markit
	- World trade volume index: CPB Netherlands Bureau of Economic Policy Analysis
	- Corporate bond spreads: ICE BofAML indices
	- Total credit and loans denominated in USD to non-banks in EMEs: Dealogic, Euroclear, Thomson Reuters, Xtrakter Ltd, national data, BIS locational banking statistics.


Computational requirements
	- Software used: Matlab Release 2020a (toolboxes used: Statistics and Machine Learning), Eviews 10, Microsoft Excel 2016.
	- Running the codes takes around 3 minutes.
	- The codes were last run on a 4-core Intel-based laptop with Microsoft Windows 10 Enterprise (10.0.17763) in August 2020.
	- Data in "data_figures_tables.xlsx" were last retrieved in December 2019 and those in "data_underlying.xlsx" in August 2020.
	- Please note that the format of the figures in the paper are different as they were generated using an in-house Matlab add-in.


Instructions
	- "data_figures_tables.xlsx" includes data used in the analyses.
	- "data_underlying.xlsx" includes the raw data for the aggregated/transformed time series.
	- The figures can be produced by running "main_code.m", where each section corresponds to one figure.
	- The code for the table is provided in a separate section in the same script. Please note however that it cannot be produced using the data provided -since one of the required time series cannot be shared based on the agreement with the data provider.
	Researchers can subscribe to this data through contacting IHS Markit (there is a cost).

List of programs, data files, figures and tables
	I.  Programs:
		- main_code.m
		- var_figures_4_5.prg

	II. Data files:
		- data_underlying.xlsx
		- data_figures_tables.xlsx
		- t_irf_six_pre_pmi.csv
		- t_irf_six_post_pmi.csv

	III. Figures:
		- figure_1.png
		- figure_2.png
		- figure_3.png
		- figure_4.png
		- figure_5.png
		- figure_6_spider_chart.xlsx
		- figure_7.png

	IV. Tables:
		- table_1.xlsx


