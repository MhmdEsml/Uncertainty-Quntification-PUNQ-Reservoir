function [m_matlab]=convert_data_eclipse_to_matlab(m_eclipse)

% convert model parameters :eclipise to matlab
% declare of hard data and actnum grids

% k >> log(k)
for i=19*28*5+1:1:19*28*5*3
    m_eclipse(i)=log(m_eclipse(i));
end
% ************** recognizing of hard data ********************

%%% location of wells (i,j)
% well 1 : 10,22
% well 2 : 9,17
% well 3 : 17,11
% well 4 : 11,24
% well 5 : 15,12
% well 6 : 17,22

LOCATION_HARD_DATA=importdata('location_wells.xlsx');
location_hard_data=LOCATION_HARD_DATA.data;

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
            n(c)=(location_hard_data(j,2)-1)*19+location_hard_data(j,1)+19*28*(i-1)+19*28*5*(k-1);
        end
    end
end

%************** recognizing of actnum grids ********************
actnum_grids=importdata('actnum.txt');
actnum_grids=reshape(actnum_grids',numel(actnum_grids),1);

for i=1:numel(actnum_grids)
    if actnum_grids(i)==0
        c=c+1;
        n(c)=i; % porosity
        c=c+1;
        n(c)=i+19*28*5; % horizontal perm
        c=c+1;
        n(c)=i+19*28*5*2; % vertical perm
    end
end

m=sort(n);

for i=length(m):-1:1
    m_eclipse(:,m(i))=[];
end

m_matlab=m_eclipse;