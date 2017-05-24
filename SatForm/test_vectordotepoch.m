s21 = X_ECEF_vis(:,1,1)-X_ECEF_vis(:,2,1);

% check time between
timea = 1;
timeb = 2;

s32 = X_ECEF_vis(:,timea,1)-X_ECEF_vis(:,timeb,1);

eta1 = X_ECEF_vis(:,1,1) - X_alpha_ECEF;
eta1n = normalise(eta1);

p_3 = X_ECEF_vis(:,timeb,1) - allRec(timeb,:)';
p_3mag = mag(p_3');

p_2 = X_ECEF_vis(:,timea,1) - allRec(timea,:)';
p_2mag = mag(p_2');

% measure p_3mag and p_2mag from receivers-> they were the pseudorange
% calculations (no errors at this point)
% therefore difference in psudorange between those two along eta1
% first need to transfrom rec3 to sat1(t2)
trans32 = -dot(eta1n,s32);
%diff_p23 = p_2mag-(p_3mag+trans32);

% from sat1(t2)
real_rec3t2 = X_ECEF_vis(:,timea,1) - allRec(timeb,:)';
real_rec3t2_mag = mag(real_rec3t2');
extrapseudo_3t2 = p_3mag-real_rec3t2_mag;




% recalculate eta for each timestep????????


% compare trans32 to 
error = extrapseudo_3t2-trans32


% sum(all_RHO{1}([1,5,8,10]))-all_RHO{1}(4)


