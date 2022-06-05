clear
clc
% porosity
x0=importdata('por.xlsx');
% x0=importdata('perm_h.xlsx');
% x0=importdata('perm_v.xlsx');
% for i=1:19*28*5
%     x0(i)=log(x0(i));
% end


cm=importdata('cm11.mat');
d=det(cm);

p=@(x) exp(-.5*(x-x0)'*inv(cm)*(x-x0));
x=x0+0.01;
p(x);

% p(x);

% count=0;
% n=5;
% x(:,1)=x0;
% for i=2:n
% x(:,i)=min(x0)*ones(length(x0),1)+rand(length(x0),1)*(max(x0)-min(x0));
% 
% if rand<= min(p(x(:,i))/p(x(:,i-1)),1)
%     count=count+1;
%     v(count)=p(x(:,i))/p(x(:,i-1));
%     m(:,count)=x(:,i);
% else
% x(:,i)=x(:,i-1);
% end
% end
% 
% % plot(1:length(m(:,1)),m(:,1))
    




