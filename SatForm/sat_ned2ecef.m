% L Drabsch 23/5/17
% input as row vectors
% output as 3 x numSat [x;y;z] in ECEF frame
function Sat_ECEF_global = sat_ned2ecef(el,az,Rec_LLH)

    global r_earth
    a = 2.64*10^7;  % radius of orbit from center of the earth
    maxR = sqrt(a^2-r_earth^2);

    % calculate how far from center to orbit
    R = a.*cos(el + asin(r_earth.*cos(el)./a))./cos(el);
    R(R>maxR) = a-r_earth; % mathematical anomoly at el = pi/2
    
    % inputs as [R, az, el]'
    Sat_LG = polar2cartesian([R;az;el]); % local?
    Sat_ECEF_local = lg2ecef(Sat_LG, Rec_LLH);
    Sat_ECEF_global = Sat_ECEF_local+ llhgc2ecef(Rec_LLH)*ones(1,size(Sat_ECEF_local,2));

end