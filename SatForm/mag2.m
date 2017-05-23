function m=mag2(vec)
 % row vectors
    if(size(vec,2)==3)
        m = sqrt(vec(:,1).^2+vec(:,2).^2+vec(:,3).^2);
    elseif(size(vec,2)==2)
        m = sqrt(vec(:,1).^2+vec(:,2).^2);
    end
end