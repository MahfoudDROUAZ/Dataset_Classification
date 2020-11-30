function[Betas_OnTFC] = Get_OnTFC_Voices_Betas(Xmes, t, f, F_max, lambda, beta, index_ON)

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
        
    end

abs_OnTFC(j,:) = abs_theta(1,:);

end

abs_OnTFC_voices = zeros(1,Length);
OnTFC_voices_norm = zeros(1,Length); Betas_OnTFC = zeros(1,1);

for i=1:1:F_max
    abs_OnTFC_voices(i,:) = abs_OnTFC(i,:);
    OnTFC_voices_norm(i,:) = ((abs_OnTFC_voices(i,:) - min(abs_OnTFC_voices(i,:)))./(max(abs_OnTFC_voices(i,:)) - min(abs_OnTFC_voices(i,:))))+0.0001;
    Betas_OnTFC(i,1) = -sum((OnTFC_voices_norm(i,index_ON:index_ON+4000).^2).*log(OnTFC_voices_norm(i,index_ON:index_ON+4000).^2));
end

end