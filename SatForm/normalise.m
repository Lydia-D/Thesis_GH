function norm = normalise(vec)

    m = mag(vec);
    norm = vec./(m*ones(1,3));

end