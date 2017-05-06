function dis = costresidual(plane,coord)

    % coord - [x,y,z] of guessed position of receiver i
    % plane - [Aj Bj Cj Dj] with j rows for each sat
    m = mag(plane(:,1:3));      % sqrt(A^2+B^2+C^2)
    dis = plane*[coord,1]'./m;  % matrix mult Ax+By+Cz+D / m
    % this is distance from each plane perpendicularly - convert to x,y,z?
    % can be close to a few planes without being close to intersection.
    % need to solve best intersection first



end