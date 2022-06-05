

function [a,c,n,S] = variogramfit(h,gammaexp,a0,c0,numobs,varargin)
% mohammad=importdata('variogram.xlsx');
% h=mohammad(5:18+4,1);
% gammaexp=mohammad(5:18+4,2);
a0=[];
c0=[];
numobs=10;

% check input arguments

if ~exist('a0','var') || isempty(a0)
a0 = max(h)*2/3;
end
if ~exist('c0','var') || isempty(c0)
c0 = max(gammaexp);
end
if ~exist('numobs','var') || isempty(a0)
numobs = [];
end
% check input parameters
params.model = 'spherical';
params.nugget = [];
params.plotit = true;
params.stablealpha = 1.5;
params.solver ='fminsearch';
params.weightfun = 'cressie85';
params.nu = 1;

% check if fminsearchbnd is in the search path
switch lower(params.solver)
case 'fminsearchbnd'
if ~exist('fminsearchbnd.m','file')==2
params.solver = 'fminsearch';
warning('Variogramfit:fminsearchbnd',...
'fminsearchbnd was not found. fminsearch is used instead')
end
end

% check if h and gammaexp are vectors and have the same size
if ~isvector(h) || ~isvector(gammaexp)
error('Variogramfit:inputargs',...
'h and gammaexp must be vectors');
end
% check size of supplied vectors
if numel(h) ~= numel(gammaexp)
error('Variogramfit:inputargs',...
'h and gammaexp must have same size');
end
% remove nans;
nans = isnan(h) | isnan(gammaexp);
if any(nans);
h(nans) = [];
gammaexp(nans) = [];
if ~isempty(numobs)
numobs(nans) = [];
end
end
% check weight inputs
if isempty(numobs);
params.weightfun = 'none';
end
b(1)=a0;
b(2)=c0;
b0 = [a0 c0 params.nugget];

switch lower(params.model)
case 'spherical'
type = 'bounded';
func = @(b,h)b(2)*((3*h./(2*b(1)))-1/2*(h./b(1)).^3);

case 'exponential'
type = 'unbounded';
func = @(b,h)b(2)*(1-exp(-h./b(1)));
otherwise
error('unknown model')
end

% nugget variance
if isempty(params.nugget)
nugget = false;
funnugget = @(b) 0;
else
nugget = true;
funnugget = @(b) b(3);
end

% create weights (see Webster and Oliver)
switch lower(params.weightfun)
case 'cressie85'
weights = @(b,h) (numobs./variofun(b,h).^2)./sum(numobs./variofun(b,h).^2);
case 'mcbratney86'
weights = @(b,h) (numobs.*gammaexp./variofun(b,h).^3)/sum(numobs.*gammaexp./variofun(b,h).^3);
otherwise
weights = @(b,h) 1;
end

% create objective function: weighted least square
objectfun = @(b)sum(((variofun(b,h)-gammaexp).^2).*weights(b,h));
% call solver
switch lower(params.solver)
case 'fminsearch'
% call fminsearch
[b,fval,exitflag,output] = fminsearch(objectfun,b0);
case 'fminsearchbnd'
% call fminsearchbnd
[b,fval,exitflag,output] = fminsearchbnd(objectfun,b0,lb,ub);
otherwise
error('Variogramfit:Solver','unknown or unsupported solver')
end

% create vector with initial values
a = b(1); %range
c = b(2); %sill
b0 = [a0 c0 params.nugget];

if nugget;
n = b(3);%nugget
else
n = [];
end
% Create structure array with results
if nargout == 4;
S.model = lower(params.model); % model
S.func = func;
S.type = type;
switch S.model
case 'matern';
S.nu = params.nu;
case 'stable';
S.stablealpha = params.stablealpha;
end


S.range = a;
S.sill = c;
S.nugget = n;
S.h = h; % distance
S.gamma = gammaexp; % experimental values
S.gammahat = variofun(b,h); % estimated values
S.residuals = gammaexp-S.gammahat; % residuals
COVyhaty = cov(S.gammahat,gammaexp);
S.Rs = (COVyhaty(2).^2) ./...
(var(S.gammahat).*var(gammaexp)); % Rsquare
S.weights = weights(b,h); %weights
S.weightfun = params.weightfun;
S.exitflag = exitflag; % exitflag (see doc fminsearch)
S.algorithm = output.algorithm;
S.funcCount = output.funcCount;
S.iterations= output.iterations;
S.message = output.message;
end
% if you want to plot the results...
if params.plotit
switch lower(type)
case 'bounded'
plot(h,gammaexp,'rs','MarkerSize',10);
hold on
fplot(@(h) funnugget(b) + func(b,h),[0 b(1)])
fplot(@(h) funnugget(b) + b(2),[b(1) max(h)])

case 'unbounded'
plot(h,gammaexp,'rs','MarkerSize',10);
hold on
fplot(@(h) funnugget(b) + func(b,h),[0 max(h)])
end
axis([0 max(h) 0 max(gammaexp)])
xlabel('lag distance h')
ylabel('\gamma(h)')
hold off
end

% fitting functions for fminsearch/bnd
function gammahat = variofun(b,h)

switch type
% bounded model
case 'bounded'
I = h<=b(1);
gammahat = zeros(size(I));
gammahat(I) = funnugget(b) + func(b,h(I));
gammahat(~I) = funnugget(b) + b(2);
% unbounded model
case 'unbounded'
gammahat = funnugget(b) + func(b,h);
if flagzerodistances
gammahat(izero) = funnugget(b);
end
end
end

end
