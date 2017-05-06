function plotline(h,m,c)
    % inputs: h = handle to plot
    
    y = @(x) m*x+c;
    figure(h);
    plot([0:1:1000],y([0:1:1000]),'c')
    
    

end