function dis = dotm(r,n)

    % n normal vectors to find how much r is along them
    
    dis = sum(ones(size(n,1),1)*conj(r).*n,2);


end