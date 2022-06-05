function [m]= model_optimization(m,m_prior,d_obs,d_sim,G,C_D,C_M)

%% gauss newton method
% m : model
% m_prior : prior model
% d_obs : observation data
% d_sim : simulation data
% G : sensitivity matrix
% C_M : covariance matrix of prior model
% C_D : covariance matrix of observation data

% calculate hessian matrix
H=inv(C_M)+G'*inv(C_D)*G;

% calculate gradient
g=inv(C_M)*(m'-m_prior')+G'*inv(C_D)*(d_sim-d_obs);

% update model
dm=-inv(H)*g;
miu=0.1;
m=m'+miu*dm;

% declare of negative porosity from model
for i=1:numel(m)/3
    if m(i)<0
        m(i)=10^-10;
    end
end


















