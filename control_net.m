%% Find the estimated velocities by ANN
function velocities = control_net(sensor1, sensor2, sensor3)

global netN

p=[sensor1; sensor2; sensor3];


velocities=sim(netN,p);