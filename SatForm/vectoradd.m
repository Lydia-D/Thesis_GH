%% matrix minus

function output = vectoradd(mat1,vec,sign)

    if size(mat1,1)==size(vec,1)
        output = mat1 + sign*vec*ones(1,size(mat1,2));
    elseif size(mat1,2) == size(vec,2)
        output = mat1 + sign*ones(size(mat1,1),1)*vec;
    end

end