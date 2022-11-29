addpath('lwrsolver'), mkdir ../Figures
clear

% Define state variables.
vfree = 30; kmax = 0.2;
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
% Define initial and boundary values.
xbound = [xmin xmax]; kinit = 100;
tusbound = [tmin tmax]; kus = 1;
tdsbound = [tmin tmax]; kds = 0;

% Create a Greenshields fundamental diagram.
fd = LH_Greenshields(vfree,kmax);

% Create a spatial domain problem environment.
pbEnv = LH_general(fd,xmin,xmax);
% Define initial vehicle density and up/down-stream traffic flows.
pbEnv.setIniDens(xbound,kinit*1e-03);
pbEnv.setUsFlows(tusbound,kus);
pbEnv.setDsFlows(tdsbound,kds);

% Calculate the global and active solution components.
result = pbEnv.explSol(t,x);
N = result{1}; % Extract Moskowitz function values.
component = result{2}; % Extract active components.
% Compute active component densities, vehicle state-space flows, vehicle
% state-space speeds, and the shock-wave propagation speed.
k = pbEnv.density(t,x,component);
q = fd.flow(k);
v = q./k;
U = gradient(N);

LH_plot3D(tscale,xscale,N,k,fd)
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(['../Figures/lwr_greenshields_' num2str(kinit) '_plot3d.pdf'],'-dpdf');
figure
LH_plot2D(tscale,xscale,N,k,fd)
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(['../Figures/lwr_greenshields_' num2str(kinit) '_plot2d.pdf'],'-dpdf');
figure
flow2d(tscale,xscale,q,N,fd)
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(['../Figures/lwr_greenshields_' num2str(kinit) '_flow2d.pdf'],'-dpdf');
figure
smsp2d(tscale,xscale,v,N,fd)
fig = gcf; fig.PaperPositionMode = 'auto'; fig_pos = fig.PaperPosition; fig.PaperSize = [fig_pos(3) fig_pos(4)];
print(['../Figures/lwr_greenshields_' num2str(kinit) '_smsp2d.pdf'],'-dpdf');
