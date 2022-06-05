clear
clc
%% UNCERTAINTY
%% RML

%% number of realization
n=1;

for i=1:n
    
    
    %% import prior data
    m_prior_eclipse=import_m_prior();
    
    %% declare of hard data and non active grids
    m_prior=convert_data_eclipse_to_matlab(m_prior_eclipse);
    
    %% import initial guess
    m=m_prior;
    
    %% import covarince matrix of model variable
    C_M=importdata('cov_matrix.mat');
    
    %% cholesky decomposition
    L_M=chol(C_M);
    
    %% unconditional realization of model variables
    m_uc=m_prior'+L_M*random('normal',0,1,numel(m_prior),1);
    
    %% import observation data
    d_obs=import_observation_data();
    
    %% import covariance matrix AND weights of obversation data
    [C_D,W]=import_cov_matrix_and_weights_of_obs_data();
    
    %% cholesky decomposition
    L_D=chol(C_D);
    
    %% unconditional realization of measurment noise
    d_uc=d_obs+L_D*random('normal',0,1,numel(d_obs),1);
    
    
    %% ***********************************************************************
    %% **********************      start loops        ************************
    %% ***********************************************************************
    condition=1;
    n_sim=1;
    
%     while condition > 0.1
         if n_sim==1
              m1=m;
         else
              m1=m';
         end
        %% run eclipse
       
        dos('C:\Users\Mohammad\Desktop\PUNQ\run.bat');
       
        %% import simulation data from eclipse(d_sim)
        d_sim=import_simulation_data();
        
        %% import model from eclipse
        [m_eclipse,M]=import_model();
    
        %% declare of dard data and non active grids
        m=convert_data_eclipse_to_matlab(m_eclipse');
        
        %% calculate sensitivity
        G=sensitivity();
        
        %% model optimization
        m=model_optimization(m,m_prior,d_uc,d_sim,G,C_D,C_M);
        
        %% addition hard data and non active grids
        m_eclipse=convert_data_matlab_to_eclipse(m);
        m2=m;
        
        %% export model to eclipse folder
        export_model_to_eclipse(M,m_eclipse);
        
        %% cheak condition
        condition(n_sim)=norm(m1'-m2)/norm(m2);
        n_sim=n_sim+1;

%     end
%     realization(:,i)=m;
end












