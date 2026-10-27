# SC-03: Intelligent MPPT for a Stand-Alone PV System

MATLAB/Simulink models for the EEE4022F final-year project (University of Cape Town, 2026).
Four MPPT controllers are compared on the same PV plant:

| cfg | Controller |
|-----|------------|
| 1 | Perturb and Observe (P&O) |
| 2 | Fuzzy logic controller (FLC) |
| 3 | Hybrid GWO-FLC |
| 4 | GWO-FLC with stored-peak memory |
| 5 | Open-loop duty ramp (reference sweep for the maximum available power) |

The plant is a string of two Phaesun Sun Plus 80 modules (four sub-modules), an average-model
buck converter and a 12.8 V LiFePO4 battery (Simscape Electrical, Specialized Power Systems).

## Requirements

- MATLAB and Simulink **R2025a** (the models are saved in R2025a)
- Simscape Electrical (Specialized Power Systems). This library is removed in R2026a, so use R2025a or R2025b.
- Fuzzy Logic Toolbox

## Files

| File | Purpose |
|------|---------|
| `SC03_testbench.slx` | Battery-connected system, all scenarios except S6 and S7 |
| `SC03_testbench_load.slx` | Battery-connected system with a load breaker (S7) |
| `SC03_testbench_nobat.slx` | System without battery, resistive load (S6a, S6b) |
| `flc_mppt.fis` | Fuzzy inference system used by the FLC and GWO-FLC |
| `sc03_tb_init.m` | Model initialisation, runs automatically when a model is simulated |
| `sc03_tb_scenarios.m` | Irradiance, temperature and load profiles of every scenario |

## How to run

1. Make this folder the current folder in MATLAB (all files must stay together; the FLC block loads `flc_mppt.fis` by name).
2. Open a model, for example `SC03_testbench.slx`.
3. In the Command Window, choose a scenario and a controller, for example:
   ```matlab
   scen = 11; cfg = 3;   % S5b heavy shading, GWO-FLC
   ```
4. Press **Run**. The stop time is set automatically and the scenario is printed in the Command Window.

## Scenarios

**`SC03_testbench.slx`**

| scen | Scenario |
|------|----------|
| 1 | S1 STC (1000 W/m², 25 °C) |
| 2 | S2 steps 1000 → 200 → 1000 W/m² |
| 3 | S2x steps 1000 → 100 → 1000 W/m² |
| 4 | S3a ramp 300–1000 W/m² at 100 W/m²/s |
| 5 | S3b ramp 100–500 W/m² at 50 W/m²/s |
| 6 | S3c ramp 300–1000 W/m² at 30 W/m²/s |
| 7 | S3d ramp 300–1000 W/m² at 10 W/m²/s |
| 8 | S4a hot, 77 °C |
| 9 | S4b cold, −6.6 °C |
| 10 | S5a mild shading [1000 1000 700 700] |
| 11 | S5b heavy shading [1000 1000 300 300] |
| 12 | S5c shading onset over 1 s |
| 13 | S5d shading onset over 10 s |
| 14 | SM recurring shading (STC / S5b / STC / S5b) |
| 15 | SM_miss same shadow at 70 % irradiance |
| 16 | SP Chtita et al. patterns (SP1 → SP3 → SP2 → SP4) |

**`SC03_testbench_load.slx`**: 1 = S7 load step with battery (2.05 → 1.025 Ω at 2 s)

**`SC03_testbench_nobat.slx`**: 1 = S6a shading without battery, 2 = S6b load step without battery

## Author

Kaushal Bhiwajee (BHWKAU001), supervised by A/Prof. Sunetra Chowdhury, University of Cape Town.
