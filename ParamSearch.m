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
    y_val_speed = x_val*0;

    for i = x_val
        params(parameter_num)  = i;
        % Run the simulation
        [output_road, output_speed, output_accel] = CellAutomataV3(params);
        y_val_speed(1 + i - start_range) = sum(sum(output_speed))/((params(3) + 1)*params(2));
        y_val_accel(1 + i - start_range) = sum(sum((output_accel > 0).*output_accel))/((params(3) + 1)*params(2));
        y_val_decel(1 + i - start_range) = sum(sum((output_accel < 0).*output_accel))/((params(3) + 1)*params(2));
    end

    y_val_speed = y_val_speed * 5/9; % convert to cells/delta_t to m/s
    x_val = x_val * 0.001; % convert to cars/m

    figure(1)
    plot(x_val, y_val_speed)
    xlabel('Vehicle Density (cars/meter)');
    ylabel('Speed (m/s)');
    titleText = sprintf('Space mean speed for the whole road section\n with densities from %0.2f to %0.2f cars/meter', ...
        start_range * 0.001, end_range * 0.001);
    title(titleText)

    figure (2)
    plot(x_val, y_val_speed.*x_val) % plot flow (density*speed) in cars/second
    xlabel('Number of vehicles in the road section (density)');
    ylabel('Vehicle Flow (cars/second)');
    titleText = sprintf('Vehicle flow for the whole road section\n with densities from %0.2f to %0.2f cars/meter', ...
        start_range * 0.001, end_range * 0.001);
    title(titleText)