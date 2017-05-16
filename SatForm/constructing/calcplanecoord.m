function planes = calcplanecoord(refpoint,satellites, receiver)

    % function to use known receiver point to generate the distances that
    % would be given by the pseudorange -> include noise here?


    % create plane at alpha with normal SatA-alpha
    n = ones(size(satellites,1),1)*refpoint-satellites;
    n_norm = normalise(n);
    
    % find distance along vector from sats
    r = receiver-refpoint;
    dis = dotm(r,n_norm);
        
    % calculate planes
    planes = findplane(n,refpoint,dis);


end
