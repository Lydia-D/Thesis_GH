function range = calcrange2(posAmat,posBvec)
    
    range = sqrt(sum((posAmat-ones(size(posAmat,1),1)*posBvec).^2,2));

end