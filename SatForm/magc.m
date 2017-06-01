function m=magc(vec)
 % row vectors
    if(size(vec,1)==3)
        m = sqrt(vec(1,:).^2+vec(2,:).^2+vec(3,:).^2);
    elseif(size(vec,1)==2)
        m = sqrt(vec(:,1).^2+vec(:,2).^2);
    end
end