%% L Drabsch 23/3/17
% Solve relative position between two receivers using 5 satellites and
% slightly noisey data in one point in time

% assumptions:
% satellites at infinity - all signals from the same sat are along the same
%   vector
% random noise: error is larger for calculated gps position than range
%   along one satellite signal path
% ignore multtpath effects


% ideas:
% least squares between potential intersection of relative point
% weight the satellites somehow?

clear
clc
close all
%% ToDO: True positions for one point in time
% what frame of reference to use?
% mimic realistic distances of gnss relative to ground
% mimic realistic positions of gnss satellites in orbits

%% 2D test
% pos = [x,y]

noiseAbs = 10;
noiseRel = 2;

SatA.pos = [0,10000];
SatB.pos = [0,2000];
SatC.pos = [3000,15000];
SatD.pos = [10000, 4000];
SatE.pos = [10000,2000];
SatF.pos = [10000,10000];

alpha.postrue = [500,0];
beta.postrue = [550,20];
alpha.posGPS = alpha.postrue + gen_noise(noiseAbs,[1,2]);
beta.posGPS = beta.postrue + gen_noise(noiseAbs,[1,2]);
mainplot = figure(1);
plot(alpha.posGPS(1),alpha.posGPS(2),'bx');
hold on
plot(alpha.postrue(1),alpha.postrue(2),'bs');
plot(beta.posGPS(1),beta.posGPS(2),'rx');
plot(beta.postrue(1),beta.postrue(2),'rs');



for i= {'A','B','C','D','E','F'} 
    eval(['Sat' i{:} '.range.alpha = calcrange(Sat' i{:} '.pos,alpha.postrue) + gen_noise(noiseRel,[1,1]);']);
    eval(['Sat' i{:} '.range.beta = calcrange(Sat' i{:} '.pos,beta.postrue)+ gen_noise(noiseRel,[1,1]);']);
    eval(['Sat' i{:} '.diff = Sat' i{:} '.range.alpha - Sat' i{:} '.range.beta;']);
    eval(['plot(Sat' i{:} '.pos(1),Sat' i{:} '.pos(2),''ko'');']);
    
    eval(['m1 = (alpha.posGPS(2)-Sat' i{:} '.pos(2))/(alpha.posGPS(1)-Sat' i{:} '.pos(1));']);
    m2 = -1/m1;
    eval(['theta = atan2(alpha.posGPS(2)-Sat' i{:} '.pos(2),alpha.posGPS(1)-Sat' i{:} '.pos(1));'])
    eval(['dx = Sat' i{:} '.diff*cos(theta);'])
    eval(['dy = Sat' i{:} '.diff*sin(theta);']);
    c2 = (alpha.posGPS(2)-dy)-m2*(alpha.posGPS(1)-dx);
    %plot(alpha.posGPS(1)-dx,alpha.posGPS(2)-dy,'sk')
    plotline(mainplot,m2,c2);
    
    
end

grid on
axis([450 600 -20 40])







