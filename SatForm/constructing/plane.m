function plane(vec,refpoint,dis)
    % coords are [x,y,z] with multiple rows for different points and dis
    % vec is the normal vector
    % point is a point that for reference to plane
    % dis is distance from that point (if at point, distance = 0)
    norm = normalise(vec); 
    
    planepoint = refpoint+norm.*dis;
    
    d = -sum(norm.*planepoint);
        
        

end