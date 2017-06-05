%% by Lydia Drabsch 11/3/16
% plot coordinate frame about a point
% inputs: T = 4x4 Homogeneous Transformation matrix 
%               T(1:3,4) = postion of origin
%               c = colour of axis
function plotcoordNED(T,c,parent)
    
    % plot global axis
%     fighandle = normvector(eye(3),zeros(3),['x';'y';'z'],['k';'k';'k']); 

    % new origin
    O = [0;0;0;1];
    Onew = T*O;
%     Onew = Onew/norm(Onew(1:3));
    
    % plot Xnew [x,y,z,1] 
    X = [1;0;0;1];
    Xnew = T*X;
%     normvector(Xnew(1:3),Onew(1:3),'xN',c,parent);
    normvector(Xnew(1:3),Onew(1:3),'N',c);
    
    Y = [0;1;0;1];
    Ynew = T*Y;
%     normvector(Ynew(1:3),Onew(1:3),'yN',c,parent);
    normvector(Ynew(1:3),Onew(1:3),'E',c);
    
    Z = [0;0;1;1];
    Znew = T*Z;
%     normvector(Znew(1:3),Onew(1:3),'zN',c,parent);
    normvector(Znew(1:3),Onew(1:3),'D',c);

    axis equal
    grid on
end