function [m_eclipse]=convert_data_matlab_to_eclipse(m_matlab)
% convert model parameters :matlab to eclipse
% addition of hard data and actnum grids

% ************** recognizing of hard data ********************
%%% location of wells (i,j)
% well 1 : 10,22
% well 2 : 9,17
% well 3 : 17,11
% well 4 : 11,24
% well 5 : 15,12
% well 6 : 17,22

LOCATION_HARD_DATA=importdata('location_wells.xlsx');
location_hard_data=LOCATION_HARD_DATA.data; % location of wells (i,j)


%%% number of grids that wells perch
% layer 1 : 1 to 6
% layer 1 : 7 to 12
% layer 1 : 13 to 18
% layer 1 : 19 to 24
% layer 1 : 25 to 30

c=0;
for k=1:1:3 % 1: porosity ,2: horizontal perm ,3:vertical perm
    for i=1:1:5 % layers
        for j=1:1:6 % wells
            c=c+1;
            % n0 is containing of number of grids that wells perch
            n0(c)=(location_hard_data(j,2)-1)*19+location_hard_data(j,1)+19*28*(i-1)+19*28*5*(k-1);
        end
    end
end

n=sort(n0);

HARD_DATA=importdata('hard_data.xlsx'); % import hard data
hard_data=HARD_DATA.data;
hard_data(1,:)=[]; % see excele file (dimension : 15*6) >>> we need vector

% construction of vector of hard data
for k=1:1:3
    c=0;
    for i=1:1:5 % layers
        for j=1:1:6 % wells
            c=c+1;
            a(c,k)=hard_data(1+(i-1)*3+(k-1),j);
        end
    end
end

HARD_DATA=[a(:,1);a(:,2);a(:,3)]; % vector

c=0;
hard_data_vector=zeros(19*28*5*3,1);
for i= 1:19*28*5*3
    for j=1:numel(n)
        if i==n(j)
            c=c+1;
            hard_data_vector(i,1)=HARD_DATA(c);
            break;
        end
        
    end
end

for i=1+19*28*5:1:19*28*5*3
    if hard_data_vector(i)~=0
    hard_data_vector(i)=exp(hard_data_vector(i));
    end
end


% ************** recognizing of actnum grids ********************
actnum_grids=importdata('actnum.txt');
actnum_grids=reshape(actnum_grids',numel(actnum_grids),1);

c=0;
for i=1:numel(actnum_grids)
    if actnum_grids(i)==0
        c=c+1;
        m0(c)=i; % porosity
        c=c+1;
        m0(c)=i+19*28*5; % horizontal perm
        c=c+1;
        m0(c)=i+19*28*5*2; % vertical perm
    end
end

m=sort(m0);
m_prior=[importdata('por.xlsx');importdata('perm_h.xlsx');importdata('perm_v.xlsx')];


for i= 1:19*28*5*3
    for j=1:numel(m)
        if i==m(j)
            actnum_vector(i,1)=m_prior(i);
            break;
        else
            actnum_vector(i,1)=0;
            
        end
    end
end

% ************** recognizing of active and non hard data grids ********************
c=0;
for k=1:3
    for i=1:19*28*5
        if actnum_grids(i)==1 && hard_data_vector(i)==0
            c=c+1;
            b(i+19*28*5*(k-1),1)=m_matlab(c);
        else
            b(i+19*28*5*(k-1),1,1)=0;
            
        end
    end
end

for i=1+19*28*5:1:19*28*5*3
    if b(i)~=0
    b(i)=exp(b(i));
    end
end


% see x matrix for understanding of this code
%  x=[b actnum_vector hard_data_vector]; % ***for check***
m_eclipse=b+actnum_vector+hard_data_vector;