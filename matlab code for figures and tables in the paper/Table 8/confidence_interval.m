function [conf_interval] = confidence_interval(data)


n=length(data);

%xbar = mean(data);
se = std(data)/sqrt(n);
nu = n - 1;
%Find the upper and lower confidence bounds for the 95% confidence interval.
conf = 0.95;
alpha = 1 - conf;
pLo = alpha/2;
pUp = 1 - alpha/2;
%Compute the critical values for the confidence bounds.
crit = tinv([pLo pUp], nu);
%Determine the confidence interval for the population mean.
%ci = xbar + crit*se;
conf_interval=2*crit(2)*se;


end