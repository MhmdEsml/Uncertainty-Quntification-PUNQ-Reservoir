clear
clc
%import prior data
x0=[importdata('por.xlsx');importdata('perm_h.xlsx');importdata('perm_v.xlsx')];
for i=1+19*28*5:19*28*5*3
    x0(i,1)=log(x0(i,1));
end

min_por=(min(importdata('por.xlsx')));
max_por=(max(importdata('por.xlsx')));
min_perm_h=log(min(importdata('perm_h.xlsx')));
max_perm_h=log(max(importdata('perm_h.xlsx')));
min_perm_v=log(min(importdata('perm_v.xlsx')));
max_perm_v=log(max(importdata('perm_v.xlsx')));

cm=importdata('cmcm.mat'); % covariance matrix (containing of harda data and non active grids)
p=@(x) exp(-.5*((x-x0)'*inv(cm)*(x-x0))); % pdf for prior





% count=0;
% n=3; % number of realizations
% x(:,1)=x0;
% for i=2:n
%     
%     x(1:length(x0)/3,i)=min_por*ones(length(x0)/3,1)+randn(length(x0)/3,1);
%     x(1+length(x0)/3:2*length(x0)/3,i)=min_perm_h*ones(length(x0)/3,1)+randn(length(x0)/3,1);
%     x(1+2*length(x0)/3:length(x0),i)=min_perm_v*ones(length(x0)/3,1)+randn(length(x0)/3,1);
%     v(i)=p(x(:,i))
%     if rand<= min(exp(p(x(:,i))-p(x(:,i-1))),1)
%         
%         count=count+1;
%         
%         m(:,count)=x(:,i);
%     else
%         x(:,i)=x(:,i-1);
%     end
% end
% % declare of hard data and non active grids
% for j=1:count
%     m_new(:,j)=convert_data_eclipse_to_matlab(m(:,1)');
% end
% %count is number of accepted realizations







