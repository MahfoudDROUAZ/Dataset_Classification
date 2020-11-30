function y= Sejdic_ST(x,fe,fmin,fmax)
%Impl?mentation de la transform?e de Stockwell version Sejdic et al. [08]
% tic;
M=length(x);
if mod(M,2)~=0
    M=M-1;
end
tw = fliplr([1:floor(M/2) -floor(M/2)+1:0])/M;

Fx=fft(x);
XF = [Fx Fx];
Factor = linspace(0.7,1.5,100);
P=Factor;
%P=0.72;
CM = zeros(1,length(P));
Pas1=round((fmin*M/fe));
Pas=(fmax*M/fe);
 for h = 1:length(P)
    for f = 1:Pas

        p = P(h);
      %  p=1;
        wind = ((f^(p))/sqrt(2*pi))*exp(-0.5*(f^(2*p))*tw.^2);
      % wind = ((f)/(sqrt(2*pi)*p))*exp(-0.5*(1/p^2)*(f^2)*tw.^2); %moukadem
        %wind = wind/(sum(wind)+10^(-25));
      wind = wind/(sum(wind));
        W = fft(wind);
        X1(f+1,:) = ifft(XF(f+1:f+M).*W);
    end
   X1p = X1/sqrt(sum(sum(X1.*conj(X1))));
   CM(h)=1/sum(sum(abs(X1p)));

 end
Fx=fft(x);
XF = [Fx Fx];
% CM
CMp=max(CM);

PTI = P(find(CM==max(CM)));
p = PTI
 %p=0.64;
    for f = 1:Pas
        %  p=1; 
         wind = ((f^(p))/sqrt(2*pi))*exp(-0.5*(f^(2*p))*tw.^2);
          % wind = ((f)/(sqrt(2*pi)*p))*exp(-0.5*(1/p^2)*(f^2)*tw.^2); %moukadem
            %wind=((f)/(sqrt(2*pi)*(m*f+k)))*exp(-0.5*(1/((m*f+k).^2))*(f^2)*tw.^2);
          wind = wind/(sum(wind)+10^(-25));
          W = fft(wind);
          XPTI(f+1,:) = ifft(XF(f+1:f+M).*W);
    end
 X1=XPTI;
 imagesc(abs(XPTI));
 X1p = X1/sqrt(sum(sum(X1.*conj(X1))));
 CM=1/sum(sum(abs(X1p)));
 y=XPTI;
%toc
end