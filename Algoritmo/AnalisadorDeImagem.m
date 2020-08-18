% Le o video
v = VideoReader('vidF.mp4');

v.CurrentTime = 59.0;

saida = VideoWriter('saida2.mp4', 'MPEG-4');
open(saida);

% Imagem/frame que será utilizada para verificar o deslocamento da esfera
ref = cast(imread('referenciaF.jpg'), 'int32');

maiord = 0;
maiori = 0;
qntFrames = 0;

frameT = readFrame(v);

while hasFrame(v)
    qntFrames = qntFrames + 1;
    antigoMaiori = maiori;
    maiori = 1;
    vidFrame = readFrame(v);
    frame = cast(vidFrame, 'int32');
    
    qntFrames % Imprime o frame que está sendo executado atualmente.
    
    % Quantidade de pixels diferentes no frame. Utilizado apenas em testes.
    qntDiferentes = 0;
    
    % Determina um intervalo de linhas que serão analisadas pelo algoritmo
    iMin = 200;
    iMax = 1600;
    
    if(qntFrames > 10000)
        iMin = max(iMin, antigoMaiori - 50);
        iMax = min(iMax, antigoMaiori + 50);
    elseif(qntFrames > 3000)
        iMin = max(iMin, antigoMaiori - 75);
        iMax = min(iMax, antigoMaiori + 75);
    elseif(qntFrames > 10)
        iMin = max(iMin, antigoMaiori - 100);
        iMax = min(iMax, antigoMaiori + 100);
    end
    
    for i = iMin:iMax
        qntd = 0; % Salva a quantidade de pixels diferentes na linha
        pixelsC = 0; % Salva o tamanho de uma sequencia contigua pixels diferentes(não é utilizado atualmente)
        for j = 512:528
            distanciaAoQuadrado = (frame(i, j, 1) - ref(i, j, 1)) * (frame(i, j, 1) - ref(i, j, 1)) + (frame(i, j, 2) - ref(i, j, 2)) * (frame(i, j, 2) - ref(i, j, 2)) + (frame(i, j, 3) - ref(i, j, 3)) * (frame(i, j, 3) - ref(i, j, 3));
            
            % Trata os pixels como pontos em um espaço 3D e calcula a
            % distancia euclidiana entre o pixel do frame do video atual e
            % o equivalente do frame de referência
            if(distanciaAoQuadrado > 2000)
                pixelsC = pixelsC + 1;
                qntd = qntd + 1;
                qntDiferentes = qntDiferentes + 1;
                vidFrame(i,j, :) = [255, 0, 0];
                % Quantidade de pixels diferentes para considerar que a esfera
                % passa por esta linha.
                % Frames com muito ruído podem gerar um falso positivo
                if qntd > 1
                    maiori = max(maiori, i);
                end
                continue;
            else
                pixelsC = 0;
            end
            
        end
        maiord = max(maiord, qntd);
    end
    
    % Desenha uma linha vermelha caso a esfera esteja descendo e uma linha
    % verde caso esteja subindo
    for z = 1:1080
        if(antigoMaiori - maiori < 0)
            vidFrame(maiori, z, :) = [255, 0, 0];
        else
            vidFrame(maiori, z, :) = [0, 255, 0];
        end
    end
    
    writeVideo(saida, vidFrame);
    
    % Calcula a altura da esfera de acordo com a linha contida na variável
    % 'maiori'
    y(qntFrames) = 90 + (1598 - max(maiori, 1183)) / 51.5 * 10;
    if(maiori < 1183)
        y(qntFrames) = y(qntFrames) + (1183 - max(maiori, 825)) / 51.1 * 10;
    end
    
    if(maiori < 825)
        y(qntFrames) = y(qntFrames) + (1183 - max(maiori, 462)) / 51.7 * 10;
    end
end

close(saida);
