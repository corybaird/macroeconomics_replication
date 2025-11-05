function ss_val = find_ss_4table(oo_, M_, str)
idx = 1;
while (strcmp(M_.endo_names(idx, 1:length(str)), str) == 0)
  idx = idx + 1;
end
ss_val = oo_.steady_state(idx);