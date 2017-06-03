%% script to plot colour map on polar

function polarfig= colourpolar_set(X,Y,error)

storeerror = abs(error);
%normstore = storeerror./max(max(storeerror));
map = colormap(jet(1000))
caxis([min(min(storeerror)),max(max(storeerror))])
figure(1);
hold on
%for i = 1:Nel
scatter(reshape(X,1,[]),reshape(Y,1,[]),[],reshape(storeerror,1,[]));
title('Error with Receivers placed 10 km apart Down (meters)')
%end
polarfig = PolarPlot(gcf);
c = colorbar;
c.Location = 'manual';
c.Position = [0.1,0.1,0.05,0.8];

end