% SC-03 test bench InitFcn (runs automatically when a test-bench model is simulated).
% In the MATLAB Command Window set, for example:   scen = 11; cfg = 3;   then press Run.
%   scen : scenario number in the "Test Cases" subsystem of this model (see its labels)
%   cfg  : 1 P&O, 2 FLC, 3 GWO-FLC, 4 GWO-FLC + memory, 5 open-loop duty ramp (reference sweep)
if ~exist('tbModel','var'), tbModel = bdroot; end
mdl_ = tbModel;
grp_ = getVariable(get_param(mdl_,'ModelWorkspace'), 'tbGroup');
S_ = sc03_tb_scenarios(grp_);
if ~exist('scen','var') || isempty(scen), scen = 1; end
if ~exist('cfg','var')  || isempty(cfg),  cfg = 1;  end
if scen < 1 || scen > numel(S_), error('scen must be 1..%d for this model', numel(S_)); end
swMap_ = [1 2 3 3 4]; sw = swMap_(cfg); useMem = double(cfg == 4);
Cm = 1e-6;
sc_ = S_(scen);
if ~isnan(sc_.tsw),   tsw = sc_.tsw;     end
if ~isnan(sc_.Rload), Rload = sc_.Rload; end
if ~isnan(sc_.Rstep), Rstep = sc_.Rstep; end
set_param(mdl_, 'StopTime', num2str(sc_.stop));
fprintf('Test bench %s: scenario %d (%s), cfg %d, stop %g s\n', mdl_, scen, sc_.name, cfg, sc_.stop);
clear mdl_ grp_ S_ sc_ swMap_ tbModel
