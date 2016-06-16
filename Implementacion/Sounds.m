%Prueba a 1 metro

filename1 = '/media/santiago/Stuff/Carrera/5 Año/9° Cuatrimestre/PDS_Recursado/Proyecto/Sonidos/Prueba_1m.wav';
Calcule_Distance(filename1,1);

%Pruebas a 2 metros

filename2 = '/media/santiago/Stuff/Carrera/5 Año/9° Cuatrimestre/PDS_Recursado/Proyecto/Sonidos/Prueba_2m1.wav';
Calcule_Distance(filename2,1);

filename3 = '/media/santiago/Stuff/Carrera/5 Año/9° Cuatrimestre/PDS_Recursado/Proyecto/Sonidos/Prueba_2m2.wav';
Calcule_Distance(filename3,1);

%Pruebas a 1.5 m

filename4 = '/media/santiago/Stuff/Carrera/5 Año/9° Cuatrimestre/PDS_Recursado/Proyecto/Sonidos/Prueba_15m.wav';
Calcule_Distance(filename4,1);

%Prueba artificial

x = Chirp_Generator(0);
pure_sample = Chirp_Sample(x,2,0.5,0,0);
Calcule_Distance(pure_sample,0);