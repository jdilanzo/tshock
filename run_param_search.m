%{
This script runs the cellular automata parameter search function
ParamSearch(params, parameter_num, start_range, end_range) takes three
arguments, being vectors of the road segment and number of cars.

    params is vector of 10 values that describes the state space
    Variables, where;
    
        params(1) = n the number of cells in the road section
        params(2) = N the number of vehicles on the road section
        params(3) = T the number of time steps to simulate

    The IDM parameters that describes the driver behaviour, where;
   
        params(4) = Max_Speed   (int max speed ~= speed limit)
        params(5) = init_speed  (int speed at which venicles are initialised at)
        params(6) = Max_Accel   (int maximum acceleration of the vehicle)
        params(7) = Max_Decel   (int maximum braking of the vehicle)
        params(8) = Buff        (int buffer the driver desires to maintain to the
                                        car ahead)
        params(9) = Delta       (float parameter that ....)
        params(10) = T_gap           (minimum possible time to the car ahead)

the start and end of the range that is to be explored is also defined
start_range
end_range
%}

clear

params = zeros(1, 10);
% define the state space parameters
params(1) = 400;    %the number of cells in the road section loop
params(2) = 90;     % number of vehicles on the road section loop
params(3) = 200;    % the number of time steps
params(4) = 10;     % max speed ~= speed limit
params(5) = 5;      % speed at which venicles are initialised at
params(6) = 3;      % maximum acceleration of the vehicle
params(7) = 3;      % maximum braking of the vehicle
params(8) = 1;      % buffer the driver maintains to the car ahead)
params(9) = 4;      % parameter that is usually set to 4
params(10) = 1.5;   % The minimum time gap between vehicles

parameter_num = 2;
start_range = 1;
end_range = 150;

ParamSearch(params, parameter_num, start_range, end_range);