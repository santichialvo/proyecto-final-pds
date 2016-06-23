%Primer subcomponente, donde se genera el chirp

%Devuelvo el chirp ventaneado para mandar el eco y que, al hacer la correlacion,
%evitar que se formen lobulos en el espectro.
function win_x = Chirp_Generator(doplot)

doplot = 0;             %Booleano para plotear 
f0 = 4000;              %Frecuencia inicial
f1 = 8000;              %Frecuencia final
t1 = 0.01;              %Duracion del pulso
phi0 = 0;               %Angulo de fase
fm = 44100;             %Frecuencia de muestreo
dt = 1/fm;              %DeltaT

k = (f1-f0)/t1;         %Chirp Rate (Que tan rapido la frecuencia se incrementa)

t = 0:dt:t1-dt;         %Vector en el dominio temporal
N = length(t);          %Longitud del vector t

x = sin(phi0 + 2*pi*(f0*t + (k/2)*t.^2));

if (doplot)
  figure;
  plot(t,x);
  xlabel('Tiempo (s)');
end

df = fm/N;              %Resolucion frecuencial
freq_v=0:df:(fm/2)-df;  %Vector en el dominio frecuencial

fftx = fft(x);          %Transformada de Fourier
fftx = abs(fftx);

if (doplot)
  figure;
  plot(freq_v,fftx(1:(length(fftx)/2)));
  xlabel('Frecuencia (Hz)');
end

[r,lag] = xcorr(x);     %Autocorrelacion de la señal original

if (doplot)
  figure;
  plot(lag,abs(r));
  xlabel('Lag');
  ylabel('Valor absoluto de la autocorrelacion');
end

H = Hanning(N);         %Ventana de Hanning de N muestras
win_x = H.*x;           %Proceso de ventaneo

if (doplot)
  figure;
  plot(t,win_x);
  xlabel('Tiempo (s)');
  ylabel('Amplitud');
end

fft_winx = fft(win_x);  %Calculo la fft de la señal ventaneada
fft_winx = abs(fft_winx);

if (doplot)
  figure;
  plot(freq_v,fft_winx(1:(length(fft_winx)/2)));
end

[r,lag] = xcorr(win_x); %Correlacion cruzada de la senial ventaneada

if (doplot)
  figure;
  plot(lag,abs(r));
  xlabel('Lag');
  ylabel('Valor absoluto de la autocorrelacion');
end

end