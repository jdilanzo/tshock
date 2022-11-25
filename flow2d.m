function flow2d(tscale,xscale,Q,N,fd)
    hold on
    set(gca,'TickLabelInterpreter','latex')
    contourf(tscale,xscale,Q',64,'LineColor','none'), contour(tscale,xscale,N',30,'k')
    h = colorbar; lims = get(h,'Limits');
    colorbar('YTick',[lims(1) lims(2)],'YTickLabel',{'$$0$$','$$Q_{\mathrm{max}}$$'},'TickLabelInterpreter','latex')
    xlabel('$$t$$','Interpreter','latex'), ylabel('$$x$$','Interpreter','latex')
    hold off
end
