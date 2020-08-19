v = VideoReader('videoF.mp4');
v.CurrentTime = 0.0;
% Resolução do video -> LarguraxAltura
QNT_COLUNAS = 1080; % Largura do video
QNT_LINHAS = 1920; % Altura do video

qntFrames = 0;
while hasFrame(v) && qntFrames <= 100
    qntFrames = qntFrames + 1
    frame = readFrame(v);
    M(qntFrames, :, :, :) = frame(:, :, :);
end

for i = 1:QNT_LINHAS
    for j = 1:QNT_COLUNAS
        M2(i, j, :) = median(M(:, i, j, :));
    end
end

imwrite(M2, 'referenciaF.jpg');
