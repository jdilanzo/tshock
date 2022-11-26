addpath('lwrsolver'), mkdir ../Figures
clear

% Define state variables.
vfree = 30; rhomax = 0.2;
% Define space variables.
xmin = 0; xmax = 1000;
tmin = 0; tmax = 50;
nx = 500;
nt = 500;
dx = xmax/nx;
dt = tmax/nt;
xscale = xmin:dx:xmax;
tscale = tmin:dt:tmax;
x = ones(size(tscale')) * xscale;
t = tscale' * ones(size(xscale));

% Create a Greenshields fundamental diagram.
fd = LH_Greenshields(vfree,rhomax);

% Create a spatial domain problem environment.
pbEnv = LH_general(fd,xmin,xmax);
% Define initial vehicle density and up/down-stream traffic flows.
pbEnv.setIniDens([xmin xmax],90e-3);
pbEnv.setUsFlows([tmin tmax],1);
pbEnv.setDsFlows([tmin tmax],0);

% Calculate the global and active solution components.
result = pbEnv.explSol(t,x);
N = result{1}; % Extract Moskowitz function values.
component = result{2}; % Extract active components.
% Compute active component densities, vehicular state-space flows, and
% space mean speed.
K = pbEnv.density(t,x,component);
Q = fd.flow(K);
U = Q./K;

LH_plot3D(tscale,xscale,N,K,fd)
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print('../Figures/lwr_greenshield_plot3d.pdf','-dpdf');
figure
LH_plot2D(tscale,xscale,N,K,fd)
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print('../Figures/lwr_greenshield_plot2d.pdf','-dpdf');
figure
flow2d(tscale,xscale,Q,N,fd)
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print('../Figures/lwr_greenshield_flow2d.pdf','-dpdf');
figure
smsp2d(tscale,xscale,U,N,fd)
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print('../Figures/lwr_greenshield_smsp2d.pdf','-dpdf');

NX = gradient(N);
