'Figures 4 & 5

'Data
%path = @runpath
wfopen {%path}\data_figures_tables.xlsx range=data_f4_5 colhead=1 na="#N/A" @freq M @id @date(series01) @smpl @all
rename series01 date
date.displayname date

' VAR
for %p pmi
	
	smpl @first 2007m12
	var six_pre_{%p}.ls 1 6 equity usd {%p} trade
	
	freeze(mode = overwrite,t_irf_six_pre_{%p})  six_pre_{%p}.impulse(24,t, se=a) 
	t_irf_six_pre_{%p}.save(t=csv, n="NAN") {%path}\t_irf_six_pre_{%p}
	
	smpl 2010m1 @last
	var six_post_{%p}.ls 1 6 equity usd {%p} trade
	
	freeze(mode = overwrite,t_irf_six_post_{%p})  six_post_{%p}.impulse(24,t, se=a) 
	t_irf_six_post_{%p}.save(t=csv, n="NAN") {%path}\t_irf_six_post_{%p}
	
next


