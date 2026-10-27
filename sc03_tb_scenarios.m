function S = sc03_tb_scenarios(group)
% SC-03 test-bench scenarios, identical to those used for the results in the report.
% group: 'bat'   battery model (fixingpsc_Copy)        - all battery scenarios except S7
%        'load'  battery model with load breaker       - S7
%        'nobat' resistive-load model (no battery)     - S6a, S6b
% Each scenario: name, stop time, module temperature Tm, irradiance breakpoints
% (tt, G = [G1 G2 G3 G4]; linear interpolation between breakpoints), and for the
% load/no-battery models the breaker time tsw and Rload (both resistor blocks,
% 'Rload' and 'Rstep', use the variable Rload, so the step is 2.05 -> 1.025 ohm).
STC = [1000 1000 1000 1000]; B5a = [1000 1000 700 700]; B5b = [1000 1000 300 300];
SP2 = [1000 500 1000 1000]; SP3 = [1000 700 100 1000]; SP4 = [1000 700 500 250];
Gd  = [700 700 210 210];
S = struct('name',{},'stop',{},'Tm',{},'tt',{},'G',{},'tsw',{},'Rload',{},'Rstep',{});
switch group
  case 'bat'
    S(end+1) = mk('S1 STC',                       3, 25,   0,         STC);
    S(end+1) = mk('S2 steps 1000-200-1000',       6, 25,   [0 2 4],   [STC; 200*[1 1 1 1]; STC]);
    S(end+1) = mk('S2x steps 1000-100-1000',      6, 25,   [0 2 4],   [STC; 100*[1 1 1 1]; STC]);
    S(end+1) = ramp('S3a ramp 100 Wm-2s-1',      300, 1000, 100);
    S(end+1) = ramp('S3b ramp 50 Wm-2s-1',       100,  500,  50);
    S(end+1) = ramp('S3c ramp 30 Wm-2s-1',       300, 1000,  30);
    S(end+1) = ramp('S3d ramp 10 Wm-2s-1',       300, 1000,  10);
    S(end+1) = mk('S4a hot 77 C',                 3, 77,   0,         STC);
    S(end+1) = mk('S4b cold -6.6 C',              3, -6.6, 0,         STC);
    S(end+1) = mk('S5a mild shading',             4, 25,   [0 2],     [STC; B5a]);
    S(end+1) = mk('S5b heavy shading',            4, 25,   [0 2],     [STC; B5b]);
    S(end+1) = onset('S5c shading onset 1 s',     1, 3, STC, B5b);
    S(end+1) = onset('S5d shading onset 10 s',   10, 4, STC, B5b);
    S(end+1) = mk('SM recurring shading',         8, 25,   [0 2 4 6], [STC; B5b; STC; B5b]);
    S(end+1) = mk('SM_miss same shadow, weaker sun', 8, 25, [0 2 4 6], [STC; B5b; Gd; B5b]);
    S(end+1) = mk('SP Chtita patterns',           8, 25,   [0 2 4 6], [STC; SP3; SP2; SP4]);
  case 'load'
    s = mk('S7 load step with battery', 4, 25, 0, STC); s.tsw = 2; s.Rload = 2.05; S(end+1) = s;
  case 'nobat'
    s = mk('S6a shading without battery', 4, 25, [0 2], [STC; B5b]); s.tsw = 100; s.Rload = 2.05; S(end+1) = s;
    s = mk('S6b load step without battery', 4, 25, 0, STC);          s.tsw = 2;   s.Rload = 2.05; S(end+1) = s;
  otherwise
    error('Unknown group %s', group);
end
end

function s = base(name, stop, Tm, tt, G)
s = struct('name',name,'stop',stop,'Tm',Tm,'tt',tt(:),'G',G,'tsw',NaN,'Rload',NaN,'Rstep',NaN);
end

function s = mk(name, stop, Tm, ev, G)
% piecewise-constant profile with 10 ms linear edges at each event
tt = ev(1); gg = G(1,:);
for k = 2:numel(ev)
  tt = [tt; ev(k); ev(k) + 0.01]; gg = [gg; G(k-1,:); G(k,:)]; %#ok<AGROW>
end
tt = [tt; stop]; gg = [gg; G(end,:)];
s = base(name, stop, Tm, tt, gg);
end

function s = ramp(name, Glo, Ghi, rate)
% hold Ghi 2 s -> ramp down -> hold Glo 2 s -> ramp up -> hold Ghi 2 s
Tr = (Ghi - Glo)/rate; t1 = 2; t2 = t1 + Tr; t3 = t2 + 2; t4 = t3 + Tr; stop = t4 + 2;
tt = [0 t1 t2 t3 t4 stop]; g = [Ghi Ghi Glo Glo Ghi Ghi];
s = base(name, stop, 25, tt, g(:)*[1 1 1 1]);
end

function s = onset(name, Ton, hold, G0, G1)
% STC for 2 s, shadow deepens linearly over Ton s, then held
t2 = 2 + Ton; stop = t2 + hold;
s = base(name, stop, 25, [0 2 t2 stop], [G0; G0; G1; G1]);
end
