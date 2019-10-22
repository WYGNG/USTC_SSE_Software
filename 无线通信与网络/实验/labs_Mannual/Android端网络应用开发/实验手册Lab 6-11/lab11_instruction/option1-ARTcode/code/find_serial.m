function [image_serial, img_colors] = find_serial(dithered_img, codingcolors, coor, shuffle_size)

[colors_num, ~] = size(codingcolors);
image_serial = zeros(1,shuffle_size(1)*shuffle_size(2));
img_colors = zeros(shuffle_size(1)*shuffle_size(2), 3);

for i = 1:1:shuffle_size(1)
    for j = 1:1:shuffle_size(2)
        posx = coor(i,j,1);
        posy = coor(i,j,2);
        dith_rgb = dithered_img(posx, posy, :);
        dis = zeros(1,colors_num);
        for k = 1:1:colors_num
            dis(1, k) = (double(codingcolors(k,1))-double(dith_rgb(1)))^2+(double(codingcolors(k,2))-double(dith_rgb(2)))^2+(double(codingcolors(k,3))-double(dith_rgb(3)))^2;
        end
        [~, dis_min_pos] = min(dis);
        embedbit = mod(dis_min_pos,2);
        image_serial(1,(i-1)*shuffle_size(2)+j) = embedbit;
        img_colors((i-1)*shuffle_size(2)+j, :) = codingcolors(dis_min_pos, :);
    end
end