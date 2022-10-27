function ParamSearch(params, parameter_num, start_range, end_range)
    %{
    This function runs the cellular automata program
    accross one argument and plots an output accross that range of the argument.

    Requires three inputs

    params being a vector 10 parameters as below
    
    parameter-num from the list below that you want to explore the range of
      
        params(1) = the number of cells in the road section
        params(2) = number of vehicles on the road section
        params(3) = number of time steps to simulate    
        params(4) = Max_Speed   (int max speed ~= speed limit)
        params(5) = init_speed  (int speed at which venicles are initialised at)
        params(6) = Max_Accel   (int maximum acceleration of the vehicle)
        params(7) = Max_Decel   (int maximum braking of the vehicle)
        params(8) = Buff        (int buffer the driver desires to maintain to the
                                        car ahead)
        params(9) = Delta       (float parameter that ....)
        params(10) = T_gap           (minimum possible time to the car ahead)
    
    start_range = start value of the search range
    end_range = end value of the search range

    %}
    
    % Create vector for the range and output
    x_val = start_range:end_range;
    y_val = x_val*0;

    for i = x_val
        params(parameter_num)  = i;
        % Run the simulation
        [output_road, output_speed, output_accel] = CellAutomataV3(params);
        y_val(1 + i - start_range) = mean(mean(output_speed)); 
    end



    figure(1)
    plot(x_val, y_val)
    xlabel('Number of vehicles in the road section');
    ylabel('Average speed achieved of all vehicles');
    titleText = sprintf('Plot of average speed of all vehicles with %d to %d vehicles', start_range, end_range);
    title(titleText)