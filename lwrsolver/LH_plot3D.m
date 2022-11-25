function LH_plot3D(tScale,xScale,N,k,fd)
    surf(tScale, xScale, N',ones(size(k')),'EdgeColor','none')
    set(gca,'TickLabelInterpreter','latex')
    view([-110 30]), light('Position',[-15 300 14],'Style','local')
    xlabel('$$t$$','Interpreter','latex'), ylabel('$$x$$','Interpreter','latex'), zlabel('$$N$$','Interpreter','latex');
end