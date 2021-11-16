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