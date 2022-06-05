clear
clc
%% import prior model
m=zeros(19*28*5,3);
m(:,1)=importdata('por.xlsx');
m(:,2)=importdata('perm_h.xlsx');
for i=1:numel(m(:,2))
    m(i,2)=log(m(i,2));
end
m(:,3)=importdata('perm_v.xlsx');
for i=1:numel(m(:,3))
    m(i,3)=log(m(i,3));
end
%% location of grids
grids=zeros(19*28*5,3); % column 1 : x , column 2 : y ,column 3 : depth

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


%% calculate semivariogram
variogram_v=zeros(13,7);
variogram_v(:,1)=[4; 6 ;8; 10; 12; 14; 16; 28; 20; 22; 24; 26; 28 ];


for a=1:3
    for b=a:3
        for h=1:13
            sum=0;
            count=0;
            for i=1:19*28*5
                for j=i+1:19*28*5
                    if h_matrix(i,j)>variogram_v(h,1)-2 && h_matrix(i,j)<variogram_v(h,1)+2
                        count=count+1;
                        sum=sum+(m(i,a)-m(j,a))*(m(i,b)-m(j,b));
                    end
                end
            end
            
            if a==2 || a==3
                variogram_v(h,a+b+1)=sum/(2*count);
            else
                variogram_v(h,a+b)=sum/(2*count);
            end
        end
    end
end
for i=1:6
    figure(i);
    variogramfit(variogram_v(1:10,1),variogram_v(1:10,i+1));
end


variogram_h=zeros(8,7);
for i=1:8
variogram_h(i,1)=i*180*2^.5;
end

for a=1:3
    for b=a:3
        for h=1:8
            sum=0;
            count=0;
            for i=1:19*28*5
                for j=i+1:19*28*5
                    if h_matrix(i,j)>variogram_h(h,1)-5 && h_matrix(i,j)<variogram_h(h,1)+5
                        count=count+1;
                        sum=sum+(m(i,a)-m(j,a))*(m(i,b)-m(j,b));
                    end
                end
            end
            
            if a==2 || a==3
                variogram_h(h,a+b+1)=sum/(2*count);
            else
                variogram_h(h,a+b)=sum/(2*count);
            end
        end
    end
end

for i=7:12
    figure(i);
    variogramfit(variogram_h(1:8,1),variogram_h(1:8,i-5));
end

for z=1:5
mean_depth_layers(z)=mean(grids(1+(z-1)*19*28:19*28*z,3));
end






