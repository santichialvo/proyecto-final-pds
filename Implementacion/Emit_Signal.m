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

tf = 3;      %Duracion del pulso
dt = 1/fm;
t = 0:dt:tf-dt; %Vector en el dominio temporal
rec = record(tf,fm);
figure;
plot(t,rec);
%sound(rec,fm);

%Correlacion cruzada de la señal ventaneada
[r,lag] = xcorr(abs(rec),abs(x));   %%me parece que hay un error en esta parte. Porque abs?

%%CONSIDERAR LA PARTE DEL PAPER PARA EL ENVELOP:
%%Calculate the envelope of the cross correlation by calculating the 
%%analytic signal of the frequency domain multiplication of the pulse and 
%%the received signal. The analytic signal is calculated by setting the 
%%negative frequencies to zero and doubling the positive frequencies.
%%Once the analytic signal has been calculated the absolute value of the 
%%inverse Fourier transform is calculated to determine the final envelope.

%%Me parece que todo ese calculo de hace 0 lo negativo y doblar lo positivo
%%(analityc signal) se le aplica al producto de las transformadas de 
%%fourier de las señales (que se usan para la cross-correlation). Luego a 
%%eso se le calcula la inversa y lo que se obtiene ahi es el
%%cross-correlation de las señales.

%% https://en.wikipedia.org/wiki/Analytic_signal (wikipedia FTW!)

figure;
plot(lag,abs(r));
