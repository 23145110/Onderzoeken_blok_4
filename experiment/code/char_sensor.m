B = [2.7,28.5,54.2,80.5,97.5];
errb= [0.5,0.5,0.5,0.5,0.5];
V_hall_sensor = [36,76,116,156,190];
err_V_hall_sensor = [0.5,0.5,0.5,0.5,0.5];

fitty = fittype("a*x+b");
fit1 = fit(V_hall_sensor',B',fitty,Weights=(1./(errb.^2)),startpoint=[0,0]);

errorbar(V_hall_sensor,B,errb,errb,err_V_hall_sensor,err_V_hall_sensor,".")
hold on
grid on
xlabel("Hall voltage V_H [ mV ]")
ylabel("Magnetic field B [ mT ]")
plot([0,200],fit1([0,200]))

a = 0:1:200;
upperlower = confint(fit1);
ytop = upperlower(2,1).*a + upperlower(2,2);
ybot = upperlower(1,1).*a + upperlower(1,2);
patch([a fliplr(a)], [ytop fliplr(ybot)], [0.05,0.05,0.05],"FaceAlpha",...
    0.10,"EdgeColor","none")

legend("data","fit: (0.62\pm 0.05)\cdot V_H  - (19\pm 6)")
legend("Location","northwest")
set(gca,fontsize=20)
chi_red = sum(((fit1(V_hall_sensor)-B')./errb').^2)./(length(B)-1);
hold off