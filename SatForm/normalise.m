function norm = normalise(vec)
% 3 by numvectors


% have errors with old code as changed with ', same with mag
    m = mag(vec');
    norm = vec./(m*ones(1,3))';

end