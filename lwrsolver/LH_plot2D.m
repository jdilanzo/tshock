function LH_plot2D(tScale,xScale,N,k,fd)
    colormap(jet(256))
    hold on
    set(gca,'TickLabelInterpreter','latex')
    contourf(tScale,xScale,k',64,'LineColor','none'), contour(tScale,xScale,N',30,'k'), caxis([0 fd.kappa])
    colorbar('YTick',[0 fd.density(0) fd.kappa],'YTickLabel',{'$$k_{0}$$','$$k_{\mathrm{crit}}$$','$$k_{\mathrm{max}}$$'},'TickLabelInterpreter','latex')
    xlabel('$$t$$','Interpreter','latex'), ylabel('$$x$$','Interpreter','latex')
    hold off
end