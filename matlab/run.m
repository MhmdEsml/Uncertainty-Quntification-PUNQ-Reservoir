

% ??? ?? ???
m_prior_eclipse=import_m_prior();

%% declare of hard data and non active grids
m_prior=convert_data_eclipse_to_matlab(m_prior_eclipse);

%% import covariance matrix AND weights of obversation data
[C_D,W]=import_cov_matrix_and_weights_of_obs_data();

%% import covariance matrix of model data
C_M=importdata('cov_matrix.mat');

%% import observation data
d_obs=import_observation_data();

n_sim=1;

% ???? ?? ?????
%% import simulation data from eclipse(d_sim)
    d_sim=import_simulation_data();
    
        SoS(n_sim)=0;
    N_d=117; % number of observation data
    for i=1:N_d
        SoS(n_sim)=SoS(n_sim)+((W(i)*(d_obs(i)-d_sim(i)))^2)/(C_D(i,i));
    end
    SoS(n_sim)=SoS(n_sim)/N_d;
    misfit_function=SoS(n_sim);
    n_sim=n_sim+1;