% Last modified: 3/23/2016 by xyzhao
%                ,
%              _/((
%     _.---. .'   `\
%   .'      `     ^ T=     把colors里面的颜色画出小方块来, 返回小方块们的一个
%  /     \       .--'      图片的矩阵; Draw a picture of input 'colors', 
% |      /       )'-.      return a matrix of this picture. The block of 
% ; ,   <__..-(   '-.)     each color is of size 'blocksize'.
%  \ \-.__)    ``--._)
%   '.'-.__.-.
%     '-...-'
% 

function palette = drawpalette(colors)
    blocksize = 25; %
    [colornum, ~] = size(colors);
    palette = zeros(blocksize*colornum,blocksize,3);
    for i = 1:blocksize*colornum
        for j = 1:blocksize
            palette(i,j,:) = uint8(colors(ceil(i/blocksize),:));
        end
    end
end