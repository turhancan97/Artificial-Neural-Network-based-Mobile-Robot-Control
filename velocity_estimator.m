% Velocity Estimator Function
% It estimated the velocity of right and left wheels in the trainin
% senction.
function velocity = velocity_estimator(angle, dist)

    % compute right and left velocities
    if (angle > -3) && (angle < 3),
        vr = 1;
        vl = 1;
    elseif (angle >= 3) && (angle <= 54),
        vr = 1;
        vl = 0;            
    elseif (angle <= -3) && (angle >= -54),
        vr = 0;
        vl = 1;
    end
    
    velocity = [vr vl]';