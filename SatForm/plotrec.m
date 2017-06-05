
function plotrec(data,figurehandle)

    ned2xyz = [1,0,0,0;0,-1,0,0;0,0,-1,0;0,0,0,0];
    data_xyz = ned2xyz(1:3,1:3)*data;
    plotscatter3(data_xyz,'bo',figurehandle);
    %plotscatter3(beta_xyz,'bo',figurehandle);
    plotcoordNED(ned2xyz,'k',figurehandle);
    set(gca, 'visible', 'off')
    ax = gca;
    ax.View = [-135,45];

end