function [vel] = calcSpeedAhead(road, speed, vehIndex)

    % Concatenate road sections
    road = [road, road];
    speed = [speed, speed];
    count = 0;
    % check that there is a vehicle at the passed index
    if road(vehIndex) ~= 0
        nextVeh = 0;
        while nextVeh == 0
            count = count + 1;
            nextVeh = road(vehIndex + count);
        end
    end
    vel = speed(vehIndex + count);
end