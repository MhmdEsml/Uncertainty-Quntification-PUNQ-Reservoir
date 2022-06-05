function [d_obs]=import_observation_data()

%% import observation data

%% import standard deviation and weight of observation data
BHP_sigma_weight=importdata('BHP_sigma_weight.xlsx'); % see excel file
GOR_sigma_weight=importdata('GOR_sigma_weight.xlsx'); % see excel file
WCT_sigma_weight=importdata('WCT_sigma_weight.xlsx'); % see excel file

%% import history data
production_history=importdata('production history.xlsx');

%% dimansion of observation data | (pressure :84(1 to 84) & GOR :25 (85 to 109) & WCT:8 (110 to 117))
N_d=117;
%% type of data >> number of well >> time of data
d_obs=zeros(N_d,1);

%% pressur
count=1;
for i=1:numel(BHP_sigma_weight.data(:,1))% number of data for every wells
    for j=1:numel(production_history.data(:,1)) % number of history data for every wells
        if BHP_sigma_weight.data(i,1)==production_history.data(j,2) % recognizing of correspontent data at same time
            for w=1:6 % number of wells
                d_obs(count+(w-1)*numel(BHP_sigma_weight.data(:,1)),1)=production_history.data(j,13+w-1);
            end
            count=count+1;
            
        end
    end
end

%% GOR
count=84+1;
for w=1:6 % number of wells
    for i=1:numel(GOR_sigma_weight.data(:,1)) % number of data for every wells
        for j=1:numel(production_history.data(:,1)) % number of history data for every wells
            % recognizing of correspontent data at same time
            if GOR_sigma_weight.data(i,1)==production_history.data(j,2) && GOR_sigma_weight.data(i,2+(w-1)*2)>0
                d_obs(count,1)=production_history.data(j,19+w-1);
                count=count+1;
            end
        end
    end
end

%% WCT
count=84+25+1;
for w=1:6
    for i=1:numel(WCT_sigma_weight.data(:,1))  % number of wells
        for j=1:numel(production_history.data(:,1)) % number of data for every wells
            % recognizing of correspontent data at same time
            if WCT_sigma_weight.data(i,1)==production_history.data(j,2) && WCT_sigma_weight.data(i,2+(w-1)*2)>0
                d_obs(count,1)=production_history.data(j,25+w-1);
                count=count+1;
            end
        end
    end
end