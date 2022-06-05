clear
clc
%% HISTORY MATCHING

%% import prior data
m_prior_eclipse=import_m_prior();

%% declare of hard data and non active grids
m_prior=convert_data_eclipse_to_matlab(m_prior_eclipse);

%% import covariance matrix AND weights of obversation data
[C_D,W]=import_cov_matrix_and_weights_of_obs_data();

%% import covariance matrix of model data
C_M=importdata('cov_matrix.mat');

%% import observation data
d_obs=import_observation_data();

%% ***********************************************************************
%% **********************      start loops        ************************
%% ***********************************************************************

n_sim=1; % number of simulations
misfit_function=1; % objective function for minimizing of likelihood

  while misfit_function >0.1


    
    
    %% run eclipse
    dos('ADD the eclipse source code address');
    
    %% import simulation data from eclipse(d_sim)
    d_sim=import_simulation_data();
    
    %% import model from eclipse
    [m_eclipse,M]=import_model();
    
    %% declare of dard data and non active grids
    m=convert_data_eclipse_to_matlab(m_eclipse');
    
    %% calculate sensitivity
    G=sensitivity();
    
    %% model optimization
% %     gauss newton
%     m=model_optimization(m,m_prior,d_obs,d_sim,G,C_D,C_M);
    
    
%     BFGS
%     if n_sim==1
%         H=0;
%     end
%     model_optimization3(m,m_prior,d_obs,d_sim,G,C_D,C_M,n_sim,H);


%     restricted step
%     if n_sim==1
%          h=1;
%     end
%     [m,h]= model_optimization_2(m,m_prior,d_obs,d_sim,G,C_D,C_M,n_sim,h);


    
    %% addition hard data and non active grids
    m_eclipse=convert_data_matlab_to_eclipse(m);
    
    %% export model to eclipse folder
    export_model_to_eclipse(M,m_eclipse);
    
    %% calculate misfit function
    SoS(n_sim)=0;
    N_d=117; % number of observation data
    for i=1:N_d
        SoS(n_sim)=SoS(n_sim)+((W(i)*(d_obs(i)-d_sim(i)))^2)/(C_D(i,i));
    end
    SoS(n_sim)=SoS(n_sim)/N_d;
    misfit_function=SoS(n_sim);
    
%% step of optimization
    n_sim=n_sim+1;
    
   end

%%
plot(1:n_sim,SoS);




















