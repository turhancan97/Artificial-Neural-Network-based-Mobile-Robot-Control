# Mobile Robot that Follows the Lights Source with ANN based Control
## What is This Project?

In this project, our aim is to use neural network for controling mobile robot. The robot will follow the light source. The robot has three sensors and each sensor has a range which can detect the light source. This system is simulated in Simulink and MATLAB. You can see the result below.

![simulink](https://user-images.githubusercontent.com/22428774/142009890-479bbd7e-4626-4aae-bb74-fabb69c4a1c5.PNG)
![ezgif com-gif-maker (1)](https://user-images.githubusercontent.com/22428774/142014539-98e9057d-680b-47e9-bf36-4f4d2a50610a.gif)

As you can see on Simulink Model, Ligh Source Location has been adjusted to 25, 10 coordinate and our robot succesfully arrive the light source.

## How to Run the Project
1. Clone this repo:

`git clone https://github.com/turhancan97/Artificial-Neural-Network-basead-Mobile-Robot-Control.git`

2. Open Matlab and run init.m first.
3. Later, run train_net.m to train our model.
4. Open Simulink File called smart_system.slx and run it.
## Environment and tools
* Matlab
* Simulink
* Neural Network Toolbox or Deep Learning Toolbox
* Control System Toolbox

## Code Explanation
As you can see, we have 4 different MATLAB functions on the Simulink Model. Let me start to explain with Neural Controller Function. It takes 3 signals which are electronic signals from sensors in the range of 0-5V. If light is not in the area of sensors, the value will be 0. If we put the light source very close to sensors, the value will be 5V. We will control the center of the mobile robot so, we need to know what is the range of the sensors which can detect the light. You can see the code for the Neural Controller Block below.

```matlab
%% Find the estimated velocities by ANN
function velocities = control_net(sensor1, sensor2, sensor3)

global netN

p=[sensor1; sensor2; sensor3];


velocities=sim(netN,p);
```

> Neural Controller Function

Now, let me explain how we train the data. We created free neural network as shown in the code below. After that, the data should be created for neural network. Therefore, we created our input vector from ANN from sensor_model() function. And out target vector is created from velocity_estimator() function. Therefore, the train_net code will take the sensor values as input and give the velocity for left and right wheels as output.



```matlab
%% Neural Network Section For Robot
global netN
% create net by newff
netN = newff([0 5; 0 5; 0 5], [25 2], {'logsig', 'tansig'});

% prepare input set and target set
P = [0;0;0];
T = [-1; 1];
for angle=-54:3:+54,
        d = 20;
        measurement = sensor_model(angle, d);
        P = [P measurement];
        velocities = velocity_estimator(angle, d);
        T = [T velocities];

end;
P
T
% train
netN = train(netN, P, T);
```
> Neural Network Training

We have an initialization code below for defining the parameter of the mobile robot. For example, there are information about distance between two wheels, radius of wheels and where the sensors are located on the mobile robot.

```matlab
%% Initialization Codes for Robort's Parameters
global r d
d = 10; % Distance between wheels in cm
r = 3; % Wheel radius in cm
%% Sensor Position in the Robot Frame
% 1 - left sensor
% 2 - front sensor
% 3 - right sensor
global Poz_cz1 Poz_cz2 Poz_cz3 kat_cz_max kat_cz_min odl_cz_max Output_cz_max ile_przedz

Poz_cz1 = [-(d/2-1) (d/2-1)  30]; % for d=10 : [-4 4 30]
Poz_cz2 = [   0     (d/2-1)   0]; %            [ 0 4  0] 
Poz_cz3 = [ (d/2-1) (d/2-1) -30]; %            [ 4 4 -30]
kat_cz_max = 25;   %deg
kat_cz_min = -25;  %deg
odl_cz_max = 50;   %cm
Output_cz_max = 5; %V
ile_przedz = 5;

global XP1_1 XP2_1 XP3_1 XP4_1 XPW5_1
global YP1_1 YP2_1 YP3_1 YP4_1 YPW5_1
   
XP1_1=d/2;
YP1_1=d/2;
XP2_1=-d/2;
YP2_1=d/2;
XP3_1=-d/2;
YP3_1=-d/2;
XP4_1=d/2;
YP4_1=-d/2;
XPW5_1=0;
YPW5_1=d/2+3;
%   PredkoscKolkaMAX - maximum linear speed of the colon
global PredkoscKolkaMAX
PredkoscKolkaMAX=8;
%   WspSkalujacyCzas - Simulation time scaling factor
global WspSkalujacyCzas
WspSkalujacyCzas=1;
% parameter describing the travel time to the end point
%global wyliczony_czas
% parameter describing the size wyswietlanej przestrzeni
global SzerEkr
SzerEkr=50;
% light distance from the center of the robot used to train the neural network
global OdlUczeniaSieci
OdlUczeniaSieci=25;
```
> init.m

After initialization, sensor model can be explained (code below). It has two input parameters which are angle and distance. Angle argument is the angle between main axis of robot and light source. If the angle is positive, light is on the left side and if it is negative, vice versa. Distance is the distance between robot and light source. We decided that the maximum range of sensors is 54 degree so that if the angle between light source and the mobile robot is equal to or bigger than 55, the mobile robot will not detect it and sensor_model() function will give [0;0;0] as output. If the distance value is equal to or less that 4, again the function will give [0;0;0] as output because the light source will be located inside mobile robot. Finally, the maximum range of distance was determined 55 centimeter. If distance argument of the function is bigger that 55, it will give zero output.
```matlab
%% Sensor Model
% it takes angle and distance parameters from relative location function
% and gives the sensor parameters as output.
function sensoroutput = sensor_model(angle, distance)
   
	kat = angle;
	odl = distance;	
	
    global Poz_cz1 Poz_cz2 Poz_cz3 kat_cz_max kat_cz_min odl_cz_max Output_cz_max
    
    % the angle of the light source as seen from the sensor system
    kat_cz1 = kat - Poz_cz1(3);
    kat_cz2 = kat - Poz_cz2(3);
    kat_cz3 = kat - Poz_cz3(3);

    % coordinates of light sources in a system related to the robot
    X_swiatla = - sin(kat*(pi/180))*odl;
    Y_swiatla = cos(kat*(pi/180))*odl;
    
    % coordinates of light sources in systems of local sensors
    wsp_swiatla_cz1 = transform_coord([X_swiatla Y_swiatla 0],Poz_cz1);
    wsp_swiatla_cz2 = transform_coord([X_swiatla Y_swiatla 0],Poz_cz2);
    wsp_swiatla_cz3 = transform_coord([X_swiatla Y_swiatla 0],Poz_cz3);
    
    % the distance of the light source in the local system of sensors
    odl_cz1 = norm(wsp_swiatla_cz1(1:3));
    odl_cz2 = norm(wsp_swiatla_cz2(1:3));
    odl_cz3 = norm(wsp_swiatla_cz3(1:3));
    
       
    % Calculation of values on the sensor output - with linear assumption
    % characteristics
    
    % sensor 1
    
    if (odl_cz1 >= 0 & odl_cz1 <= odl_cz_max & wsp_swiatla_cz1(2)>=0)
        if (abs(kat_cz1) <= kat_cz_max )
            Output_cz1 = Output_cz_max*((kat_cz_max - abs(kat_cz1))/kat_cz_max * (odl_cz_max-odl_cz1)/odl_cz_max);
        else
            Output_cz1 = 0;
        end    
    else 
        Output_cz1 = 0;
    end 
    
    % sensor 2
    if (odl_cz2 >= 0 & odl_cz2 <= odl_cz_max & wsp_swiatla_cz2(2)>=0)
        if (abs(kat_cz2) <= kat_cz_max )
            Output_cz2 = Output_cz_max*((kat_cz_max - abs(kat_cz2))/kat_cz_max * (odl_cz_max-odl_cz2)/odl_cz_max);
        else
            Output_cz2 = 0;
        end    
    else 
        Output_cz2 = 0;
    end 
    
    %   sensor 3
    if (odl_cz3 >= 0 & odl_cz3 <= odl_cz_max & wsp_swiatla_cz2(3)>=0)
        if (abs(kat_cz3) <= kat_cz_max )
            Output_cz3 = Output_cz_max*((kat_cz_max - abs(kat_cz3))/kat_cz_max * (odl_cz_max-odl_cz3)/odl_cz_max);
        else
            Output_cz3 = 0;
        end    
    else 
        Output_cz3 = 0;
    end 
    
    % the returned result of analog outputs from the sensor
    sensoroutput = [Output_cz1; Output_cz2; Output_cz3];
    
function wsp_lokalne_czujnika = transform_coord(wektor,Poz_cz)

        % the function transforms the vector coordinates to the local system 
        % sensor

        % input parameters:
        % vector - a vector whose coordinates should be found in the system
        %          local sensor
        % Poz_cz - vector of the sensor location and orientation with respect to the system
        %          related to the robot

    Teta_rad = Poz_cz(3)*pi/180;
    Transf = [cos(Teta_rad) sin(Teta_rad) 0  -(cos(Teta_rad)*Poz_cz(1)+sin(Teta_rad)*Poz_cz(2));
             -sin(Teta_rad) cos(Teta_rad) 0  -(-sin(Teta_rad)*Poz_cz(1)+cos(Teta_rad)*Poz_cz(2));
             0              0             1  0;
             0              0             0  1];

    wsp_lokalne_czujnika = Transf*[wektor(1);wektor(2);wektor(3);1];
```

> Sensor Model Code
> 
We have a script called velocity estimator (code below). We didn‟t use it on Simulink as function block but we use it in training neural network. This function decides that what mobile robot should do depending on angle and distance at which it detect the light. Therefore, it determines the velocity of left and right wheel of the robot according to position of the light source.
 ```matlab
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
```
> Velocity Estimator

Also, wort to mention about MiniTracker_model() Function (code below) of the model. It is simple Kinematic model of the Minitracker robot and gives the X_prime, Y_Prime and Theta_Prime as output. When we take integral of the output, we get position of the robot.
 ```matlab
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
```

> MiniTracker_model.m

In conclusion, it is determined that neural network can be used as mobile robot controller.
