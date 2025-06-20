% data is in cell form with 20 entries with n=1: 0.0A then n=2: 0.2A to n=20: 2.0A
% cs are deltas and delta = gamma/2I with gamma being the damping constant
% and I being the moment of inertia of the disc

% from n = 1 to n = 7 use peaks and t0*exp(-B*t) from top and -t0*exp(-B*t) from bottom

% from n = 8 to n = 14 use "exp(-B*t)*(C1*cos(A*t)+C2*sin(A*t))"

% from n = 15 to n = 20 use C1*exp(l1*t)+C2*exp(l2+t) with l1 and l2 roots
% of I*alpha + gamma*omega + k*theta = 0 so
% gamma = -I(l1+l2) and k = I*l1*l2


cspt7 = zeros(1,7);
err_cspt7 = zeros(1,7);
csnt7 = zeros(1,7);
err_csnt7 = zeros(1,7);

csIt7 = [0.0,0.2:0.1:0.7];

for n =1:7
    [peaks,indexes] = findpeaks(thetas_clean{n},MinPeakDistance=80,MinPeakHeight=0.0049);
    [npeaks,nindexes] = findpeaks(-thetas_clean{n},MinPeakDistance=80,MinPeakHeight=0.01);

    fitexp1 = "t0*exp(-B*t)";
    fitexp2 = "-t0*exp(-B*t)";
    fty1 = fittype(fitexp1,"independent","t");
    fty2 = fittype(fitexp2,"independent","t");
    
    t = ts_clean{n};
    pfit = fit(t(indexes),peaks,fty1,'StartPoint',[0,pi/2]);
    nfit = fit(t(nindexes),-npeaks,fty2,'StartPoint',[0,pi/2]);

    cspt7(n) = pfit.B;
    csnt7(n) = nfit.B;
    
    cpconf = confint(pfit);
    err_cspt7(n) = abs(cpconf(1,1)-cpconf(2,1))/2; % assumes symetric errors
    
    cnconf = confint(nfit);
    err_csnt7(n) = abs(cnconf(1,1)-cnconf(2,1))/2; % assumes symetric errors 
end


cst14 = zeros(1,7);
err_cst14 = zeros(1,7);
csIt14 = 0.8:0.1:1.4;

for n = 8:14
    fitexp = "exp(-B*t)*(C1*cos(A*t)+C2*sin(A*t))";
    fty = fittype(fitexp,"independent","t");

    fitt14 = fit(ts_clean{n},thetas_clean{n},fty,'StartPoint',[0,0.5,-pi/2,-pi/2],lower=[0,0,-Inf,-Inf],upper=[Inf,Inf,Inf,Inf]);
    cst14(n-7) = fitt14.B;

    cconf = confint(fitt14);
    err_cst14(n-7) = abs(cconf(1,2)-cconf(2,2))/2; % assumes symetric errors
end

% l1t20 = zeros(1,8);
% l2t20 = zeros(1,8);
% err_l1t20 = zeros(1,8);
% err_l2t20 = zeros(1,8);
% csIt20 = 1.3:0.1:2;
% 
% for n = 13:20
%     fitexp = "C1*exp(l1*t)+C2*exp(l2+t)";
%     fty = fittype(fitexp,"independent","t");
% 
%     fitt20 = fit(ts_clean{n},thetas_clean{n},fty,'StartPoint',[0,0,0,0]);
%     l1t20(n-12) = fitt20.l1;
%     l2t20(n-12) = fitt20.l2;
% 
%     cconf = confint(fitt20);
%     err_l1t20(n-12) = abs(cconf(1,3)-cconf(2,3))/2; % assumes symetric errors
%     cconf = confint(fitt20);
%     err_l2t20(n-12) = abs(cconf(1,4)-cconf(2,4))/2; % assumes symetric errors
% end

finalfty1 = fittype("a*I+b","independent","I");
finalfty2 = fittype("b*exp(a*I)","independent","I");
xdata = [0.0,0.2:0.1:1.4];
cst7 = (cspt7+csnt7)./2;
err_cst7 = (err_cspt7+err_csnt7)./2;
ydata = cat(2,cst7,cst14);
err_ydata = cat(2,err_cst7,err_cst14);
W = 1./(err_ydata.^2);
finalfit1 = fit(xdata',ydata',finalfty1,weights=1./(err_ydata.^2),StartPoint=[1,0]);
finalfit2 = fit(xdata',ydata',finalfty2,weights=1./(err_ydata.^2),startpoint=[0,0.01]);
I_fit1 = 0:0.01:0.7;
I_fit2 = 0.7:0.01:1.4;

chi_finalfit1 = sum(((ydata-finalfit1(xdata)')./(err_ydata)).^2)/(length(ydata)-1);
chi_finalfit2 = sum(((ydata-finalfit2(xdata)')./(err_ydata)).^2)/(length(ydata)-1);

errorbar(csIt7,cspt7,err_cspt7,err_cspt7,".",DisplayName="positive envelope n=1 to n=7")
hold on
errorbar(csIt7,csnt7,err_csnt7,err_csnt7,".",DisplayName="negative envelope n=1 to n=7")
errorbar(csIt14,cst14,err_cst14,err_cst14,".",DisplayName="n = 8 to n = 14")
xlabel("current $I$ [ A ]","Interpreter","latex")
ylabel("Damping factor $\delta$ [ $\mathrm{s^{-1}}$ ]","Interpreter","latex")
plot(xdata,finalfit1(xdata),DisplayName=f("linear fit: {finalfit1.a} I + {finalfit2.b}"))
plot(xdata,finalfit2(xdata),DisplayName=f("exponential fit: {finalfit2.b}exp({finalfit2.a} I)"))
legend show
legend(Location="northwest")
set(gca,Fontsize=20)
grid on
hold off
