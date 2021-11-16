%% Relative Location
% It takes Light location parameters and robot location parameters and
% calculate angle and distance.
function [out] = relative_location(in)
    xl = in(1);
    yl = in(2);
    x = in(3);
    y = in(4);
    th = in(5);
    
    d = sqrt((xl - x)^2 + (yl - y)^2);
    q = atan2((yl - y),(xl - x)); % or atan((yl - y) / (xl - x)); 
    a_rd = q - th; % it is radian we need to convert to degree
    a_deg = (a_rd * 180.0) / pi; % or rad2deg()
    a = a_deg;
    
out = [a d];
end

