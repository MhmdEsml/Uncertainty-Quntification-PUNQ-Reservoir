function [m_prior_eclipse]=import_m_prior()

%% import prior data
% 19*28*5 grids consist of porosity , horizontal perm and vertical perm
% 899 grids are non active
% 30 grids consist of hard data (we have 90 hard data for 3 type of parameter)
m_prior_eclipse=[importdata('por.xlsx')' importdata('perm_h.xlsx')' importdata('perm_v.xlsx')'];
