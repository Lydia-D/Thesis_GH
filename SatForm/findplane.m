function plane = findplane(vec,refpoint,dis)
    % coords are [x,y,z] with multiple rows for different points and dis
    % vec is the normal vector
    % point is a point that for reference to plane
    % dis is distance from that point (if at point, distance = 0)
    norm = normalise(vec); 
    
    planepoint = ones(size(vec,1),1)*refpoint+norm.*(dis*ones(1,3));
    
    d = -sum(norm.*planepoint,2);
    plane = [norm,d]; %[a,b,c,d] 
        

end