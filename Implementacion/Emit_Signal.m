clear;

%%Chirp_Generator me devuelve el chirrido genrado, ventaneado con hanning,
%%que voy a reproducir apra escuchar el eco.
x = Chirp_Generator();

fm = 44100;
%nbits = 8;
%channels = 1;

sleep(1);

%player = audioplayer(x, fm, nbits);
%playblocking(player);
sound(x,fm);

%rec = audiorecorder(fm,nbits,channels);

%recordblocking(rec,1);
%disp('End of recording. Playing back ...');

%play(rec);

tf = 2;      %Duracion del pulso
dt = 1/fm;
t = 0:dt:tf-dt; %Vector en el dominio temporal
N = length(t);
df = fm/N;             %Resolucion frecuencial
freq_v=0:df:fm-df; %Vector en el dominio frecuencial

rec = record(tf,fm);
figure;
subplot(2,1,1);
#plot(t,rec);
fftrec = fft(rec);
fftrec(1:(2001/df))=0;
fftrec((fm-2000)/df:fm/df)=0;
plot(freq_v,abs(fftrec));
rec = ifft(fftrec);
sound(rec,fm);

%Correlacion cruzada de la senial ventaneada
[r,lag] = xcorr(rec,x);

%%CONSIDERAR LA PARTE DEL PAPER PARA EL ENVELOP:
%%Calculate the envelope of the cross correlation by calculating the 
%%analytic signal of the frequency domain multiplication of the pulse and 
%%the received signal. The analytic signal is calculated by setting the 
%%negative frequencies to zero and doubling the positive frequencies.
%%Once the analytic signal has been calculated the absolute value of the 
%%inverse Fourier transform is calculated to determine the final envelope.

%%Me parece que todo ese calculo de hace 0 lo negativo y doblar lo positivo
%%(analityc signal) se le aplica al producto de las transformadas de 
%%fourier de las seniales (que se usan para la cross-correlation). Luego a 
%%eso se le calcula la inversa y lo que se obtiene ahi es el
%%cross-correlation de las seniales.

%% https://en.wikipedia.org/wiki/Analytic_signal (wikipedia FTW!)

#Es mas facil que eso: 
#envelope = abs(hilbert(x)) 
#zip zap termine, eso es calcular un envelope

subplot(2,1,2);
plot(lag,abs(r));