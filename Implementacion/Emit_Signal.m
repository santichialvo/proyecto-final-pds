clear;
x = Chirp_Generator();
fm = 44100;
nbits = 8;
channels = 1;

sleep(1);

#player = audioplayer(x, fm, nbits);
#playblocking(player);
sound(x,fm);

#rec = audiorecorder(fm,nbits,channels);

#recordblocking(rec,1);
#disp('End of recording. Playing back ...');

#play(rec);

tf = 3;      #Duracion del pulso
dt = 1/fm;
t = 0:dt:tf-dt; #Vector en el dominio temporal
rec = record(tf,fm);
figure;
plot(t,rec);
#sound(rec,fm);

[r,lag] = xcorr(abs(rec),abs(x));#Correlacion cruzada de la señal ventaneada

figure;
plot(lag,abs(r));



