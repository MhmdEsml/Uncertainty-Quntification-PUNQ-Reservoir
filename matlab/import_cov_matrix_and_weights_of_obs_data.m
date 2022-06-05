function [C_D,W]=import_cov_matrix_and_weights_of_obs_data()

%% import standard deviation and weight of observation data
BHP_sigma_weight=importdata('BHP_sigma_weight.xlsx'); % see excel file
GOR_sigma_weight=importdata('GOR_sigma_weight.xlsx'); % see excel file
WCT_sigma_weight=importdata('WCT_sigma_weight.xlsx'); % see excel file

%% dimansion of observation data | (pressure :84(1 to 84) & GOR :25 (85 to 109) & WCT:8 (110 to 117))
N_d=117;

%% covariance matrix of obversation data AND weights
% type of data >> number of well >> time of data
C_D=zeros(N_d,N_d); % covariance matrix    
W=zeros(N_d,1); % weights

% pressure 
count=1;
for i=1:6 % column of every wells (there is same columns for every wells % see 'BHP_sigma_weight.xlsx')
    for j=1:numel(BHP_sigma_weight.data(:,1)) % number of observe data for every wells
        C_D(count,count)=(BHP_sigma_weight.data(j,2))^2;
        W(count,1)=BHP_sigma_weight.data(j,3);
        count=count+1;
    end
end

% GOR
for i=2:2:12 % column of every wells (there is no same columns for every wells % see 'GOR_sigma_weight.xlsx')
    for j=1:numel(GOR_sigma_weight.data(:,1)) % number of observe data for every wells
        if GOR_sigma_weight.data(j,i)>0 % declare of excess data for every wells (see 'GOR_sigma_weight.xlsx' )
            C_D(count,count)=(GOR_sigma_weight.data(j,i))^2;
            W(count,1)=GOR_sigma_weight.data(j,i+1);
            count=count+1;
        end
    end
end

% WCT
for i=2:2:12 % column of every wells (there is no same columns for every wells % see 'WCT_sigma_weight.xlsx')
    for j=1:numel(WCT_sigma_weight.data(:,1)) % number of observe data for every wells
        if WCT_sigma_weight.data(j,i)>0 % declare of excess data for every wells (see 'WCT_sigma_weight.xlsx' )
            C_D(count,count)=(WCT_sigma_weight.data(j,i))^2;
            W(count,1)=WCT_sigma_weight.data(j,i+1);
            count=count+1;
        end
    end
end