function [d_sim]=import_simulation_data()
%% import simulation data from eclipse(d_sim)

%% import standard deviation and weight of observation data
BHP_sigma_weight=importdata('BHP_sigma_weight.xlsx'); % see excel file
GOR_sigma_weight=importdata('GOR_sigma_weight.xlsx'); % see excel file
WCT_sigma_weight=importdata('WCT_sigma_weight.xlsx'); % see excel fil

%% dimansion of observation data | (pressure :84(1 to 84) & GOR :25 (85 to 109) & WCT:8 (110 to 117))
N_d=117;


%% open  file from eclipse folder
fid = fopen('C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.RSM');% fopen : opening file (simulation data : 'PUNQ_S3N.RSM' )

% copying 'PUNQ_S3N.RSM' file into a cell
i = 1;
tline = fgetl(fid); % fgetl : copying one line from 'PUNQ_S3N.RSM' file into  tline (char)
A{i} = tline; % copying tline into cell A
while ischar(tline) % ischar : false and true for existing of char (loop end when lines in file are ending)
    i = i+1;
    tline = fgetl(fid);
    A{i} = tline;
end
fclose(fid);
% this file open in 4 sheets (see 'PUNQ_S3N.RSM')
% we need to put data side by side (puting A IN B)

for i=1:4
    for j=1:89
        B{j,i}=A{j+89*(i-1)};
    end
end

% B is string type cell, we convert this cell to double matrix
for i=7:89
    count=1;
    for j=1:4
        b=str2num(B{i,j});
        simulation_data(i-6,count:count+numel(b)-1)=b; % note : sheet 4 has 3 vector against to shett 1 to 3 that has 10
        count=count+10;
    end
end

simulation_data(:,11:10:numel(simulation_data(1,:)))=[]; % declare of vector of time data for shett 2 to 4

d_sim=zeros(N_d,1); % simulatio data : g(m)

%% pressur
count=1;
for i=1:numel(BHP_sigma_weight.data(:,1))% number of observe data for every wells
    for j=1:numel(simulation_data(:,1)) % number of simulation data data for every wells
        if BHP_sigma_weight.data(i,1)==simulation_data(j,1) % recognizing of correspontent data at same time
            for w=1:6 % number of wells
                d_sim(count+(w-1)*numel(BHP_sigma_weight.data(:,1)))=simulation_data(j,13+w-1);
            end
            count=count+1;
            
        end
    end
end

%% GOR
count=84+1;
for w=1:6 % number of wells
    for i=1:numel(GOR_sigma_weight.data(:,1)) % number of observe data for every wells
        for j=1:numel(simulation_data(:,1)) % number of simulation data for every wells
            % recognizing of correspontent data at same time
            if GOR_sigma_weight.data(i,1)==simulation_data(j,1) && GOR_sigma_weight.data(i,2+(w-1)*2)>0
                d_sim(count)=simulation_data(j,19+w-1);
                count=count+1;
            end
        end
    end
end

%% WCT
count=84+25+1;
for w=1:6 % number of wells
    for i=1:numel(WCT_sigma_weight.data(:,1))  % number of observe data for every wells
        for j=1:numel(simulation_data(:,1)) % number of simulation data for every wells
            % recognizing of correspontent data at same time
            if WCT_sigma_weight.data(i,1)==simulation_data(j,1) && WCT_sigma_weight.data(i,2+(w-1)*2)>0
                d_sim(count)=simulation_data(j,25+w-1);
                count=count+1;
            end
        end
    end
end