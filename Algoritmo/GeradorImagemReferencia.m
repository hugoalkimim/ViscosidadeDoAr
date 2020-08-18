v = VideoReader('vidF.mp4');

v.CurrentTime = 59.0;

qntFrames = 0;
while hasFrame(v) && qntFrames < 150
    qntFrames = qntFrames + 1
    frame = readFrame(v);
    M(qntFrames, :, :, :) = frame(:, :, :);
end

for i = 1:1920
    for j = 1:1080
        M2(i, j, :) = median(M(:, i, j, :));
    end
end

imwrite(M2, 'referenciaF.jpg');
