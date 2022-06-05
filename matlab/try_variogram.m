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
mm=zeros(28,19,5,3);
for z=1:1:5
    mm(:,:,z,1)=reshape(m(1+19*28*(z-1):1:19*28*z,1),19,28)';
    mm(:,:,z,2)=reshape(m(1+19*28*(z-1):1:19*28*z,2),19,28)';
    mm(:,:,z,3)=reshape(m(1+19*28*(z-1):1:19*28*z,3),19,28)';
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

variogram_h=zeros(15,7);
for i=1:1:15
    variogram_h(i,1)=i*180;
end
for a=1:1:3
    for b=a:1:3
        % a=1,b=1 :porosity-porosity
        % a=1,b=2 :porosity-horizontal perm
        % a=1,b=3 :porosity-vertical perm
        % a=2,b=2 :horizontal perm-horizontal perm
        % a=2,b=3 :horizontal perm-vertical perm
        % a=3,b=3 :vertical perm-vertical perm
        
        %column1=h %column2=phi*phi %column3=phi*permh %column4=phi*permv
        %column5=permh*permh %column6=permh*permv %column7=permv*permv
        
        for h=0:1:14
            c=0;
            count=0;
            for z=1:1:5
                for i=1:1:28
                    for j=1:1:18-h
                        count=count+1;
                        c=c+(mm(i,j,z,a)-mm(i,j+1+h,z,a))*(mm(i,j,z,b)-mm(i,j+1+h,z,b));
                        
                    end
                end
            end
            
            for z=1:1:5
                for j=1:1:19
                    for i=1:1:27-h
                        c=c+(mm(i,j,z,a)-mm(i+1+h,j,z,a))*(mm(i,j,z,b)-mm(i+1+h,j,z,b));
                        count=count+1;
                    end
                end
            end
            if a==2 || a==3
                variogram_h(h+1,a+b+1)=c/(2*count);
            else
                variogram_h(h+1,a+b)=c/(2*count);
            end
        end
    end
    
end


% for i=2:1:7
%     figure(i-1),plot(variogram_h(:,1),variogram_h(:,i),'*');
% end

for i=1:6
    figure(i);
    variogramfit(variogram_h(:,1),variogram_h(:,i+1));
end

variogram_v=zeros(4,7);
for i=1:1:4
    variogram_v(i,1)=i*4.85;
end

for a=1:1:3
    for b=a:1:3
        % a=1,b=1 :porosity-porosity
        % a=1,b=2 :porosity-horizontal perm
        % a=1,b=3 :porosity-vertical perm
        % a=2,b=2 :horizontal perm-horizontal perm
        % a=2,b=3 :horizontal perm-vertical perm
        % a=3,b=3 :vertical perm-vertical perm
        
        %column1=h %column2=phi*phi %column3=phi*permh %column4=phi*permv
        %column5=permh*permh %column6=permh*permv %column7=permv*permv
        
        for h=0:1:3
            c=0;
            count=0;
            
            for i=1:1:28
                for j=1:1:19
                    for z=1:1:4-h
                        count=count+1;
                        c=c+(mm(i,j,z,a)-mm(i,j,z+1+h,a))*(mm(i,j,z,b)-mm(i,j,z+1+h,a));
                    end
                end
            end
            
            
            if a==2 || a==3
                variogram_v(h+1,a+b+1)=c/(2*count);
            else
                variogram_v(h+1,a+b)=c/(2*count);
            end
        end
    end
    
end



% for i=8:1:13
%     figure(i-1),plot(variogram_v(:,1),variogram_v(:,i),'*');
% end

for i=7:12
    figure(i);
    variogramfit(variogram_v(:,1),variogram_v(:,i-5));
end

























