% Last modified: 3/23/2016 by xyzhao
% dist = huedist(h1,h2)
% h1, h2: hue values, [0,359]

function dist = huedist(h1,h2)
    dist = min(abs(h1-h2),360-abs(h1-h2));
end