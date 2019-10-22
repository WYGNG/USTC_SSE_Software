ss = 64;
size = 15;


serial_R = randperm(ss*ss);
serial = serial_R(1:size*size);

coor = zeros(size,size,2);

count = 1;
for i = 1:size
    for j = 1:size
        coor(i,j,1) = floor((serial(count)-1)/ss+1);
        coor(i,j,2) = mod(serial(count)-1,ss)+1;
        count = count + 1;
    end
end

save position15 coor
