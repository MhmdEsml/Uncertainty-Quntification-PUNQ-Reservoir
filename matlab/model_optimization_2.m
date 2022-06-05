%function [m,h]= model_optimization_2(m,m_prior,d_obs,d_sim,G,C_D,C_M,n_sim,h)

%% gauss newton method with restricted step algorithm
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


% restricted step
if n_sim==1
h=0.05*norm(m);
end

if norm(dm)>h
    dm=(h/norm(dm))*dm;
end

mc=m'+dm;

O=@(m) 0.5*(m'-m_prior')'*inv(C_M)*(m'-m_prior')+0.5*(d_sim-d_obs)'*inv(C_D)*(d_sim-d_obs);

r=(O(m+dm')-O(m))/(g'*dm+0.5*dm'*H*dm);

while r<0
    h=norm(dm)/4;
    dm=dm/4;
    r=(O(m+dm')-O(m))/(-g'*dm-0.5*dm'*H*dm);
    mc=m'+dm;
end

if r<0.25
    h=norm(dm)/4;
elseif r>0.75 && norm(dm)==h
    h=2*h;
else
    h=h;
end

m=mc;

% declare of negative porosity from model
for i=1:numel(m)/3
    if m(i)<0
        m(i)=10^-10;
    end
end




















