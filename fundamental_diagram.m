clear
mkdir ../Figures
gray = [128 128 128]/255;

% Specify example parameters.
rho_jam = 1; v_max = 30;
rho = 0:0.01:1;

% Compute Greenshield's fundamental diagrams.
V = v_max - (v_max/rho_jam)*rho;
Q = V.*rho;

% Plot density-speed plane.
plot(rho,V), xlim([0 1.1]), ylim([0 31])
axp = get(gca,'Position');
xs = axp(1); xe = axp(1)+axp(3)+0.04; ys = axp(2); ye = axp(2)+axp(4)+0.05;
annotation('arrow',[xs xe],[ys ys]); annotation('arrow',[xs xs],[ys ye]);
set(gca,'box','off')
set(gca,'YTick',[]), set(gca,'XTick',[])
set(gca,'YColor',get(gca,'Color')), set(gca,'XColor',get(gca,'Color'))
xlabel('$\rho$','Interpreter','latex','Color','k'), ylabel('$V(\rho)$','Interpreter','latex','Color','k')
text(rho_jam,-1,'$\rho_{\mathrm{jam}}$','Interpreter','latex','Color',gray), text(-0.08,max(V),'$v_{\mathrm{max}}$','Interpreter','latex','Color',gray)
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print('../Figures/fd_density_speed.pdf','-dpdf');
    
% Plot density-flow plane.
plot(rho,Q), xlim([0 1.1]), ylim([0 8])
axp = get(gca,'Position');
xs = axp(1); xe = axp(1)+axp(3)+0.04; ys = axp(2); ye = axp(2)+axp(4)+0.05;
annotation('arrow',[xs xe],[ys ys]); annotation('arrow',[xs xs],[ys ye]);
set(gca,'box','off')
set(gca,'YTick',[]), set(gca,'XTick',[])
set(gca,'YColor',get(gca,'Color')), set(gca,'XColor',get(gca,'Color'))
xlabel('$\rho$','Interpreter','latex','Color','k'), ylabel('$Q(\rho)$','Interpreter','latex','Color','k')
text(rho_jam,-0.25,'$\rho_{\mathrm{jam}}$','Interpreter','latex','Color',gray), text(-0.08,max(Q),'$v_{\mathrm{max}}$','Interpreter','latex','Color',gray)
line([0.5*rho_jam;0.5*rho_jam],[0;max(Q)],'linestyle','--','Color',gray);
line([0;0.5*rho_jam],[max(Q);max(Q)],'linestyle','--','Color',gray);
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print('../Figures/fd_density_flow.pdf','-dpdf');

% Plot flow-speed plane.
plot(Q,V)
axp = get(gca,'Position');
xs = axp(1); xe = axp(1)+axp(3)+0.04; ys = axp(2); ye = axp(2)+axp(4)+0.05;
annotation('arrow',[xs xe],[ys ys]); annotation('arrow',[xs xs],[ys ye]);
set(gca,'box','off')
set(gca,'YTick',[]), set(gca,'XTick',[])
set(gca,'YColor',get(gca,'Color')), set(gca,'XColor',get(gca,'Color'))
xlabel('$Q$','Interpreter','latex','Color','k'), ylabel('$V$','Interpreter','latex','Color','k')
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print('../Figures/fd_flow_speed.pdf','-dpdf');
