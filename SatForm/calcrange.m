function range = calcrange(posAmat,posBvec)

    range = sqrt(sum((posAmat-ones(size(posAmat,1),1)*posBvec).^2,2));
    

end