function R=Calcule_Cross_Correlation(filename,lim)

warning('off','all');
[y,fm] = audioread(filename);
x = Chirp_Generator();

% [ymax,indymax] = max(y);
% [r,lag] = xcorr(y(indymax-1000:indymax+2000),x);

[r,lag] = xcorr(y,x);
[ymax,indymax] = max(abs(r));
fm=44100;

%lag = lag.*(1/fm);
%lag = lag.*340.2900;
%lag = lag./2;
% figure;
% plot(abs(r));
% figure;
%plot(lag(indymax-100:indymax+1000),abs(r(indymax-100:indymax+1000)));

limsup=1000;
liminf=100;

env = abs(hilbert(r(indymax-liminf:indymax+limsup)));

P=findpeaks(lag(indymax-liminf:indymax+limsup),env,0,lim,0,3,3);
figure;
plot(lag(indymax-liminf:indymax+limsup),env);
hold on;
scatter(P(:,2),P(:,3));

% indymax = P(1,2).*(1/fm);
% indymax = P(1,2).*340.2900;
% indy2max = P(2,2).*(1/fm);
% indy2max = P(2,2).*340.2900;

R=P(4,2)-P(1,2);
R=R.*(1/fm);
R=R.*340.2900;

end 