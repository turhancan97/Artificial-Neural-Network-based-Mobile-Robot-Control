function wynik = MiniTracker_model(we)

%****************************************
% Kinematic model of the Minitracker robot
%****************************************
global d r

%input vector
%we = [vp vl teta]
%vl - linear velocity of the left wheel
%vp - linear velocity of the right wheel
%wl - angular velocity of the left wheel
%wp - angular velocity of the right wheel

%wp = we(1);
%wl = we(2);
%vp = r*wp;
%vl = r*wl;
vp = we(1);
vl = we(2);
 
teta = we(3); % orientation angle

x_prim = (0.5*cos(teta)*vp+0.5*cos(teta)*vl);
y_prim = (0.5*sin(teta)*vp+0.5*sin(teta)*vl);
teta_prim = (vp/d-vl/d);

wynik = [x_prim; y_prim; teta_prim];