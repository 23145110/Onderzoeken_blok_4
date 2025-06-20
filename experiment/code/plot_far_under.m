%plot data that is far underdamped
cspt7 = zeros(1,7);
err_cspt7 = zeros(1,7);
csnt7 = zeros(1,7);
err_csnt7 = zeros(1,7);

csIt7 = [0.0,0.2:0.1:0.7];

for n = 3
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

scatter(ts_clean{n},thetas_clean{n},0.7)
hold on
grid on
legend("theta")
scatter(ts_clean{n}(indexes),peaks,"^")
scatter(ts_clean{n}(nindexes),-npeaks,"v")
plot(ts_clean{n},pfit(ts_clean{n}))
plot(ts_clean{n},nfit(ts_clean{n}))
ylim([-pi,pi])
xlabel("time $t$ [ s ]",Interpreter="latex")
ylabel("angle $\theta$ [ rad ]", Interpreter="latex")
legend("motion data","positive peaks","negative peaks",...
    "fit:$\theta$ = "+replace(f("{pfit.t0:%0.2f}exp(-{pfit.B:%0.4f}*t)"),"*","$\cdot$"),...
    "fit:$\theta$ = "+replace(f("-{nfit.t0:%0.2f}exp(-{nfit.B:%0.4f}*t)"),"*","$\cdot$")...
    ,"interpreter","latex")
set(gca,Fontsize=20)
hold off