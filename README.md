# Mobile Robot that Follows the Lights Source with ANN Control
## What is This Project?

In this project, our aim is to use neural network for controling mobile robot. The robot will follow the light source. The robot has three sensors and each sensor has a range which can detect the light source. This system is simulated in Simulink and MATLAB. You can see the result below.

![simulink](https://user-images.githubusercontent.com/22428774/142009890-479bbd7e-4626-4aae-bb74-fabb69c4a1c5.PNG)
![ezgif com-gif-maker (1)](https://user-images.githubusercontent.com/22428774/142014539-98e9057d-680b-47e9-bf36-4f4d2a50610a.gif)

As you can see on Simulink Model, Ligh Source Location has been adjusted to 25, 10 coordinate and our robot succesfully arrive the light source.

## How to Run the Project

## Code Explanation
As you can see, we have 4 different MATLAB functions on the Simulink Model. Let me start to explain with Neural Controller Function. It takes 3 signals which are electronic signals from sensors in the range of 0-5V. If light is not in the area of sensors, the value will be 0. If we put the light source very close to sensors, the value will be 5V. We will control the center of the mobile robot so, we need to know what is the range of the sensors which can detect the light. You can see the code for the Neural Controller Block below.

```matlab
%% Find the estimated velocities by ANN
function velocities = control_net(sensor1, sensor2, sensor3)

global netN

p=[sensor1; sensor2; sensor3];


velocities=sim(netN,p);
```
