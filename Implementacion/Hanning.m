%Funcion utilizada para generar una ventana de Hanning

function y = Hanning(N)

    y = zeros(length(N),1);

    for i=1:N
      y(i) = 0.5 * (1 - cos((2*pi*i)/(N-1)));
    end

end