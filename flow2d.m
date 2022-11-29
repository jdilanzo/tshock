function flow2d(tscale,xscale,q,N,fd)
    colormap(jet(256))
    hold on
    set(gca,'TickLabelInterpreter','latex')
    contourf(tscale,xscale,q',64,'LineColor','none'), contour(tscale,xscale,N',30,'k')
    h = colorbar; lims = get(h,'Limits');
    colorbar('YTick',[lims(1) lims(2)],'YTickLabel',{'$$0$$','$$q_{\mathrm{max}}$$'},'TickLabelInterpreter','latex')
    xlabel('$$t$$','Interpreter','latex'), ylabel('$$x$$','Interpreter','latex')
    hold off
end
