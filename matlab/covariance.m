clear;
clc;
% % input every model parameters at their locations
% 
% for z=1:1:5
% for i=1+19*28*(z-1):1:19*28*z
%     col=mod((i-(z-1)*19*28)-1,19)+1;
%     row=((i-(z-1)*19*28)-col)/19+1;
%     m(i,1)=row;
%     m(i,2)=col;
%     m(i,3)=z;
% end
% end

% % distance of any two grids
% 
% h_matrix=zeros(19*28*5,19*28*5);
% for i=1:1:19*28*5
%     for j=i:1:19*28*5
%         h_matrix(i,j)=((((m(i,1)-m(j,1))*180)^2)+(((m(i,2)-m(j,2))*180)^2)+(((m(i,3)-m(j,3))*180)^2))^.5;
%     end
% end
% clear of hard data

%% depth
ZCORN_data=importdata('zcorn.txt');% import zcorn data (depth of corner points)

% to understand this you should see 'zcorn.txt'
for k=1:length(ZCORN_data)/7
    count=1;
    for i=1+(k-1)*7:7*k
        for j=1:6
            if ZCORN_data(i,j)>0
                zcorn_data(k,count)=ZCORN_data(i,j);
                count=count+1;
            end
        end
    end
end

% calculating of depth of every grids
count=1;
for k=1:5
    for i=1:2:56
        for j=1:2:38
            grids(count,3)=((zcorn_data(i+(k-1)*56*2,j)+zcorn_data(i+(k-1)*56*2,j+1)...
                +zcorn_data(i+1+(k-1)*56*2,j)+zcorn_data(i+1+(k-1)*56*2,j+1))...
                +(zcorn_data(i+56+(k-1)*56*2,j)+zcorn_data(i+56+(k-1)*56*2,j+1)...
                +zcorn_data(i+1+56+(k-1)*56*2,j)+zcorn_data(i+1+56+(k-1)*56*2,j+1)))/8;
            count=count+1;
        end
    end
end

%% x and y
X_AND_Y=importdata('x and y.txt');

% to understand this you should see 'x and y.txt'
for j=1:29
    for i=1:20
        x(i,j)=X_AND_Y(i+(j-1)*20,1);
        y(i,j)=X_AND_Y(i+(j-1)*20,2);
    end
end

% for j=1:29
%     for i=1:20
%         y(i,j)=X_AND_Y(i+(j-1)*20,2);
%     end
% end

count=1;
for k=1:5
    for j=1:28
        for i=1:19
            grids(count,1)=(x(i,j)+x(i,j+1)+x(i+1,j)+x(i+1,j+1))/4;
            grids(count,2)=(y(i,j)+y(i,j+1)+y(i+1,j)+y(i+1,j+1))/4;
            count=count+1;
        end
    end
end

%% calculate distance of grids
for i=1:19*28*5
    for j=1:19*28*5
        h_matrix(i,j)=((grids(i,1)-grids(j,1))^2+(grids(i,2)-grids(j,2))^2+(grids(i,3)-grids(j,3))^2)^.5;
    end
end

%% variogram's functions and their sills
sill_11=6e-3;
range_11=1300;
C11= @(x) (x<1300)*sill_11*exp(-3*x/range_11); % porosity-porosity

sill_12=0.01;
range_12=1600;
C12= @(x) (x<1600)*sill_12*exp(-3*x/range_12); % porosity-horizontal perm

sill_13=0.096;
range_13=1950;
C13= @(x) (x<1950)*sill_13*exp(-3*x/range_13); % porosity-vertical perm

sill_22=2.68;
range_22=1250;
C22= @(x) (x<1250)*sill_22*exp(-3*x/range_22); % horizontal perm-horizontal perm

sill_23=2.45;
range_23=1800;
C23= @(x) (x<1800)*sill_23*exp(-3*x/range_23);% horizontal perm-vertical prem

sill_33=3.08;
range_33=1600;
C33= @(x) (x<1600)*sill_33*exp(-3*x/range_33); % vaertival perm-vertical perm

% covariance AND cross covariance 
 CM=zeros(19*28*5,19*28*5,6);
 for i=1:1:19*28*5
     for j=1:1:19*28*5
         
         if (i<=19*28 && j<=19*28)||(i>19*28 && j>19*28 && i<=2*19*28 && j<=2*19*28)||...
                 (i>2*19*28 && j>2*19*28 && i<=3*19*28 && j<=3*19*28)||...
                 (i>3*19*28 && j>3*19*28 && i<=4*19*28 && j<=4*19*28)||...
                 (i>4*19*28 && j>4*19*28 && i<=5*19*28 && j<=5*19*28)
             
         CM(i,j,1)=C11(h_matrix(i,j)); % porosity-porosity
         CM(i,j,2)=C12(h_matrix(i,j)); % porosity-horizontal perm
         CM(i,j,3)=C13(h_matrix(i,j)); % porosity-vertical perm
         CM(i,j,4)=C22(h_matrix(i,j)); % horizontal perm-horizontal perm
         CM(i,j,5)=C23(h_matrix(i,j)); % horizontal perm-vertical prem
         CM(i,j,6)=C33(h_matrix(i,j)); % vaertival perm-vertical perm
         end

     end
 end
 covariance_matrix=[CM(:,:,1),CM(:,:,2),CM(:,:,3);CM(:,:,2),CM(:,:,4),CM(:,:,5);CM(:,:,3),CM(:,:,5),CM(:,:,6)];

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
    covariance_matrix(:,m(i))=[];
    covariance_matrix(m(i),:)=[];
end

xlswrite('C_M',covariance_matrix);








    
    