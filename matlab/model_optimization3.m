function [m,H]= model_optimization3(m,m_prior,d_obs,d_sim,G,C_D,C_M,n_sim,H)

%% BFGS method
% m : model
% m_prior : prior model
% d_obs : observation data
% d_sim : simulation data
% G : sensitivity matrix
% C_M : covariance matrix of prior model
% C_D : covariance matrix of observation data

% calculate hessian matrix
if n_sim==1
H=inv(C_M)+G'*inv(C_D)*G;
end

% calculate gradient
g1=inv(C_M)*(m'-m_prior')+G'*inv(C_D)*(d_sim-d_obs);

% update model
dm=-inv(H)*g1;
m=m'+dm;

% declare of negative porosity from model
for i=1:numel(m)/3
    if m(i)<0
        m(i)=10^-10;
    end
end

g2=inv(C_M)*(m'-m_prior')+G'*inv(C_D)*(d_sim-d_obs);

y=g2-g1;

H=H+(y*y')/(y'*dm)-(H*dm*dm'*H)/(dm'*H*dm);



