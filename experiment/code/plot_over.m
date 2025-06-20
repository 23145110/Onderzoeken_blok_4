l1t20 = zeros(1,8);
l2t20 = zeros(1,8);
err_l1t20 = zeros(1,8);
err_l2t20 = zeros(1,8);
csIt20 = 1.3:0.1:2;

for n = 15
    fitexp = "C1*exp(l1*t)+C2*exp(l2+t)";
    % fitexp = replace(fitexp,"l1","(-B+sqrt(B^2-A^2))");
    % fitexp = replace(fitexp,"l2","(-B-sqrt(B^2-A^2))");
    fty = fittype(fitexp,"independent","t");

    fitt20 = fit(ts_clean{n},thetas_clean{n},fty,'StartPoint',[-100,-100.5,0,0],upper=[+Inf,50,+Inf,5],lower=[-Inf,-Inf,-Inf,-5]);
    l1t20(n-12) = fitt20.l1;
    l2t20(n-12) = fitt20.l2;

    cconf = confint(fitt20);
    err_l1t20(n-12) = abs(cconf(1,3)-cconf(2,3))/2; % assumes symetric errors
    cconf = confint(fitt20);
    err_l2t20(n-12) = abs(cconf(1,4)-cconf(2,4))/2; % assumes symetric errors
end

scatter(ts_clean{n},thetas_clean{n},0.7)
hold on
grid on
legend("theta")
plot(ts_clean{n},fitt20(ts_clean{n}))
ylim([-pi,pi])
xlabel("time $t$ [ s ]",Interpreter="latex")
ylabel("angle $\theta$ [ rad ]", Interpreter="latex")
legend("Movement data","fit: $\theta$ ="+ f(" {fitt20.C1}*exp({fitt20.l1}*t){fitt20.C2}*exp({fitt20.l2}+t)"),"Interpreter","latex")
set(gca,Fontsize=20)
hold off