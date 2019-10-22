% encodeMain
clear all;

% some settings
i = 1;  % pic number, pics are in the folder testpics
info = '222222222222222222222222222*'; % information you want to embed into an ARTcode. A piece of information ends with *
k = 7; % 3 7 11 15 19 embedding block size
bits_in_one = floor(log2(k+1));
G =[1;1;1;1;1]; 
word_size = 8;
shuffle_size = [40 40];



        picname = [cd,'\testpics\',num2str(i),'.bmp'];
        targetcolornum = 16; % 4 8 16 32

        % Get palette from selected pixels instead of the whole picture
        load position40;
        [colors,power] = getpalette(picname, targetcolornum, coor);

        % dithering by ytbao
         [dithered_img] = dithering_new(colors, picname);
         imwrite(dithered_img, [cd,'\testpics\',num2str(i),'_dithered_',num2str(targetcolornum),'.bmp'],'bmp');
        
        % encoding color to bit
        codingcolors = getcodingcolors(colors,power,1);
        imwrite(uint8(drawpalette(codingcolors)),[cd,'\testpics\',num2str(i),'_select1.bmp'],'bmp');
        save(['coding_color_', num2str(i)], 'codingcolors');    

        
        % get image_serial, image_serial refers to the original binary vector in
        % encoding modules
        [image_serial, img_colors] = find_serial(dithered_img, codingcolors, coor, shuffle_size);

        % embed info to image_serial and obtain changed_serial
        [changed_serial] = data_hiding(image_serial, info, k);

        % CRC (error detection)
        [changed_serial_CRC] = en_CRC(changed_serial, info, k, G, word_size);

        % get embedded code
        changed_pos = xor(changed_serial_CRC, image_serial);
        img_embedded = generateCode(dithered_img, img_colors, codingcolors, changed_pos, changed_serial_CRC, coor, shuffle_size); 
        imwrite(img_embedded, [cd,'\testpics\',num2str(i),'_embedded_',num2str(targetcolornum),'_k_',num2str(k),'_bytes_',num2str(length(info)), '.bmp'],'bmp');
        
        % add frame by yangzhe...
        frame_1 = addFrame_256_256_AdapPalette(codingcolors, img_embedded);
        
        imwrite(frame_1,'code.bmp');
