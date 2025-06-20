fty1 = fittype("a*x+b");
fty2 = fittype("poly3");
fit1 = fit(hoek,tauNm,fty1,Weights=(1./(errtau.^2)));
fit2 = fit(hoek,tauNm,fty2,Weights=(1./(errtau.^2)));

% errorbar(hoek,tauNm,errtau,".")
% hold on
% plot(hoek,fit1(hoek))
% plot(hoek,fit2(hoek))
% legend("Data",replace(replace(f("linear fit: {fit1.a:%0.2d}*x"),"*","\cdot"),"x","\theta"),...
%     replace(replace(f("cubic fit: ({fit2.p1:%0.2d})*x^3+({fit2.p2:%0.2d})*x^2+({fit2.p3:%0.2d})*x"),"*","\cdot"),"x","\theta"))
% legend(Location="northwest")
% xlabel("angle \theta [ rad ]")
% ylabel("torque \tau [ Nm ]")
% grid on
% set(gca,Fontsize=20)
% hold off

chi2_red1 = sum(((tauNm-fit1(hoek))./(errtau)).^2)/(length(errtau)-1);
chi2_red2 = sum(((tauNm-fit2(hoek))./(errtau)).^2)/(length(errtau)-1);