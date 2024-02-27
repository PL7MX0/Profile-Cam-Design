%{
    Dev: Pongsapat Lakrod (I-ME)

    Condition:
    Cam angle(°) | 0   45  90  135 180 225 270 315 360
    LOF          | 0    0  **   25  25  25  **   0   0
    
    ** is full rise or full return

    Results:
    1. Plot   s vs theta
    2. Plot cam profile
    3. Plot   v vs Theta
    4. Plot   a vs Theta
    5. Plot phi vs Theta
%}

clc

% Cam size
R_roller =  25 ;
R_prime  = 100 ;
LOF      =  25 ; % Lift of roller follower
Epsilon  =   0 ; % Eccentricity

Beta_1 = 135 - 45  ;
Beta_2 = 315 - 225 ;

% Set Interval & Resolution of degree
Max = 360 ;
Min = 0   ;
Number_of_point = 1001;
Step_size = (Max - Min)/(Number_of_point - 1);

% Data
Theta     = zeros(1,Number_of_point);
s         = zeros(1,Number_of_point);
v         = zeros(1,Number_of_point);
a         = zeros(1,Number_of_point);
R_profile = zeros(1,Number_of_point);
Phi       = zeros(1,Number_of_point);

R_prime_  = R_prime * ones(1,Number_of_point);
R_pitch   = zeros(1,Number_of_point);

% Generate Data
for i = 0:Number_of_point - 1
    Theta(i + 1) = (i * Step_size) + Min;

    if (Theta(i + 1) > 45) && (Theta(i + 1) < 135)
        s(i + 1) = LOF * (((Theta(i + 1) - 45) / Beta_1) - ( (0.5 / pi) * sin( 2 * pi * ((Theta(i + 1) - 45) / Beta_1) ) ));
        v(i + 1) = LOF / Beta_1 * (1 - cos( 2 * pi * ((Theta(i + 1) - 45) / Beta_1) ) );
        a(i + 1) = 2 * pi * LOF / (Beta_1 ^ 2) * sin( 2 * pi * ((Theta(i + 1) - 45) / Beta_1) ) ;

    elseif (Theta(i + 1) >= 135) && (Theta(i + 1) <= 225)
        s(i + 1) = LOF;

    elseif (Theta(i + 1) > 225) && (Theta(i + 1) < 315)
        s(i + 1) = LOF * (1 - ((Theta(i + 1) - 225) / Beta_2) + ( (0.5 / pi) * sin( 2 * pi * ((Theta(i + 1) - 225) / Beta_2) ) ) );
        v(i + 1) = - LOF / Beta_2 * (1 - cos( 2 * pi * ((Theta(i + 1) - 225) / Beta_2) ) );
        a(i + 1) = - 2 * pi * LOF / (Beta_2 ^ 2) * sin( 2 * pi * ((Theta(i + 1) - 225) / Beta_2) ) ;

    end

    R_profile(i + 1) = R_prime + s(i + 1) - R_roller;
    R_pitch(i + 1)   = R_prime + s(i + 1);
    Phi(i + 1) = rad2deg(atan2( v(i + 1) - Epsilon, s(i + 1) + sqrt( (R_prime ^ 2) - (Epsilon ^ 2) ) ));

    fprintf("%f , %f , %f , %f , %f , %f \n",Theta(i + 1) ,s(i + 1), v(i + 1), a(i + 1), R_profile(i + 1), Phi(i + 1));

end

% Plot Graph
figure(1)
nexttile
plot(Theta,s);
xlim([0 360])
xticks(linspace(0,360,9));
ylim([-30 30])
yticks(linspace(-30,30,7));
xlabel('Theta \theta')
ylabel('s - Cam Displacement')
grid on
grid minor
title('Cam Displacement s vs \theta')

nexttile
plot(Theta,v);
xlim([0 360])
xticks(linspace(0,360,9));
ylim([-0.6 0.6])
yticks(linspace(-0.6,0.6,7));
xlabel('Theta \theta')
ylabel('v - Cam Velocity')
grid on
grid minor
title('Cam Velocity v vs \theta')

nexttile
plot(Theta,a);
xlim([0 360])
xticks(linspace(0,360,9));
ylim([-0.05 0.05])
yticks(linspace(-0.05,0.05,7));
xlabel('Theta \theta')
ylabel('a - Cam Acceleration')
grid on
grid minor
title('Cam Acceleration a vs \theta')

nexttile
plot(Theta,Phi);
xlim([0 360])
xticks(linspace(0,360,9));
ylim([-0.3 0.3])
yticks(linspace(-0.3,0.3,7));
xlabel('Theta \theta')
ylabel('\Phi - Pressure Angle')
grid on
grid minor
title('Pressure Angle - \Phi vs \theta')


figure(2)
Theta_InRadius = deg2rad(Theta);
polarplot(Theta_InRadius, R_prime_, 'b--')

hold on
polarplot(Theta_InRadius, R_pitch, 'm--')
polarplot(Theta_InRadius, R_profile, 'r')
hold off

thetaticks(0:15:345)

legend(["R-Prime", "R-Pitch Curve", "R-Profile"]);

title('Cam Proflie')







