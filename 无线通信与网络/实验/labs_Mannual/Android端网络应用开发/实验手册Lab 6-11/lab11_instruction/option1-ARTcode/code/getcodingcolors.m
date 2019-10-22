% Last modified: 3/23/2016 by xyzhao
% 
% Method 1: Euclidean dist in RGB
% Method 2: Y in YUV
% Method 3: H in HSV with Y in YUV?

function codingcolors = getcodingcolors(colors,power,method)
    codingcolors = zeros(size(colors));
    codingcolornum = 0;
    
    switch method
        % ----- Method 1 -----  
        case(1)
            mindist = 150; %
            codingcolornum = 0;
            for i = 1:length(power)
                current = colors(i,:);
                if(~codingcolornum)
                    codingcolornum = codingcolornum + 1;
                    codingcolors(codingcolornum,:) = current;
                else
                    islegal = true;
                    for j = 1:codingcolornum
                        islegal = islegal & (norm(double(current)-codingcolors(j,:))>mindist);
                        if (~islegal)
                            break;
                        end
                    end
                    if (islegal)
                        codingcolornum = codingcolornum + 1;
                        codingcolors(codingcolornum,:) = current;
                    end
                end
            end    
            codingcolors = codingcolors(1:codingcolornum,:);
        
        % ----- Method 2 -----  
        case(2)
            mindist = 80; %
            yuvcolors = round(rgb2ycbcr(colors)*255);
            yuvcodingcolors = codingcolors;
            % 'yuvcolors' will be an n-by-3 double matrix, with y in range 
            % [16, 235]/255, and Cb and Cr are in the range [16 240]/255.            
            frommaxpower = false;
            if(frommaxpower)
                disp('Still do not know how to do :(');
            else
                y = yuvcolors(:,1);
                [~,indexy] = sort(y);
                yuvcolors(1:length(power),:) = yuvcolors(indexy,:);
                currentY = 0;
                % From the mininum Y (what if from the maximum Y? Perhaps more colors, better!)
                for i = 1:length(power)
                    if(~codingcolornum)
                        codingcolornum = codingcolornum + 1;
                        yuvcodingcolors(codingcolornum,:) = yuvcolors(i,:);
                        currentY = yuvcolors(i,1);
                    else
                        if(yuvcolors(i,1)-currentY>mindist)
                            codingcolornum = codingcolornum + 1;
                            yuvcodingcolors(codingcolornum,:) = yuvcolors(i,:);
                            currentY = yuvcolors(i,1);
                        end
                    end
                end
                yuvcodingcolors = yuvcodingcolors(1:codingcolornum,:);                
                codingcolors = ycbcr2rgb(yuvcodingcolors/255)*255;
            end   
            
        % ----- Method 3 -----    
        case(3)
            % some settings
            hmindist = 50; % full scale 360
            smin = 0;
            yrange = [66 200]; % full scale is [16, 235]  
            [colors_rows, ~] = size(colors);
            coding_h = zeros(colors_rows, 1);
            
            % For colors with Y out of yrange. do i need to consider s and hue distance?
            yuvcolors = round(rgb2ycbcr(colors)*255);
            y = yuvcolors(:,1);           
            if(~isempty(find(y<=yrange(1))))
                codingcolornum = codingcolornum + 1;
                codingcolors(codingcolornum,:) = colors(min(find(y<=yrange(1))),:);
                tmphsv = rgb2hsv(double(codingcolors(codingcolornum,:)));
                coding_h(codingcolornum,1) = tmphsv(:,1)*360-1;
            end
            
            if(~isempty(find(y>=yrange(2))))
                codingcolornum = codingcolornum + 1;
                codingcolors(codingcolornum,:) = colors(min(find(y>=yrange(2))),:);
                tmphsv = rgb2hsv(double(codingcolors(codingcolornum,:)));
                coding_h(codingcolornum,1) = tmphsv(:,1)*360-1;
            end
            
            % For colors within yrange, choose hue
            remained = y<yrange(2)&y>yrange(1);
            remained_colors = colors(remained,:);
            remained_hsvcolors = rgb2hsv(double(remained_colors)/255); % Range = [0,1]
            h = remained_hsvcolors(:,1)*360-1;
            
%             tempcodingcolornum = 0;
%             tempcodingcolors = zeros(size(colors));
            
            for i = 1:sum(remained)
%                 if(i == 1)
%                     codingcolornum = codingcolornum + 1;
%                     codingcolors(codingcolornum,:) = newcolors(i,:);
%                     tempcodingh(tempcodingcolornum) = h(i);
%                 else
                    islegal = true;
                    for j = 1:codingcolornum
                        islegal = islegal & (huedist(h(i),coding_h(j))>hmindist);
                        if (~islegal)
                            break;
                        end
                    end
                    if (islegal)
                        codingcolornum = codingcolornum + 1;
                        codingcolors(codingcolornum,:) = remained_colors(i,:);
                        coding_h(codingcolornum) = h(i);
                    end
%                 end
            end
            
            % Combine two parts: within and out of yrange
%             codingcolors(codingcolornum+1:codingcolornum+tempcodingcolornum,:) = tempcodingcolors(1:tempcodingcolornum,:);
%             codingcolornum = codingcolornum + tempcodingcolornum;
            codingcolors = codingcolors(1:codingcolornum,:);
            
        otherwise
            disp('Hope you will never see this, switch->otherwise in getcodingcolors.m :(');
    end  
    codingcolors = uint8(codingcolors);
end