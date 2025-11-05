function A = nantozip(A)

i = ~isfinite(A) ;
A(i) = 0 ;
