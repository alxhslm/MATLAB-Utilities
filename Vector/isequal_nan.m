function out = isequal_nan(a,b)
ii = ~isnan(a);
out = isequal(a(ii),b(ii));