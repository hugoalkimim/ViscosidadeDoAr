% Define o arquivo de entrada.
v = VideoReader('videoF.mp4');

% Define o arquivo de saída.
saida = VideoWriter('saida.mp4', 'MPEG-4');
open(saida);

% Inicio dos parametros
v.CurrentTime = 0.0; % Tempo em segundos em que o vídeo deverá começar a ser analisado
TOLERANCIA_DIFERENCA_PIXELS = 0.02; % Tolerancia de diferença entre cada pixel. Colocar valor entre 0 e 1
QNT_MAX_PIXELS_DIFERENTES = 1; % Máximo de pixels diferentes em uma linha. Utilizar valores maiores caso exista frames com muito ruido.
QNT_COLUNAS = 1080; % Largura do video
QNT_LINHAS = 1920; % Altura do video
% Área do frame que deverá ser analisada. Uma otimização feita
% posteriormente limita ainda mais as linhas que serão analisadas.
LINHA_MAIS_ALTA = 200;
LINHA_MAIS_BAIXA = 1600;
COLUNA_MAIS_A_ESQUERDA = 510;
COLUNA_MAIS_A_DIREITA = 535;
% Fim dos parametros

% Imagem que será utilizada para verificar o deslocamento da esfera
ref = cast(imread('referenciaF.jpg'), 'int32');

maiori = 0;
qntFrames = 0;

% Roda o algoritmo para todos os frames a partir do atual
while hasFrame(v)
    qntFrames = qntFrames + 1;
    antigoMaiori = maiori;
    maiori = 1;
    vidFrame = readFrame(v);
    frame = cast(vidFrame, 'int32');
    
    qntFrames % Imprime o frame que está sendo executado atualmente.
    
    % Determina um intervalo de linhas que serão analisadas pelo algoritmo
    iMin = LINHA_MAIS_ALTA;
    iMax = LINHA_MAIS_BAIXA;
    
    % Otimização que  limita a análise do algoritmo apenas para linhas
    % próximas da ultima medida de acordo com o tempo.
    if(qntFrames > 10000)
        iMin = max(iMin, antigoMaiori - 25);
        iMax = min(iMax, antigoMaiori + 25);
    elseif(qntFrames > 5000)
        iMin = max(iMin, antigoMaiori - 50);
        iMax = min(iMax, antigoMaiori + 50);
    elseif(qntFrames > 1000)
        iMin = max(iMin, antigoMaiori - 75);
        iMax = min(iMax, antigoMaiori + 75);
    elseif(qntFrames > 100)
        iMin = max(iMin, antigoMaiori - 100);
        iMax = min(iMax, antigoMaiori + 100);
    end
    % Fim da otimização
    
    for i = iMin:iMax
        qntD = 0; % Salva a quantidade de pixels diferentes na linha
        for j = COLUNA_MAIS_A_ESQUERDA:COLUNA_MAIS_A_DIREITA
            distanciaAoQuadrado = (frame(i, j, 1) - ref(i, j, 1)) * (frame(i, j, 1) - ref(i, j, 1)) + (frame(i, j, 2) - ref(i, j, 2)) * (frame(i, j, 2) - ref(i, j, 2)) + (frame(i, j, 3) - ref(i, j, 3)) * (frame(i, j, 3) - ref(i, j, 3));
            
            % Trata os pixels como pontos em um espaço 3D e calcula a
            % distancia euclidiana entre o pixel do frame do video atual e
            % o equivalente do frame de referência
            if(distanciaAoQuadrado > 195075 * TOLERANCIA_DIFERENCA_PIXELS)
                vidFrame(i,j, :) = [255, 0, 0];
                % Quantidade de pixels diferentes para considerar que a esfera
                % passa por esta linha.
                % Frames com muito ruído podem gerar um falso positivo
                qntD = qntD + 1;
                if qntD > QNT_MAX_PIXELS_DIFERENTES
                    maiori = max(maiori, i);
                end
            end
        end
    end
    
    % Desenha uma linha vermelha caso a esfera esteja descendo e uma linha
    % verde caso esteja subindo
    for z = 1:QNT_COLUNAS
        if(antigoMaiori - maiori < 0)
            vidFrame(maiori, z, :) = [255, 0, 0];
        else
            vidFrame(maiori, z, :) = [0, 255, 0];
        end
    end
    
    writeVideo(saida, vidFrame);
    
    alturaEmPixels(qntFrames) = maiori; % Altura da esferaem pixels
    % Calcula a altura da esfera de acordo com a linha contida na variável
    % 'maiori'
    alturaEsfera(qntFrames) = 90 + (1598 - max(maiori, 1183)) / 51.5 * 10;
    if(maiori < 1183)
        alturaEsfera(qntFrames) = alturaEsfera(qntFrames) + (1183 - max(maiori, 825)) / 51.1 * 10;
    end
    
    if(maiori < 825)
        alturaEsfera(qntFrames) = alturaEsfera(qntFrames) + (1183 - max(maiori, 462)) / 51.7 * 10;
    end
end

close(saida);
