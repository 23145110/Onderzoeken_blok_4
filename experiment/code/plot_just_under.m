cst14 = zeros(1,6);
err_cst14 = zeros(1,6);
csIt14 = 0.8:0.1:1.3;

for n = 9
    fitexp = "exp(-B*t)*(C1*cos(A*t)+C2*sin(A*t))";
    fty = fittype(fitexp,"independent","t");

    fitt14 = fit(ts_clean{n},thetas_clean{n},fty,'StartPoint',[0,0.5,-pi/2,-pi/2],lower=[0,0,-Inf,-Inf],upper=[Inf,Inf,Inf,Inf]);
    cst14(n-7) = fitt14.B;

    cconf = confint(fitt14);
    err_cst14(n-7) = abs(cconf(1,2)-cconf(2,2))/2; % assumes symetric errors
end

scatter(ts_clean{n},thetas_clean{n},1)
hold on
grid on
legend("theta")
plot(ts_clean{n},fitt14(ts_clean{n}))
ylim([-pi,pi])
xlabel("time $t$ [ s ]",Interpreter="latex")
ylabel("angle $\theta$ [ rad ]", Interpreter="latex")
legend("motion data","fit: $\theta$ ="+ f(" exp(-{fitt14.B}t)({fitt14.C1}cos({fitt14.A}t){fitt14.C2:%0.3f}sin({fitt14.A}t))"),"Interpreter","latex")
set(gca,Fontsize=20)
hold off