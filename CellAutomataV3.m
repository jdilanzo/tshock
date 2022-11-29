function [output_road, output_speed, output_accel] = CellAutomataV3(params)
    %{
    This function is the core of the cellular automata.
    It implements a cellular automata for MAS354 project F Group
    
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
    %}

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Extract the state space defining variable values
    n = params(1);
    N = params(2);
    T = params(3);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Extract the driver variable values
    Max_Sp = params(4);
    init_speed = params(5);
    Max_Accel = params(6);
    Max_Decel = params(7);
    buffer = params(8);
    Delta = params(9);
    T_gap = params(10);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Generate the state space vector
    Road = zeros(1, n);         % Generate a section of road n units long
    Dist = zeros(1, n);         % Distance to the vehicle in front
    accel = zeros(1, n);         % acceleration of the vehicle from the IDM
    Speed_Ahead = zeros(1, n);  % Speed of the vehicle ahead

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    % Generate the driver behaviour variables vectors
    Speed = zeros(1, n);        % Current speed of the vehicle
    Max_Speed = zeros(1, n);    % Max speed the driver will attain
    Max_A = zeros(1, n);        % Maximum acceleration the driver achieve
    Max_D = zeros(1, n);        % Maximum deceleration the vehicle can achieve
    Buffer = zeros(1, n);         % The aditional space the vehicle tries to maintatain

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
    % Generate the output capture matrix (T+1 x N)
    output_road = zeros(T+1,n);
    output_speed = zeros(T+1,n);
    output_accel = zeros(T+1,n);

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~  
    %{
    Generate the vehicle positions randomly
    data = 1:n;
    locs = sort(datasample(data, N, 'Replace', false));
    %}

    % Distribute the vehicles evenly
    step = floor(n/N);
    locs = 1:step:n;
    % data = 1:step:n;
    % locs = sort(datasample(data, N, 'Replace', false));

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Generate vectors to introduce random variation
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    var_1 = [0 1];
    var_2 = [-1 0 0 0 0 0 0 0 0 1 ];
    var_3 = [-1 0];
    
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Place the vehicles and their attributes in the road section
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    for i = 1:N
        Road(locs(i)) = i;
        Speed(locs(i)) = init_speed + datasample(var_1, 1);
        Max_Speed(locs(i)) = Max_Sp + datasample(var_1, 1);
        Max_A(locs(i)) = Max_Accel + datasample(var_1, 1);
        Max_D(locs(i)) = Max_Decel + datasample(var_1, 1);
        Buffer(locs(i)) = buffer + datasample(var_1, 1);    
    end

    for i = 1:N
        Dist(locs(i)) = calcDist(Road, locs(i));
        Speed_Ahead(locs(i)) = calcSpeedAhead(Road, Speed, i);
    end

%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
% Loop over the road section for each time step
%~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

    % Add a new row to the matrix of vehicle positions x time step
    output_road(1, :) = Road;

    count = 2; % count for adding new columns to the output matrix

    for i = 1:T % For each time step        
        for j = n:-1:1 % For each road position
            if Road(j) ~= 0 % There is a vehicle at that position

                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
                % Calculate new vehicle speed based Independent Driver
                % Model
                Go_Faster = (Speed(j)/Max_Speed(j))^Delta;
                Go_Slower = Buffer(j) + Speed(j)*T_gap + (Speed(j)*(Speed(j) - Speed_Ahead(j)))/(2*sqrt(Max_D(j)*Max_A(j)));
                Speed_Delta = (Max_A(j) + datasample(var_2, 1))*(1 - Go_Faster - (Go_Slower/Dist(j))^2);
                accel(j) = Speed_Delta;
                Speed(j) = Speed(j) + Speed_Delta;
                Speed(j) = max(0, Speed(j)); % Treat the case for -ve speeds
                Speed(j) = min(Speed(j) + datasample(var_2, 1), Max_Speed(j) + datasample(var_2, 1)); % Treat the case for speeds > max speed

                %~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

                % add a vehicle marker to the output matrix
                output_road(T, j) = 1;

                % Calc next location of vehicle
                newIndex = mod((j + round(Speed(j)))-1, n)+1;

                % Add the new location and vehical details to the transfer matrix
                while New_Road_T(newIndex) ~= 0
                    newIndex = mod((newIndex)-2, n)+1;
                end
                New_Road_T(newIndex) = Road(j); 
                New_Speed_T(newIndex) = Speed(j);
                New_Max_Speed_T(newIndex) = Max_Speed(j);
                New_Max_A_T(newIndex) = Max_A(j);
                New_Max_D_T(newIndex) = Max_D(j);
                New_Buff_T(newIndex) = Buffer(j);
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
        Buffer = New_Buff_T;
        Dist = New_Dist_T; % Consider removing - Keeping it as it may be useful as a system output
        Speed_Ahead = New_Speed_Ahead_T;
    
        % Add a new row to the matrix of vehicle positions x time step
        output_road(count, :) = Road;
        output_speed(count, :) = Speed;
        output_accel(count, :) = accel;
        count = count +1;

        %~~~~~~~~~~~~~~~~~~~~~~~~~~~
        % Tracking the number of vehicles to ensure we are not losing any
        vCount = 0;
        for l = 1:n
            if New_Road_T(l) ~= 0
                vCount = vCount + 1;
            end
        end

        if vCount ~= N % Number of vehicles initialased
            disp(vCount - N)
        end
        %~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
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
end