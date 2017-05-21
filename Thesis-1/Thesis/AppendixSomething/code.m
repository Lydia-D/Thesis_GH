% A short script to help the user convert values in radians into degrees
% Numerical values will be converted, enter a blank input to exit
while(1),
    % Ask the user for a value
    rads = input('Enter a value in radians (enter nothing to exit): ');
    % If its blank, exit
    if isempty(rads)
        continue;
    end
    % Otherwise convert it to degrees and tell them the answer
    degs = rads * 180/pi;
    disp( [num2str(rads) ' radians is ' num2str(degs) ' degrees.'] );
end
disp('Goodbye.');
