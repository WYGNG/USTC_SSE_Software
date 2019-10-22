% Last modified: 3/23/2016 by xyzhao
%                ,
%              _/((
%     _.---. .'   `\
%   .'      `     ^ T=     ��colors�������ɫ����С������, ����С�����ǵ�һ��
%  /     \       .--'      ͼƬ�ľ���; Draw a picture of input 'colors', 
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