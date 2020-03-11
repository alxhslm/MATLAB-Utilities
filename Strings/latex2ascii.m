function ascii_str = latex2ascii(latex_str)

latex_names = {'\alpha'
'\beta'
'\gamma'
'\delta'
'\epsilon'
'\zeta'
'\eta'
'\theta'
'\iota'
'\kappa'
'\lambda'
'\mu'
'\nu'
'\xi'
'\omicron'
'\pi'
'\rho'
'\sigma'
'\tau'
'\upsilon'
'\phi'
'\chi'
'\psi'
'\omega'
};

ascii_str = latex_str;
for i = 1:length(latex_names)
    ascii_str = strrep(ascii_str,['$' latex_names{i} '$'],char(944+i));
end
