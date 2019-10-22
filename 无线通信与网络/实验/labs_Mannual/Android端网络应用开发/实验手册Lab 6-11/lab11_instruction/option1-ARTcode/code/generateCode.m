function [img_embedded] = generateCode(dithered_img, img_colors, codingcolors, changed_pos, changed_serial_CRC, coor, shuffle_size)

[~, CSlen] = size(changed_serial_CRC);
img_embedded = dithered_img;

for j = 1:1:CSlen
    posx = floor((j-1)/shuffle_size(2))+1;
    posy = j-(floor((j-1)/shuffle_size(2)))*shuffle_size(2);
    if changed_pos(1,j) == 0
        img_embedded(coor(posx,posy,1), coor(posx,posy,2), :) = img_colors(j,:);
    else
        cur = img_embedded(coor(posx,posy,1), coor(posx,posy,2), :);
        [color_0, color_1] = find2Color(cur, codingcolors);
        if changed_serial_CRC(1,j) == 1
            img_embedded(coor(posx,posy,1), coor(posx,posy,2), :) = color_1;
        else
            img_embedded(coor(posx,posy,1), coor(posx,posy,2), :) = color_0;
        end
    end
end
