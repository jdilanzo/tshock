%{
This script runs the cellular automata program
The functiuon CellAutomata(road_params, driver_params) which takes two
arguments, being vectors of the road segment and number of cars.

    road_params(1) = the number of cells in the road section
    road_params(2) = number of vehicles on the road section
    road_params(3) = number of time steps to simulate

and the driver behaviour parameters which support the implementation of the
intelligent driver model (IDM)

    driver_params(1) = Max_Speed   (int max speed ~= speed limit)
    driver_params(2) = init_speed  (int speed at which venicles are initialised at)
    driver_params(3) = Max_Accel   (int maximum acceleration of the vehicle)
    driver_params(4) = Max_Decel   (int maximum braking of the vehicle)
    driver_params(5) = Buff        (int buffer the driver desires to maintain to the
                                    car ahead)
    driver_params(6) = Delta       (float parameter that ....) 

The function requires calcDist.m and calcSpeedAhead.m
%}
clear

params = zeros(1, 10);
% define the state space parameters
params(1) = 400;    %the number of cells in the road section loop
params(2) = 90;     % number of vehicles on the road section loop
params(3) = 200;    %the number of time steps
params(4) = 10;     % max speed ~= speed limit
params(5) = 5;      % speed at which venicles are initialised at
params(6) = 3;      % maximum acceleration of the vehicle
params(7) = 3;      % maximum braking of the vehicle
params(8) = 1;      % buffer the driver maintains to the car ahead)
params(9) = 4;      % parameter that is usually set to 4
params(10) = 1.5;   % The minimum time gap between vehicles

% Run the simulation
[output_road, output_speed, output_accel] = CellAutomataV3(params);
   
% Plot the (x, y) vehicle positions
n = params(1);
N = params(2);
T = params(3);

% Vehicle positions
xVals = zeros(1, T*N);
yVals = zeros(1, T*N);

% Loop over the matrix to load the x and y coords of vehicle positions
count = 1; % Count for adding to the xVal and yVal vectors
for i = 1:T
    for j = 1:n
        if output_road(i, j) ~= 0
            xVals(count) = j;
            yVals(count) = i;
            count = count + 1;
        end
    end
end

figure(1)
scatter(xVals, yVals, 6, "black", "filled", "square")

%{
% generate an array of moving Averages
movAvg = movAvgDensity(outPut_road, 10);

% generate a moving average density plot
figure(2)
contourf(movAvg)
%}