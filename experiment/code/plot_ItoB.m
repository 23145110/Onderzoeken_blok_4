

B = fit1(V_hall*1000);
errb= fit1.a*errV_hall*1000;

fitty = fittype("a*x+b");
fit2 = fit(I,B,fitty,startpoint=[0,0],Weights=(1./(errb.^2)));%

errorbar(I,B,errb,errb,dI,dI,".")
hold on
grid on
xlabel("Current I [ A ]")
ylabel("Magnetic field B [ mT ]")
plot([0,2],fit2([0,2]))

xlim([0,2.1])
a = 0:0.01:2;
upperlower = confint(fit2);
ytop = upperlower(2,1).*a + upperlower(2,2);
ybot = upperlower(1,1).*a + upperlower(1,2);
patch([a fliplr(a)], [ytop fliplr(ybot)], [0.05,0.05,0.05],"FaceAlpha",...
    0.10,"EdgeColor","none")

legend("data","fit: (227\pm 2)\cdot V_H  - (15.8\pm 0.4)")
legend("Location","northwest")
set(gca,fontsize=20)
chi_red = sum(((fit2(I)-B')./errb').^2)./(length(B)-1);
hold off