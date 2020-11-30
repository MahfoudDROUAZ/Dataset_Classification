function[OnTFC, abs_OnTFC, OnTFC_real, OnTFC_imag, t, f] = Get_OnTFC_Voices(Xmes, t, f, F_max, nbref, lambda, beta)

Length = length(t);
abs_OnTFC = zeros(F_max,Length);
OnTFC_real = zeros(F_max,Length); 
OnTFC_imag = zeros(F_max,Length); 
Xest = zeros(1,Length);
e = zeros(1,Length);
abs_theta = zeros(1,Length);
theta_real = zeros(1,Length);
theta_imag = zeros(1,Length);

for j = 1:1:F_max % frequence du modele a estimer
 
    w1 = cos(2*pi*f(j)*t);    w2 = sin(2*pi*f(j)*t);
    
    Adc = 1/100;  a = 1/100;   b = 1/100;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    theta = [Adc a b]';
    
    R = zeros(length(theta),length(theta)); Q = zeros(length(theta),1);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for k = 1:1:Length
        phi = [1 w1(k) w2(k)]';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % le calcul le matrice m est commun pour les deux prochain algoritme
        m = 1 + phi'*diag(ones(1,length(phi)))*phi;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % Algorithme du gradient avec fonction de cout integrale et facteur d'oublie
        Xest(k) = theta' * phi;
        e(k) = Xmes(k) - Xest(k);
        R = (1-beta).*R + phi*phi'./m.^2;              % R appartient a R(n*n)
        Q = (1-beta).*Q + (phi.*Xmes(k))./m.^2;        % Q appartient a R(n*1)

        theta = theta - lambda.*(R*theta - Q);
    
        abs_theta(k) = sqrt(theta(2)^2+theta(3)^2);     % Module de vecteur estime
        Adc(k) = theta(1);
    
        theta_real(k) = theta(2);
        theta_imag(k) = theta(3);
    end

abs_OnTFC(1,:) = abs_OnTFC(1,:) + Adc;
abs_OnTFC(j+1,:) = abs_theta(1,:);

OnTFC_real(1,:) = OnTFC_real(1,:) + Adc; 
OnTFC_imag(1,:) = 0;
OnTFC_real(j+1,:) = theta_real(1,:); 
OnTFC_imag(j+1,:) = theta_imag(1,:); 
end

abs_OnTFC(1,:) = abs_OnTFC(1,:)./F_max;

OnTFC_real(1,:) = OnTFC_real(1,:)./F_max;
OnTFC = OnTFC_real + OnTFC_imag.*1i;
f = [0 f];
end