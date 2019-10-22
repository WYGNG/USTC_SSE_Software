function [color_0, color_1] = find2Color(cur, codingcolors)

[color_num, ~] = size(codingcolors);
dis = zeros(1, color_num);
for k = 1:1:color_num
    dis(1, k) = (double(codingcolors(k,1))-double(cur(1)))^2+(double(codingcolors(k,2))-double(cur(2)))^2+(double(codingcolors(k,3))-double(cur(3)))^2;
end
[~, index_dist] = sort(dis(1,:));
if mod(index_dist(1),2) == 0
    color_0 = codingcolors(index_dist(1),:);
    for tmp = 1:1:color_num
        if mod(index_dist(tmp),2) == 1
            color_1 = codingcolors(index_dist(tmp),:);
            break;
        end
    end
else
    color_1 = codingcolors(index_dist(1),:);
    for tmp = 1:1:color_num
        if mod(index_dist(tmp),2) == 0
            color_0 = codingcolors(index_dist(tmp),:);
            break;
        end
    end
end

