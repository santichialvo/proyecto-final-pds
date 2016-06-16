function Calcule_Distance(filename,Modo)

warning('off','all');                %Desactivo warnings molestas
pkg load signal;                     %Cargar el paquete de señales
doplot = 1;                          %Booleano para generar graficas

%Parte 1 - Lectura del archivo de audio y generacion del chirp

if (Modo == 1)
  [y,fm] = audioread(filename);
else
  y = filename;
end

x = Chirp_Generator(doplot);

%Parte 2 - Aplicacion de filtro tipo Butterworth pasa banda (4000Hz - 8000Hz)

fm=44100;

Wp = [4000 8000]/(fm/2);             %Banda de paso
Ws = [3000 10000]/(fm/2);            %Banda de rechazo
Rp = 3;                              %Atenuacion en dB de la banda de paso
Rs = 40;                             %Atenuacion en dB de la banda de rechazo
[n,Wn] = buttord(Wp,Ws,Rp,Rs);       %Calculo el orden optimo del filtro
[b,a] = butter(n,Wn);                %Coeficientes del filtro

if (doplot)
  figure;
  [h,f] = freqz(b,a,[],fm);          %Repuesta en frecuencia (Para graficar)
  plot(f,abs(h));
  title('Respuesta en frecuencia del filtro');
end

yfilt = filter(b,a,y);               %Proceso de filtrado de señal y


if (doplot)
  df = fm/length(y);                 %Resolucion frecuencial
  dv = [0:df:fm-df];                 %Vector en frecuencias

  ffty = fft(y);
  figure;
  plot(dv,ffty);                     %Grafica del espectro sin el filtro
  title('Espectro de la señal sin el filtro');
  fftyfilt = fft(yfilt);
  figure;
  plot(dv,fftyfilt);                 %Grafica del espectro con el filtro
  title('Espectro de la señal con el filtro');
end

y = yfilt;                           %De aqui en adelante trabajo con la señal filtrada

%Parte 3 - Correlacion cruzada para detectar los picos

xzeros = [zeros(1,length(y)-length(x)),x];  %Genero este vector con el chirp y ceros de la misma longitud que la señal de entrada
[r,lag] = xcorr(y,xzeros,'unbiased');       %Correlacion cruzada sin bias

if (doplot)
  figure;
  plot(lag,abs(r));
  title('Correlacion cruzada de la señal');
end

[ymax,indymax] = max(abs(r));        %Busco el maximo en la correlacion (Corresponde a la emision del chirp)

limsup=2000;                         %Limite superior para graficar
liminf=100;                          %Limite inferior para graficar

if (doplot)
  figure;
  plot(lag(indymax-liminf:indymax+limsup),abs(r(indymax-liminf:indymax+limsup)));
  title('Correlacion cruzada de la señal centrada en el pico princial');
end

%Parte 4 - Calculo de la envolvente y busqueda de picos

env = abs(hilbert(r(indymax-liminf:indymax+limsup))); %Envoltorio de ese tramo de la señal

lim = 0;
P = findpeaks(lag(indymax-liminf:indymax+limsup),env,0,lim,0,3,3); %Funcion para busqueda de picos maximos

if (doplot)
  figure;
  plot(lag(indymax-liminf:indymax+limsup),env);
  hold on;
  scatter(P(:,2),P(:,3));
  title('Envoltorio de la correlacion cruzada de la señal y los picos detectados');
end

%Parte 5 - Deteccion de picos mas relevantes

Tolerancia = 0.5;
Distancia = 0;
VelocidadSonido = 340.29;


[YPico1,IndYPico1] = max(P(:,3));
P(IndYPico1,3) = -1;
Pico1 = P(IndYPico1,2);

while (Distancia < Tolerancia)

  [YPico2,IndYPico2] = max(P(:,3));
  P(IndYPico2,3) = -1;

  Pico2 = P(IndYPico2,2);

  Distancia = Pico2-Pico1;
  Distancia = Distancia*(1/fm);
  Distancia = Distancia*VelocidadSonido;
  Distancia = Distancia/2;

end

if (doplot)
  scatter(Pico1,YPico1,'r');
  scatter(Pico2,YPico2,'r');
end

printf('Distancia: %s \n',num2str(Distancia));

end 