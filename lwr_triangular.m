addpath('lwrsolver')
clear

% Define state variables.
vfree = 30; uw = -5; rhomax = 0.2;
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

% Create a triangular fundamental diagram.
fd = LH_Tfd(vfree,uw,rhomax);

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
figure
LH_plot2D(tscale,xscale,N,K,fd)
figure
flow2d(tscale,xscale,Q,N,fd)
figure
smsp2d(tscale,xscale,U,N,fd)

NX = gradient(N);
