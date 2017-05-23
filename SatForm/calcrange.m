function range2 = calcrange(posAmat,posBvec)
    
    range = sqrt(sum((posAmat-posBvec*ones(1,size(posAmat,2))).^2,1));
    range2=range';

end