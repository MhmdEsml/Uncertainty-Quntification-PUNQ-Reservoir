function [G]=sensitivity()
%% sensitivity

%% import standard deviation and weight of observation data (for declare of excess data from G)
% BHP_sigma_weight=importdata('BHP_sigma_weight.xlsx'); % see excel file
GOR_sigma_weight=importdata('GOR_sigma_weight.xlsx'); % see excel file
WCT_sigma_weight=importdata('WCT_sigma_weight.xlsx'); % see excel file

%% pressure
timesteps_pressure={'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0002'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0006'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0010'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0014'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0018'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0021'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0024'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0026'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0029'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0031'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0034'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0036'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0039'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0041'};

for r=1:numel(timesteps_pressure)
    % opening  file
    fid = fopen(timesteps_pressure{r});
    
    % copying files into a cell
    i = 1;
    tline = fgetl(fid);
    A{i} = tline; % copying tline into cell A
    while ischar(tline) % ischar : false and true for existing of char (loop end when lines in file are ending)
        i = i+1;
        tline = fgetl(fid);
        A{i} = tline;
    end
    fclose(fid);
    
    
    CONDITON_WHP_G=importdata('CONDITION_WBP_G.mat');
    count=0;
    for i=1:numel(A)
        for j=1:numel(CONDITON_WHP_G)
            if strcmp(A{i},CONDITON_WHP_G{j})
                count=count+1;
                c=0;
                for k=i+1:i+441
                    m=str2num(A{k});
                    for p=1:numel(m)
                        c=c+1;
                        mm(count,c)=m(p);
                    end
                end
            end
        end
    end
    
    
    for i=1:6
        mmm(i,:)=[mm(i,:) mm(i+6,:) mm(i+12,:)];
    end
    
    for t=1:6
        G_PRESSURE(r+numel(timesteps_pressure)*(t-1),:)=mmm(t,:);
    end
end

%% GOR

timesteps_GOR={'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0023'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0024'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0027'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0028'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0029'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0033'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0034'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0038'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0039'};

for r=1:numel(timesteps_GOR)
    % opening  file
    fid = fopen(timesteps_GOR{r});
    
    % copying files into a cell
    i = 1;
    tline = fgetl(fid);
    B{i} = tline; % copying tline into cell A
    while ischar(tline) % ischar : false and true for existing of char (loop end when lines in file are ending)
        i = i+1;
        tline = fgetl(fid);
        B{i} = tline;
    end
    fclose(fid);
    
    
    CONDITON_GOR_G=importdata('CONDITION_GOR_G.mat');
    count=0;
    for i=1:numel(B)
        for j=1:numel(CONDITON_GOR_G)
            if strcmp(B{i},CONDITON_GOR_G{j})
                count=count+1;
                c=0;
                for k=i+1:i+441
                    w=str2num(B{k});
                    for p=1:numel(w)
                        c=c+1;
                        ww(count,c)=w(p);
                    end
                end
            end
        end
    end
    
    
    
    for i=1:6
        www(i,:)=[ww(i,:) ww(i+6,:) ww(i+12,:)];
    end
    for t=1:6
        G_gor(r+numel(timesteps_GOR)*(t-1),:)=www(t,:);
    end
end

count=0;
COUNT=0;
for i=2:2:12
    for j=1:numel(GOR_sigma_weight.data(:,1))
        COUNT=COUNT+1;
        if GOR_sigma_weight.data(j,i)>0
            count=count+1;
            num_data_GOR(count)=COUNT;
        end
    end
end

count=0;
for i=1:numel(G_gor)
    for j=1:numel(num_data_GOR)
        if i==num_data_GOR(j)
            count=count+1;
            G_GOR(count,:)=G_gor(i,:);
            break
        end
    end
end

%% WCT

timesteps_WCT={'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0037'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0038'
    'C:\Users\Mohammad\Desktop\PUNQ\PUNQ_S3N.F0039'};

for r=1:numel(timesteps_WCT)
    % opening  file
    fid = fopen(timesteps_WCT{r});
    
    % copying files into a cell
    i = 1;
    tline = fgetl(fid);
    C{i} = tline; % copying tline into cell A
    while ischar(tline) % ischar : false and true for existing of char (loop end when lines in file are ending)
        i = i+1;
        tline = fgetl(fid);
        C{i} = tline;
    end
    fclose(fid);
    
    
    CONDITON_GOR_G=importdata('CONDITION_WCT_G.mat');
    count=0;
    for i=1:numel(C)
        for j=1:numel(CONDITON_GOR_G)
            if strcmp(C{i},CONDITON_GOR_G{j})
                count=count+1;
                c=0;
                for k=i+1:i+441
                    o=str2num(C{k});
                    for p=1:numel(o)
                        c=c+1;
                        oo(count,c)=o(p);
                    end
                end
            end
        end
    end
    
   
    
    for i=1:6
        ooo(i,:)=[oo(i,:) oo(i+6,:) oo(i+12,:)];
    end
    for t=1:6
        G_wct(r+numel(timesteps_WCT)*(t-1),:)=ooo(t,:);
    end
end

count=0;
COUNT=0;
for i=2:2:12
    for j=1:numel(WCT_sigma_weight.data(:,1))
        COUNT=COUNT+1;
        if WCT_sigma_weight.data(j,i)>0
            count=count+1;
            num_data_WCT(count)=COUNT;
        end
    end
end

count=0;
for i=1:numel(G_wct)
    for j=1:numel(num_data_WCT)
        if i==num_data_WCT(j)
            count=count+1;
            G_WCT(count,:)=G_wct(i,:);
            break
        end
    end
end

%% sensitivity matrix (with hard data)
G=zeros(117,5283);
% type of data >> wells >> time data
G=[G_PRESSURE ;G_GOR;G_WCT];

%% declare of hard data
LOCATION_HARD_DATA=importdata('location_wells.xlsx');
location_hard_data=LOCATION_HARD_DATA.data;
c=0;
for k=1:1:3 % 1: porosity ,2: horizontal perm ,3:vertical perm
    for i=1:1:5 % layers
        for j=1:1:6 % wells
            c=c+1;
            n_active_grids(c)=(location_hard_data(j,2)-1)*19+location_hard_data(j,1)+19*28*(i-1)+19*28*5*(k-1);
        end
    end
end
N_active_grids=sort(n_active_grids);

actnum_grids=importdata('actnum.txt');
actnum_grids=reshape(actnum_grids',numel(actnum_grids),1);
c=0;
for i=1:numel(actnum_grids)
    if actnum_grids(i)==1
        c=c+1;
        n_hard_data(c)=i; % porosity
        c=c+1;
        n_hard_data(c)=i+19*28*5; % horizontal perm
        c=c+1;
        n_hard_data(c)=i+19*28*5*2; % vertical perm
    end
end

N_hard_data=sort(n_hard_data);
count=0;
for i=1:numel(N_hard_data)
    for j=1:numel(N_active_grids)
        if N_hard_data(i)==N_active_grids(j)
            count=count+1;
            num_hard_data(count)=i;
            break
        end
    end
end

for i=numel(num_hard_data):-1:1
    G(:,num_hard_data(i))=[];
end

% import model from eclipse
[m_eclipse,M]=import_model();

% declare of dard data and non active grids
m=convert_data_eclipse_to_matlab(m_eclipse');

% multiply kh and kv in G (columns of horizontal perm and vertical perm)
G_new=G;
for i=numel(m)/3+1:numel(m)
    G_new(:,i)=m(i)*G(:,i);
end

% multiply 1/ WOPR in G (rows of GOR and WCT)
% open  file from eclipse folder
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
% well oil production rate
WOPR=zeros(117,1);
% pressure
for i=1:84
    WOPR(i,1)=1;
end

% GOR
count=84+1;
for w=1:6 % number of wells
    for i=1:numel(GOR_sigma_weight.data(:,1)) % number of observe data for every wells
        for j=1:numel(simulation_data(:,1)) % number of simulation data for every wells
            % recognizing of correspontent data at same time
            if GOR_sigma_weight.data(i,1)==simulation_data(j,1) && GOR_sigma_weight.data(i,2+(w-1)*2)>0
                WOPR(count)=simulation_data(j,7+w-1);
                count=count+1;
            end
        end
    end
end

% WCT
count=84+25+1;
for w=1:6 % number of wells
    for i=1:numel(WCT_sigma_weight.data(:,1))  % number of observe data for every wells
        for j=1:numel(simulation_data(:,1)) % number of simulation data for every wells
            % recognizing of correspontent data at same time
            if WCT_sigma_weight.data(i,1)==simulation_data(j,1) && WCT_sigma_weight.data(i,2+(w-1)*2)>0
                WOPR(count)=simulation_data(j,7+w-1);
                count=count+1;
            end
        end
    end
end
G_new2=G_new;
for i=1:117
    G_new2(i,:)=(1/WOPR(i,1)).*G_new(i,:);
end

G=G_new2;


    









