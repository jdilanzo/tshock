%{
This script runs the cellular automata program
The functiuon CellAutomata(n, N, T) takes three arguments

    n = the number of cells in the road section loop
    N = the number of vehicles on the road section loop
    T = the number of time steps

The function requires calcDist.m and calcSpeedAhead.m

The function movAvgDensity calculates a moving average density of vehicles
in the road segment window
%}

% define the input parameters
n = 200;    %the number of cells in the road section loop
N = 70;     % number of vehicles on the road section loop
T = 200;    %the number of time steps

run = CellAutomataV2(200, 70, 200);