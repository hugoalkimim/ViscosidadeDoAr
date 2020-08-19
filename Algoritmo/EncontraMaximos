%Script Matlab para encontrar os máximos locais de uma função
%quasiperiódica 
%(ver wikipedia: https://en.wikipedia.org/wiki/Quasiperiodic_function) 
%alturaEsfera: posição da mola obtida no experimento.  
tamanhoVetor = size(alturaEsfera); % Mede o tamanho do vetor
tamanhoVetor = tamanhoVetor(1, 2);
qntMaximos = 1;

if alturaEsfera(1) < alturaEsfera(2)
    subindo = 1;
else
    subindo = 0;
end

for i = 3:tamanhoVetor
    if(alturaEsfera(i - 1) > alturaEsfera(i) && subindo == 1)
        subindo = 0;
        maximos(qntMaximos) = alturaEsfera(i - 1); % Maximos são as amplitudes locais
        tempo(qntMaximos) = (i - 1) / 30; % Tempo associado a cada amplitude local
        if qntMaximos > 1
            tempoDif(qntMaximos - 1) = tempo(qntMaximos) - tempo(qntMaximos - 1);
        end
        qntMaximos = qntMaximos + 1;
    end
    
    if(alturaEsfera(i - 1) < alturaEsfera(i))
        subindo = 1;
    end
end
