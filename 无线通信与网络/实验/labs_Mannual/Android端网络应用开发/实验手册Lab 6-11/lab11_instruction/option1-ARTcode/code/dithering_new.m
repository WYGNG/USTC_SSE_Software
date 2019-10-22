function [dithered_img] = dithering_new(selected_colors, picname)

% some settings
img = imread(picname);
img = double(img);
selected_colors = double(selected_colors);
dithered_img = img;
err = zeros(128,128,3);
[num, ~] = size(selected_colors);

for i=1:1:128
    for j=1:1:128
        Rsum = img(i, j, 1);
        Gsum = img(i, j, 2);
        Bsum = img(i, j, 3);

        Rsum = Rsum + err(i,j,1);
        Gsum = Gsum + err(i,j,2);
        Bsum = Bsum + err(i,j,3);
        dis = zeros(1,num);
        
        for  index_set= 1:1:num
            dis(1,index_set) = (Rsum-selected_colors(index_set, 1))^2 + (Gsum-selected_colors(index_set, 2))^2 + (Bsum-selected_colors(index_set, 3))^2;
        end
        [value, pos] = min(dis);
%         pos
        dithered_img(i,j,1) = selected_colors(pos, 1);
        dithered_img(i,j,2) = selected_colors(pos, 2);
        dithered_img(i,j,3) = selected_colors(pos, 3);
        re = Rsum-selected_colors(pos, 1);
        ge = Gsum-selected_colors(pos, 2);
        be = Bsum-selected_colors(pos, 3);
        if (i+1 < 128)%¼ÆËãÎó²î¶ÔÓÒ²àµÄÏñËØµÄ´«µÝ
            err(i+1,j,1) = err(i+1,j,1) + re * 3 / 8;
            err(i+1,j,2) = err(i+1,j,2) + ge * 3 / 8;
            err(i+1,j,3) = err(i+1,j,3) + be * 3 / 8;
        end
        if (j+1 < 128)%¼ÆËãÎó²î¶ÔÏÂ²àµÄÏñËØ´«µÝ
            err(i,j+1,1) = err(i,j+1,1) + re * 3 / 8;
            err(i,j+1,2) = err(i,j+1,2) + ge * 3 / 8;
            err(i,j+1,3) = err(i,j+1,3) + be * 3 / 8;
        end
        if (i+1 < 128 && j+1 < 128)%¼ÆËãÎó²î¶ÔÓÒÏÂ²àµÄÏñËØ´«µÝ
            err(i+1,j+1,1) = err(i+1,j+1,1) + re / 4;
            err(i+1,j+1,2) = err(i+1,j+1,2) + ge / 4;
            err(i+1,j+1,3) = err(i+1,j+1,3) + be / 4;
        end
    end
end
dithered_img = uint8(dithered_img);
% figure,imshow(dithered_img);