function norm = normalise2(vec)
% 3 by numvectors


% have errors with old code as changed with ', same with mag
    m = mag2(vec);
    norm = vec./(m*ones(1,3));

end