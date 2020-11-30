function[abs_theta] = Get_Adaline_Voices(Xmes, t, lambda, beta)

Length = length(t);
Xest = zeros(1,Length);
e = zeros(1,Length);
abs_theta = zeros(1,1);
f_mes = 50; % frequence du signal mesure ou simule
for i=0:1:9
    w1(i+1,:) = cos(2*pi*(2*i+1)*f_mes*t);    w2(i+1,:) = sin(2*pi*(2*i+1)*f_mes*t);
end
    Adc = 1/100;  a = 1/100;   b = 1/100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for i=1:1:10
    a(i) = 1;   b(i) = 1;
    end

    theta  = [Adc a(1) b(1) a(2) b(2) a(3) b(3) a(4) b(4) a(5)  b(5)...
              a(6) b(6) a(7) b(7) a(8) b(9) a(9) b(9) a(10) b(10)]'./100;
    R = zeros(length(theta),length(theta)); Q = zeros(length(theta),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for k=1:1:Length
    
    phi = [1 w1(1,k) w2(1,k) w1(2,k) w2(2,k) w1(3,k) w2(3,k) w1(4,k) w2(4,k) w1(5,k)  w2(5,k)...
             w1(6,k) w2(6,k) w1(7,k) w2(7,k) w1(8,k) w2(8,k) w1(9,k) w2(9,k) w1(10,k) w2(10,k)]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %le calcul le matrice m est commun pour les deux prochain algoritme
    m = 1 + phi'*diag(ones(1,length(phi)))*phi;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
     % Algorithme du gradient avec fonction de cout integrale et facteur d'oublie
    Xest(k) = theta' * phi;
    e(k) = Xmes(k) - Xest(k);
    Rderive = -beta.*R + phi*phi'./m.^2;              % R appartient a R(n*n) 
    Qderive = -beta.*Q + (phi.*Xmes(k))./m.^2;        % Q appartient a R(n*1)
    R = R + Rderive;
    Q = Q + Qderive;
    theta = theta - lambda.*(R*theta - Q);
    for i=1:1:10
        abs_theta(i,k) = sqrt(theta(2*i)^2+theta(2*i+1)^2);
    end
end
end