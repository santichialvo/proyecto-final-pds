%% Funcion para generar una señal con los mismo chirridos a fin de obtener una muestra
%% pura para el analisis

function [sample] = Chirp_Sample(x,dist_eco,intensidad,doplot,SNR)
  %% X corresponde al Chirrido sin ruido
  %% dist_eco, la distancia del eco respecto al chirrido original, maximo 343 metros
  %% intensidad, para graduar la perdida de energia del eco
  
  Ft = 44100;
  dt = 1/Ft;

  sample = zeros(Ft,1);

  %%340.29 m/s - Velocidad del sonido
  velS = 340.29;

  %%Esta funcion devuelve un entero correspondiente a la posicion en el
  %%arreglo que le corresponde al chirrido, considera 2 veces la distancia
  %%deseada por corresponder el eco que va y vuelve.
  origen = 1;
  fin_origen = length(x);
  
  eco = floor(((2*dist_eco)/velS)/dt);
  fin_eco = eco+length(x);
  
  sample(origen:fin_origen) = x;
  sample(eco:fin_eco-1) = x*intensidad;

  tS = 0:dt:1-dt;
  
  %% Agrego ruido aleatorio tal que la SNR sea igual al valor dado
  
  ls = length(sample);
  potencia_sample = 1/ls * sum(sample.^2);
  %Genero un ruido aleatorio
  r1 = randn(size(sample));
  lr = length(r1);
  potencia_r = 1/lr * sum (r1.^2);
  
  alpha_snr = sqrt(potencia_sample / (e^(SNR/10)*potencia_r));
  
  r1 = (alpha_snr)*r1;
  potencia_r = 1/lr * sum (r1.^2);
  
  SNR = 10*log(potencia_sample/potencia_r);
  disp(['SNR: ',num2str(SNR)]);
  
  sample = sample+r1;

  if (doplot)
    figure;
    plot(tS,sample)
    hold on
  end
end