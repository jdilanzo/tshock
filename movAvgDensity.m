function [out] = movAvgDensity(matrixIn,window)
    %Mov_Avg This function returns a matrix the same sizs as that passed that
    %consists of the moving average of vehicle density for the size of the
    %window passed.
    % Window should be odd. If it is not, the window size will be increased by
    % 1.
    
    % Get the input matrix dimensions
    yMatLen = size(matrixIn, 1);
    xMatLen = size(matrixIn, 2);
    
    % Check and modify the size of window
    if mod(window, 2) == 0
        window = window + 1;
    end
    
    if window < 3
            window = 3;
    end
    
    % Generate padding for the input matrix
    padding = cast((window-1)/2, 'uint8');
    padL = matrixIn(:, end-padding+1:end);
    padR = matrixIn(:, 1:padding);
    
    matrixIn = [padL, matrixIn, padR];

    % Declare the output matrix
    movAvgDensity = zeros(yMatLen, xMatLen);
    
    % Iterate over the input matrix to calculate the moving average
    for i = 1:yMatLen
        for j = 1:xMatLen
            movSum = 0;
            for k = 0:window-1
                % Sum the values in the window and divide by window size
                movSum = movSum + matrixIn(i, j+k);
            end
            % Add the moving average to the output matrix
            movAvgDensity(i, j) = movSum/window;
        end
    end
    out = movAvgDensity;
end