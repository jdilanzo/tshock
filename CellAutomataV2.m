function [outPut] = CellAutomata(n, N, T)
    %{
    This function is the core of the cellular automata.
    It implements a cellular automata for MAS354 project F Group
    
    Variables
    n = the number of cells in the road section
    N = number of vehicles on the road section
    T = number of time steps to simulate
    %}
    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Generate the state space
    Road = zeros(1, n);         % Generate a section of road n units long
    Speed = zeros(1, n);        % Current speed of the vehicle
    Max_Speed = zeros(1, n);    % Max speed the driver will attain
    Max_A = zeros(1, n);        % Maximum acceleration the driver achieve
    Max_D = zeros(1, n);        % Maximum deceleration the vehicle can achieve
    Buff = zeros(1, n);         % The aditional space the vehicle tries to maintatain
    Dist = zeros(1, n);         % Distance to the vehicle in front
    Speed_Ahead = zeros(1, n);          % Speed of the vehicle ahead

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Generate transfer vectors for stepping T
    New_Road_T = zeros(1, n);
    New_Speed_T = zeros(1, n);
    New_Max_Speed_T = zeros(1, n);
    New_Max_A_T = zeros(1, n);
    New_Max_D_T = zeros(1, n);
    New_Buff_T = zeros(1, n);
    New_Dist_T = zeros(1, n);
    New_Speed_Ahead_T = zeros(1, n);
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Generate the output capture matrix (T x N)
    outPut = zeros(T+1,n);
    xVals = zeros(1, T*N);
    yVals = zeros(1, T*N);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Define variable limits
    Max_Sp = 20; % 80km/h = 22.222...m/s 
    Max_Accel = 2;
    Max_Decel = 4;
    Delta = 4;

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
    %{
    Generate the vehicle positions randomly
    data = 1:n;
    locs = sort(datasample(data, N, 'Replace', false));
    %}

    % Distribute the vehicles evenly
    step = floor(n/N);
    data = 1:step:n;
    locs = sort(datasample(data, N, 'Replace', false));

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Generate vectors to introduce random variation
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    var_1 = -1:2;
    var_2 = [-2 -1 0 0 0 0 0 0 1 2];
    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Place the vehicles and their attributes in the road section
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    for i = 1:N
        Road(locs(i)) = i;
        Speed(locs(i)) = 5 + datasample(var_1, 1);
        Max_Speed(locs(i)) = Max_Sp + datasample(var_1, 1);
        Max_A(locs(i)) = Max_Accel + datasample(var_1, 1);
        Max_D(locs(i)) = Max_Decel + datasample(var_1, 1);
        Buff(locs(i)) = 2 + datasample(var_1, 1);    
    end

    for i = 1:N
        Dist(locs(i)) = calcDist(Road, locs(i));
        Speed_Ahead(locs(i)) = calcSpeedAhead(Road, Speed, i);
    end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Loop over the road section for each time step
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Add a new row to the matrix of vehicle positions x time step
    outPut(1, :) = Road;

    count = 2; % count for adding new columns to the output matrix

    for i = 1:T % For each time step
        
        for j = 1:n % For each road position
            if Road(j) ~= 0 % There is a vehicle at that position

                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                % Calculate new vehicle speed based Independent Driver
                % Model
                Go_Faster = 1 - (Speed(j)/Max_Speed(j))^Delta;
                Go_Slower = Buff(j) + max(0, Speed(j)*Buff(j)) + (Speed(j)*(Speed(j) - Speed_Ahead(j)));
                Speed_Delta = Max_A(j)*(Go_Faster - (Go_Slower/Dist(j))^2);
                Speed(j) = Speed(j) + round(Speed_Delta) + datasample(var_2, 1);
                if Speed(j) < 0
                    Speed(j) = 0;
                end
                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                % add a vehicle marker to the output matrix
                outPut(T, j) = 1;

                % Calc next location of vehicle
                newIndex = mod((j + Speed(j))-1, n)+1;
                
                % Add the new location and vehical details to the transfer matrix 
                New_Road_T(newIndex) = Road(j); 
                New_Speed_T(newIndex) = Speed(j);
                New_Max_Speed_T(newIndex) = Max_Speed(j);
                New_Max_A_T(newIndex) = Max_A(j);
                New_Max_D_T(newIndex) = Max_D(j);
                New_Buff_T(newIndex) = Buff(j);
            end
        end
        
        % Calculate the new distances, speeds ahead at the new positions
        for k = 1:n
            if New_Road_T(k) ~= 0
                New_Dist_T(k) = calcDist(New_Road_T, k);
                New_Speed_Ahead_T(k) = calcSpeedAhead(New_Road_T, New_Speed_T, k);
            end
        end



        % Transfer the new position of the vehicles
        Road = New_Road_T;
        Speed = New_Speed_T;
        Max_Speed = New_Max_Speed_T;
        Max_A = New_Max_A_T;
        Max_D = New_Max_D_T;
        Buff = New_Buff_T;
        Dist = New_Dist_T; % Consider removing - Keeping it as it may be useful as a system output
        Speed_Ahead = New_Speed_Ahead_T;
    
        % Add a new row to the matrix of vehicle positions x time step
        outPut(count, :) = Road;
        count = count +1;

        vCount = 0;
        for l = 1:n
            if New_Road_T(l) ~= 0
                vCount = vCount + 1;
            end
        end
    
        % Clear transfer vectors
        New_Road_T(:) = 0;
        New_Speed_T(:) = 0;
        New_Max_Speed_T(:) = 0;
        New_Max_A_T(:) = 0;
        New_Max_D_T(:) = 0;
        New_Buff_T(:) = 0;
        New_Dist_T(:) = 0;
        New_Speed_Ahead_T(:) = 0;
        
    end
    
    % Loop over the matrix to load the x and y coords of vehicle positions
    count = 1; % Count for adding to the xVal and yVal vectors
    for i = 1:T
        for j = 1:n
            if outPut(i, j) ~= 0
                xVals(count) = j;
                yVals(count) = i;
                count = count + 1;
            end
        end
    end
    
    % Plot the (x, y) vehicle positions
    figure(1)
    scatter(xVals, yVals, 6, "red", "filled", "square")
    
    % generate an array of moving Averages
    movAvg = movAvgDensity(outPut, 10);
    
    % generate a moving average density plot
    figure(2)
    contourf(movAvg)
end