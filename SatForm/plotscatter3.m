function plotscatter3(data,plotchar,figurehandle)

% matrix of values - [x;y;z]
    figure(figurehandle)
    hold on
    scatter3(data(1,:),data(2,:),data(3,:),plotchar,'filled');
    
end