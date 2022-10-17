function [dist] = calcDist(road,vehIndex)
    %UNTITLED3 Summary of this function goes here
    %   Detailed explanation goes here

    % Concatenate road sections
    road = [road, road];
    count = 0;
    % check that there is a vehicle at the passed index
    if road(vehIndex) ~= 0
        nextVeh = 0;
        while nextVeh == 0
            count = count + 1;
            nextVeh = road(vehIndex + count);
        end
    end
    dist = count - 1;
end