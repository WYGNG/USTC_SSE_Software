%%% input is the output of selectColor;
function output = addFrame_256_256_AdapPalette(P,I)
AA = I;
A = zeros(256,256,3);
for i = 1:128
    for j = 1:128
        A(2*i-1,2*j-1,:)=AA(i,j,:);
        A(2*i,2*j-1,:)=AA(i,j,:);
        A(2*i-1,2*j,:)=AA(i,j,:);
        A(2*i,2*j,:)=AA(i,j,:);
    end
end
A = uint8(A);
imshow(A);
figure;
I = zeros(268,268,3);
R = [255 0 0];
G = [0 255 0];
B = [0 0 255];
RG = [255 255 0];
RB = [255 0 255];
GB = [0 255 255];
WH = [255 255 255];
BL = [0 0 0];
sizeP = size(P);
nP = sizeP(1);

for j = 5:4:265  %上面彩行中的白
    for k = 1:3
    I(3,j,k) = 255;
    I(4,j,k) = 255;
    I(3,j+1,k) = 255;
    I(4,j+1,k) = 255;
    end
end
for j = 3:4:263  %右边彩行中的白
    for k = 1:3
    I(j,265,k) = 255;
    I(j,266,k) = 255;
    I(j+1,265,k) = 255;
    I(j+1,266,k) = 255;
    end
end
for j = 5:4:265  %左边彩行中的白
    for k = 1:3
    I(j,3,k) = 255;
    I(j,4,k) = 255;
    I(j+1,3,k) = 255;
    I(j+1,4,k) = 255;
    end
end
for j = 3:4:263  %下面彩行中的白
    for k = 1:3
    I(265,j,k) = 255;
    I(266,j,k) = 255;
    I(265,j+1,k) = 255;
    I(266,j+1,k) = 255;
    end
end

for i = 1:floor(66/nP)
    for j = 1:nP
        I(3,(i-1)*4*nP+(j-1)*4+3,:) = P(j,:);
        I(3,(i-1)*4*nP+(j-1)*4+4,:) = P(j,:);
        I(4,(i-1)*4*nP+(j-1)*4+3,:) = P(j,:);
        I(4,(i-1)*4*nP+(j-1)*4+4,:) = P(j,:);
    end
end

rest = 66 - floor(66/nP)*nP;
for k = 1:rest
    I(3,(i-1)*4*nP+(j-1)*4+k*4+3,:) = P(k,:);
    I(3,(i-1)*4*nP+(j-1)*4+k*4+4,:) = P(k,:);
    I(4,(i-1)*4*nP+(j-1)*4+k*4+3,:) = P(k,:);
    I(4,(i-1)*4*nP+(j-1)*4+k*4+4,:) = P(k,:);
end

for i = 1:floor(66/nP)
    for j = 1:nP
        I((i-1)*4*nP+(j-1)*4+3,3,:) = P(j,:);
        I((i-1)*4*nP+(j-1)*4+4,3,:) = P(j,:);
        I((i-1)*4*nP+(j-1)*4+3,4,:) = P(j,:);
        I((i-1)*4*nP+(j-1)*4+4,4,:) = P(j,:);
    end
end

% rest = 66 - floor(66/nP)*nP;
for k = 1:rest
    I((i-1)*4*nP+(j-1)*4+k*4+3,3,:) = P(k,:);
    I((i-1)*4*nP+(j-1)*4+k*4+4,3,:) = P(k,:);
    I((i-1)*4*nP+(j-1)*4+k*4+3,4,:) = P(k,:);
    I((i-1)*4*nP+(j-1)*4+k*4+4,4,:) = P(k,:);
end




for i = floor(66/nP):-1:1
    for j = 1:nP
        I((i-1)*4*nP+(j-1)*4+5+rest*4,265,:) = P(nP-j+1,:);
        I((i-1)*4*nP+(j-1)*4+6+rest*4,265,:) = P(nP-j+1,:);
        I((i-1)*4*nP+(j-1)*4+5+rest*4,266,:) = P(nP-j+1,:);
        I((i-1)*4*nP+(j-1)*4+6+rest*4,266,:) = P(nP-j+1,:);
    end
end

% rest = 66 - floor(66/nP)*nP;
for k = 1:rest
    I(k*4+1,265,:) = P(rest-k+1,:);
    I(k*4+2,265,:) = P(rest-k+1,:);
    I(k*4+1,266,:) = P(rest-k+1,:);
    I(k*4+2,266,:) = P(rest-k+1,:);
end


for i = floor(66/nP):-1:1
    for j = 1:nP
        I(265,(i-1)*4*nP+(j-1)*4+5+rest*4,:) = P(nP-j+1,:);
        I(265,(i-1)*4*nP+(j-1)*4+6+rest*4,:) = P(nP-j+1,:);
        I(266,(i-1)*4*nP+(j-1)*4+5+rest*4,:) = P(nP-j+1,:);
        I(266,(i-1)*4*nP+(j-1)*4+6+rest*4,:) = P(nP-j+1,:);
    end
end


for k = 1:rest
    I(265,k*4+1,:) = P(rest-k+1,:);
    I(265,k*4+2,:) = P(rest-k+1,:);
    I(266,k*4+1,:) = P(rest-k+1,:);
    I(266,k*4+2,:) = P(rest-k+1,:);
end




for k = 5:264 %中间白
    for p = 5:264
        for o = 1:3
        I(k,p,o)=255;
        end
    end
end



for i = 1:256   %中间填码
    for j = 1:256
        I(i+6,j+6,:) = A(i,j,:);
    end
end

for j = 3:4:267  %最外圈
    for k = 1:3
    I(j,1,k) = 255;
    I(j,2,k) = 255;
    I(j+1,1,k) = 255;
    I(j+1,2,k) = 255;
    end
end
for j = 3:4:267
    for k = 1:3
    I(1,j,k) = 255;
    I(2,j,k) = 255;
    I(1,j+1,k) = 255;
    I(2,j+1,k) = 255;
    end
end
for j = 1:4:265
    for k = 1:3
    I(j,267,k) = 255;
    I(j,268,k) = 255;
    I(j+1,267,k) = 255;
    I(j+1,268,k) = 255;
    end
end
for j = 1:4:265
    for k = 1:3
    I(267,j,k) = 255;
    I(268,j,k) = 255;
    I(267,j+1,k) = 255;
    I(268,j+1,k) = 255;
    end
end


for i = 1:256
    for j = 1:256
        I(i+6,j+6,:) = double(A(i,j,:));
    end
end
for i = 5:264
    I(i,5,:) = 0;
    I(i,6,:) = 0;
end

for i = 5:264
    I(5,i,:) = 0;
    I(6,i,:) = 0;
end

for i = 5:264
    I(264,i,:) = 0;
    I(263,i,:) = 0;
end

for i = 5:264
    I(i,264,:) = 0;
    I(i,263,:) = 0;
end


I = uint8(I);
imshow(I)
output = I;
end