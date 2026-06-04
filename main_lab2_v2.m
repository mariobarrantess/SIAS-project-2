%% PROJECT II — SIAS | AIRBUS A330-200
%  Group 8.-
%  Mario Barrantes Mellado (100471762)
%  Juan Carlos López González (100446013)
%  Gonzalo Moreno Martínez (100428612)
%  Alejandra Mei Sangrador Cano (100472588)
%  Víctor Trueba Tamayo (100450919)

clc; clear; close all;

%%%% comments in functions %%%
% The work was divided among the members of the group, 
% so all funcitons are commented with its purpose, inputs and outputs
% so that the rest of the group could easily understand them
% even if they hadn't been working on them.

%% TASK 1 %%

%%%  TASK 1-I - DATA FROM OPTIMAL WING BOX (Project I)
fprintf('==== TASK 1-I — PROJECT I DATA (A330-200) ====\n');
fprintf('_____________________________________________________\n');
% optimal spar configuration (Table 5 & Page 12, Project I Report)
FS = 0.25;   % Front spar (25% chord)
MS = 0.47;   % Mid spar (47% chord)
RS = 0.65;   % Rear spar (65% chord)
Total_mass_proj1 = 10370; % [kg] — Lightest configuration from Group 8
fprintf('Optimal spar configuration:\n');
fprintf('  Front Spar = %.2fc | Mid Spar = %.2fc | Rear Spar = %.2fc\n', FS, MS, RS);
fprintf('  Total Mass Project I = %.0f kg\n\n', Total_mass_proj1);
% spanwise positions of the sections
y_sec = [0, 9300, 22610];          % [mm] Root / Kink / Tip
% chord geometry at each section 
c_sec = [10500, 7100, 4200];       % [mm] Local chords
% airfoil and relative thickness (NACA 00XX series) 
tc_ratio = [0.14, 0.12, 0.09];     % t/c ratio from report
% maximum airfoil thickness: d = (t/c) * c 
d_sec = tc_ratio .* c_sec;         % [mm]
% wing box width: w = (RS - FS) * c 
% effective width for the upper panel calculation
w_sec = (RS - FS) .* c_sec;        % [mm] (0.4 * c)
% ACTUAL LOADS FROM PROJECT I (LoadsDiederich nz=2.5) 
% Based on Group 8 Bending Moment Diagram (Page 14 & MATLAB output)
M_sec = [4.423e10, 1.685e10, 0.148e10]; % [N·mm] - Corrected values
V_sec = [2.48e6,   1.15e6,   0.28e6];   % [N] - Corrected values
% summary Table Task 1-I
fprintf('%-25s %12s %12s %12s %6s\n', 'Parameter', 'Sec1 Root','Sec2 Kink','Sec3 Tip','Unit');
fprintf('%s\n', repmat('-',1,70));
fprintf('%-25s %12.0f %12.0f %12.0f %6s\n', 'y [mm]',         y_sec,   'mm');
fprintf('%-25s %12.0f %12.0f %12.0f %6s\n', 'Chord c [mm]',   c_sec,   'mm');
fprintf('%-25s %12.2f %12.2f %12.2f %6s\n', 't/c [-]',        tc_ratio, '-');
fprintf('%-25s %12.2f %12.2f %12.2f %6s\n', 'd (max thick) [mm]', d_sec,   'mm');
fprintf('%-25s %12.2f %12.2f %12.2f %6s\n', 'w (box width) [mm]',  w_sec,   'mm');
fprintf('%-25s %12.4e %12.4e %12.4e %6s\n', 'M(y) [N·mm]',    M_sec,   'N·mm');
fprintf('%-25s %12.4e %12.4e %12.4e %6s\n', 'V(y) [N]',       V_sec,   'N');
fprintf('\n');


%%%  TASK 1-II — RECTANGULAR WING BOX SIMPLIFICATION
fprintf('==== TASK 1-II — RECTANGULAR SIMPLIFICATION ====\n');
fprintf('_____________________________________________________\n');
% equivalent wing box height (h_b = 0.85 * d)
h_b = 0.85 .* d_sec;                % [mm]
% initial CG position (assume 0 for Task 1-II)
z_CG_0 = zeros(1,3);                
% effective wing box height (b_W = h_b - 2*z_CG)
b_W = h_b - 2 .* z_CG_0;           
% axial load per unit width: N = M / (w * b_W) [N/mm]
% this is the critical input for stringer/skin stability analysis
N_sec = M_sec ./ (w_sec .* b_W);   
% summary Table Task 1-II
fprintf('%-30s %12s %12s %12s %8s\n', 'Parameter','Sec1 Root','Sec2 Kink','Sec3 Tip','Unit');
fprintf('%s\n', repmat('-',1,78));
fprintf('%-30s %12.2f %12.2f %12.2f %8s\n', 'h_b = 0.85*d [mm]',          h_b,    'mm');
fprintf('%-30s %12.2f %12.2f %12.2f %8s\n', 'w (box width) [mm]',        w_sec,  'mm');
fprintf('%-30s %12.4f %12.4f %12.4f %8s\n', 'N = M/(w*b_W) [N/mm]',       N_sec,  'N/mm');
fprintf('\n');

%%% OUTPUT STRUCTURE 
% data package for the rest of the project
input_ProjectII.y_sec    = y_sec;
input_ProjectII.c_sec    = c_sec;
input_ProjectII.d_sec    = d_sec;
input_ProjectII.w_sec    = w_sec;
input_ProjectII.h_b      = h_b;
input_ProjectII.b_W      = b_W;
input_ProjectII.z_CG_0   = z_CG_0;
input_ProjectII.N_sec    = N_sec;
input_ProjectII.M_sec    = M_sec;
input_ProjectII.V_sec    = V_sec;
input_ProjectII.L_rib    = 720;     % [mm] A330 Rib Spacing reference
input_ProjectII.FS       = FS;
input_ProjectII.RS       = RS;
% material properties (Al 7075-T6 for upper panel)
input_ProjectII.mat.name  = 'Al 7075-T6';
input_ProjectII.mat.E     = 71700;   % [MPa]
input_ProjectII.mat.sigma_y = 503;   % [MPa]
input_ProjectII.mat.rho   = 2810;    % [kg/m^3]
input_ProjectII.mat.n_ro  = 18;      % Ramberg-Osgood coefficient
save('input_ProjectII.mat', 'input_ProjectII');


sec_names = {'Root (y=0 m)', 'Kink (y=9.3 m)', 'Tip (y=22.6 m)'};

colors = {[0, 0.25, 0.53], [0, 0.47, 0.71], [0.28, 0.79, 0.89]};
for i = 1:3
    figure('Name', ['Wing Box Geometry — ' sec_names{i}], 'NumberTitle', 'off');
    
    half_w = w_sec(i)/2;
    half_h = b_W(i)/2;
    
    % rectangular wingbox contour
    rect_x = [-half_w, half_w, half_w, -half_w, -half_w];
    rect_y = [-half_h, -half_h, half_h, half_h, -half_h];

    fill(rect_x, rect_y, colors{i}, 'FaceAlpha', 0.15, 'EdgeColor', colors{i}, 'LineWidth', 2);
    hold on;
    grid on;
    axis equal;
    
    plot([-half_w, half_w], [0, 0], '--k', 'LineWidth', 1);
    
    title_str = sprintf('%s\nN = %.2f N/mm', sec_names{i}, N_sec(i));
    title(title_str, 'FontSize', 12, 'FontWeight','bold');
    xlabel('Width [mm]'); ylabel('Effective Height [mm]');
    
    text(0, 0, sprintf('w = %.0f mm\nh_b = %.0f mm', w_sec(i), h_b(i)), 'HorizontalAlignment','center', 'VerticalAlignment','middle', 'FontWeight','bold');
    
    xlim([-half_w*1.2, half_w*1.2]);
    ylim([-half_h*1.5, half_h*1.5]);
end

%%% TASK 1-III — material selection and ramberg-osgood curves

% material properties
% ti-6al-4v range values: intermediate = mean of the two bounds
[mat] = materialproperties;

% add materials to input file
input_ProjectII.materials = mat;
save('input_ProjectII.mat', 'input_ProjectII');

% print material properties table
n_mat = numel(mat);
props   = {'sigma_tu','sigma_ty','sigma_cy','sigma_p','sigma07','n','E','nu','gamma'};
ulabels = {'MPa','MPa','MPa','MPa','MPa','-','MPa','-','kg/m3'};

fprintf('%-20s', 'property');
for m = 1:n_mat
    fprintf('%26s', mat(m).name);
end
fprintf('\n%s\n', repmat('-', 1, 20 + 26*n_mat));
for p = 1:numel(props)
    fprintf('%-20s', [props{p} ' [' ulabels{p} ']']);
    for m = 1:n_mat
        fprintf('%26.2f', mat(m).(props{p}));
    end
    fprintf('\n');
end
fprintf('\n');

% Ramberg-Osgood curves - updated sigma range to show more plastic strain
sigma_range = {linspace(1, 440, 600), ... % mat 1: al 2024-t3 bare
               linspace(1, 410, 600), ... % mat 2: al 2024-t3 clad
               linspace(1, 390, 600), ... % mat 3: al 2024-t3 extr
               linspace(1, 505, 600), ... % mat 4: al 7050-t7451
               linspace(1, 515, 600), ... % mat 5: al 2090-t83
               linspace(1, 535, 600), ... % mat 6: al 7075-t6 bare (main)
               linspace(1, 515, 600), ... % mat 7: al 7075-t6 clad
               linspace(1, 465, 600), ... % mat 8: al 7075-t73
               linspace(1, 950, 600), ... % mat 9: ti-6al-4v extr
               linspace(1, 960, 600)};    % mat 10: ti-6al-4v sheet

colors_ro = {[0.12 0.47 0.71], [0.20 0.63 0.17], [0.89 0.10 0.11], ...
             [1.00 0.50 0.05], [0.42 0.24 0.60], [0 0.25 0.53],    ...
             [0.65 0.81 0.89], [0.70 0.87 0.54], [0.95 0.63 0.13], ...
             [0.60 0.40 0.12]};

figure('Name', 'Ramberg-Osgood — stress vs strain', 'NumberTitle', 'off');
hold on; grid on;
for m = 1:n_mat
    sig = sigma_range{m};
    [~, ~, ~, ~, eps] = ramberg_osgood(sig, mat(m));
    
    % check if it is our chosen material (Material 6)
    if m == 6
        lw = 3.5;       % extra thick
        col = [0 0 0];  % pure black
    else
        lw = 1.2;       % thinner for the rest
        col = colors_ro{m};
    end
    
    plot(eps * 1e3, sig, 'Color', col, 'LineWidth', lw);
end
xlabel('strain \epsilon [x10^{-3}]');
ylabel('\sigma [MPa]');
title('Ramberg-Osgood stress-strain curves (Selected: Al 7075-T6 in Black)');
legend({mat.name}, 'Location', 'best', 'FontSize', 7);
xlim([0, 500]);

figure('Name', 'Plasticity correction factors', 'NumberTitle', 'off');
% subplot eta
subplot(1,2,1); hold on; grid on;
for m = 1:n_mat
    sig = sigma_range{m};
    [~, ~, eta, ~, ~] = ramberg_osgood(sig, mat(m));
    
    if m == 6
        lw = 3.5; col = [0 0 0];
    else
        lw = 1.2; col = colors_ro{m};
    end
    
    plot(sig, eta, 'Color', col, 'LineWidth', lw);
end
xlabel('\sigma [MPa]'); ylabel('\eta = E_s/E [-]');
title('plate buckling correction \eta');
legend({mat.name}, 'Location', 'southwest', 'FontSize', 7);
ylim([0 1.05]);

% subplot tau
subplot(1,2,2); hold on; grid on;
for m = 1:n_mat
    sig = sigma_range{m};
    [~, ~, ~, tau_bar, ~] = ramberg_osgood(sig, mat(m));
    
    if m == 6
        lw = 3.5; col = [0 0 0];
    else
        lw = 1.2; col = colors_ro{m};
    end
    
    plot(sig, tau_bar, 'Color', col, 'LineWidth', lw);
end
xlabel('\sigma [MPa]'); ylabel('\tau = sqrt(E_t*E_s)/E [-]');
title('column buckling correction tau');
legend({mat.name}, 'Location', 'southwest', 'FontSize', 7);
ylim([0 1.05]);

fprintf('The selected material for the upper panel is: %s\n', mat(6).name);

%%% Properties of Material 6 (Al 7075-T6 bare sheet)
% 1. Loads & Geometry [mm]-> [m]
M  = M_sec * 1e-3;                  % [N*mm] [N*m]
w  = w_sec * 1e-3;                  % [mm] a [m]
hb = h_b * 1e-3;                    % [mm] a [m]
L  = input_ProjectII.L_rib * 1e-3;  % [mm] a [m] (0.720 m)
str = {'Root', 'Kink', 'Tip'};      % Sections to be plotted

%%% Panels thicknesses
t_panels_R = [0.0200, 0.0230, 0.0210, 0.0240, 0.0220, 0.0200, 0.0230, 0.0210, 0.0250, 0.0220, 0.0210];
t_R = mean(t_panels_R);

t_panels_K = [0.0110, 0.0130, 0.0100, 0.0120, 0.0140, 0.0110, 0.0120, 0.0130, 0.0100, 0.0140, 0.0120];
t_K = mean(t_panels_K);

t_panels_075 = [0.0040, 0.0050, 0.0060, 0.0050, 0.0040, 0.0050, 0.0060, 0.0050, 0.0040, 0.0060, 0.0050];
t_075 = mean(t_panels_075);

t = [t_R, t_K, t_075]; % Final thickness vector in meters

%%% MATERIAL SELECTION
optmat = 6; % Al 7075-T6 bare sheet
[name, sigma_tu, sigma_ty, sigma_cy, sigma_p, sigma_07, n, E, E_c, nu, gamma] = chooseMaterial(mat, optmat);

%% TASK 2

%%% Z-Stringer
% Data
alpha = 0.9535; % Condition to maximize stress.
d2_h = 0.3;
K0 = 3.62; % Same for both stringers
tol = [0.1,0.1,0.1]; % Tolerance
L = 0.6; % [m] Rib spacing

% Tables
As_bt = 1.5;
ts_t = 0.95; % These two values are obtained from the graph of the alpha lines

% Computation
h_b = (As_bt)/(ts_t*(1+2*d2_h)); % h/b = 0.98 
ts = t*0.95;

[sigma_section, mass_section, b_section,N_section, ts_section, ZCG_section] = optimize_Z_panel(M, w, t, str, L, alpha, As_bt, ts_t, d2_h, tol, E, n, sigma_07, gamma, hb, h_b, K0);

%%% I-Stringers
% Data
alpha2 = 0.81;

% Table
As_bt2 = 1.5;
ts2_t = 2.3;

% Computation
h_b2 = (As_bt2)/ts2_t; %h_b2 = 0.6521
ts2 = 2.3*t;

% [sigma_section_I, mass_section_I, b_section_I, N_section_I, ts_section_I, ZCG_section_I] = optimize_I_panel(M, w, t, str, L, alpha2, As_bt, ts_t, tol, E, n, sigma_07, gamma, hb, h_b2,K0);
[sigma_section_I, mass_section_I, b_section_I, N_section_I, ts_section_I, ZCG_section_I] = optimize_I_panel(M, w, t, str, L, alpha2, As_bt2, ts2_t, tol, E, n, sigma_07, gamma, hb, h_b2,K0);


%%% TASK 2 RESULTS %%%

% Table for Z-Stringers
fprintf('\n----- Task 2: Z-Stringer Results -----\n');
fprintf('Section\t\tSigma_opt [MPa]\tMass [kg/m]\tb [mm]\tN [N/m]\tts [mm]\tZCG [mm]\n');
for i = 1:3
    fprintf('%s\t\t%.2f\t\t%.3f\t\t%.2f\t%.2f\t%.2f\t%.2f\n', ...
        str{i}, sigma_section(i)/1e6, mass_section(i), b_section(i)*1000, ...
        N_section(i), ts_section(i)*1000, ZCG_section(i)*1000);
end

% Table for I-Stringers
fprintf('\n----- Task 2: I-Stringer Results -----\n');
fprintf('Section\t\tSigma_opt [MPa]\tMass [kg/m]\tb [mm]\tN [N/m]\tts [mm]\tZCG [mm]\n');
for i = 1:3
    fprintf('%s\t\t%.2f\t\t%.3f\t\t%.2f\t%.2f\t%.2f\t%.2f\n', ...
        str{i}, sigma_section_I(i)/1e6, mass_section_I(i), b_section_I(i)*1000, ...
        N_section_I(i), ts_section_I(i)*1000, ZCG_section_I(i)*1000);
end

%% Task 3
b_fixed_Z = mean(b_section); 
b_fixed_I = mean(b_section_I);

[sigma_section_b_const, mass_section_b_const, b_section_b_const, N_section_b_const, ts_section_b_const, ZCG_section_b_const] = optimize_Z_panel_constant_b(M, w, t, str, L, b_fixed_Z, tol, E, n, sigma_07, gamma, hb, K0);

[sigma_section_I_b_const, mass_section_I_b_const, b_section_I_b_const, N_section_I_b_const, ts_section_I_b_const, ZCG_section_I_b_const] = optimize_I_panel_constant_b(M, w, t, str, L, b_fixed_I, tol, E, n, sigma_07, gamma, hb,K0);

% Task 3 Results
fprintf('\n----- Task 3: Z-Stringer Results (Constant b = %.1f m) -----\n', b_fixed_Z);
fprintf('Section\t\tSigma_opt [MPa]\tMass [kg/m]\tb [mm]\tN [N/m]\tts [mm]\tZCG [mm]\n');
for i = 1:3
    fprintf('%s\t\t%.2f\t\t%.3f\t\t%.2f\t%.2f\t%.2f\t%.2f\n', ...
        str{i}, sigma_section_b_const(i)/1e6, mass_section_b_const(i), b_section_b_const(i)*1000, ...
        N_section_b_const(i), ts_section_b_const(i)*1000, ZCG_section_b_const(i)*1000);
end

fprintf('\n----- Task 3: I-Stringer Results (Constant b = %.1f m) -----\n', b_fixed_I);
fprintf('Section\t\tSigma_opt [MPa]\tMass [kg/m]\tb [mm]\tN [N/m]\tts [mm]\tZCG [mm]\n');
for i = 1:3
    fprintf('%s\t\t%.2f\t\t%.3f\t\t%.2f\t%.2f\t%.2f\t%.2f\n', ...
        str{i}, sigma_section_I_b_const(i)/1e6, mass_section_I_b_const(i), b_section_I_b_const(i)*1000, ...
        N_section_I_b_const(i), ts_section_I_b_const(i)*1000, ZCG_section_I_b_const(i)*1000);
end

%% Task 4
% Axial loads per unit width (from Task 1)
N_unit = M ./ (w .* hb);

% Buckling & chart ratios
K0 = 3.62; % plate buckling coefficient
alpha = 0.9535; % stress amplification factor
d2_h = 0.3; % d/h for Z stringer 
L_rib = 0.6; % rib spacing [m]

% Z–stringer chart ratios (As/(b·t) and ts/t)
As_bt = 1.5;
ts_t = 0.95;
h_b = As_bt/(ts_t * (1 + 2*d2_h));

% I–stringer chart ratios
As_bt_i = 2.0;
ts_t_i = 1.5;
h_b_i = As_bt_i/ (ts_t_i* (1 + 2*d2_h));

% Section names for printing
sections = {'Root','Kink','Tip'};

% Material Sensitivity (root & tip only)
% We will reuse the same Z- and I-stringer sizing routines, but sweep four materials.

% Material definitions
materials = [6, 1, 5, 9]; 

sections_sens = [1, 3];  % only root (1) and tip (3)

% Preallocate results: columns = [Z_var, I_var, Z_const, I_const]
sensitvity_matrix = zeros(numel(materials), numel(sections_sens), 4);

% Loop over materials & the two sections
for m = 1:numel(materials)

    mat_sens = materials(m); % material properties

    materialNames{m} = mat(mat_sens).name; % material names
    % [materialNames, ~, ~, ~, ~, ~, ~, ~, ~, ~, ~] = chooseMaterial(mat, mat_sens);

    E_mat   = mat(mat_sens).E * 1e6; % [MPa] -> [Pa]
    rho_mat = mat(mat_sens).gamma; % [kg/m^3]

    for s = 1:numel(sections_sens)
        i = sections_sens(s);
        N0 = N_unit(i); % axial load/unit width (from Task 1)

        % Z-stringer w/ variable b
        KtotZ = K0 * k_Z_Instability_coeff(h_b, ts_t);
        bZ = sqrt(KtotZ) * ((N0*L_rib^3)/E_mat)^(1/4) / ((1+As_bt)*alpha^1.5);
        weight_Z_var = bZ * t(i) * (1+As_bt) * rho_mat;

        % I-stringer w/ variable b
        alpha2 = 0.81; % Efficiency parameter for I-stringers
        KtotI = K0 * k_I_Instability_coeff(h_b_i, ts_t_i);
        bI = sqrt(KtotI) * ((N0*L_rib^3)/E_mat)^(1/4) / ((1+As_bt_i)*alpha2^1.5);
        massI_var = bI * t(i) * (1+As_bt_i) * rho_mat;

        % Z-stringer w/ constant b
        massZ_c = b_fixed_Z * t(i) * (1+As_bt) * rho_mat;

        % I-stringer w/ constant b
        massI_c = b_fixed_I * t(i) * (1+As_bt_i) * rho_mat;

        sensitvity_matrix(m, s, :) = [weight_Z_var, massI_var, massZ_c, massI_c];
    end
end

% Table with solution for each material
fprintf('\n Task 4: Material Sensitivity \n');
for m = 1:numel(materials)
    fprintf('Material %i: %s\n', materials(m), materialNames{m});
    for s = 1:numel(sections_sens)
        sec  = sections_sens(s);
        vals = squeeze(sensitvity_matrix(m,s,:));
        fprintf(' Section %d (%s):  Z_var=%.3f kg, I_var=%.3f kg, Z_const=%.3f kg, I_const=%.3f kg\n', ...
            sec, sections{sec}, vals(1), vals(2), vals(3), vals(4));
    end
    fprintf('\n');
end

%% MATERIAL COMPARISON PLOTS

% Labels
material_labels = {'7075-T6', '2024-T3', '2090-T83', 'Ti-6Al-4V'};
config_labels = {'Z var-b', 'I var-b', 'Z const-b', 'I const-b'};

%% ROOT SECTION PLOT
root_data = squeeze(sensitvity_matrix(:,1,:));

figure('Name','Root Section Material Comparison','NumberTitle','off');

bar(root_data);

grid on;
ylabel('Weight W [kg]');
xlabel('Material');
title('Root Section — Weight vs Material');
xticks(1:length(material_labels));
xticklabels(material_labels);
legend(config_labels,'Location','northwest');

%% TIP SECTION PLOT
tip_data = squeeze(sensitvity_matrix(:,2,:));

figure('Name','Tip Section Material Comparison','NumberTitle','off');

bar(tip_data);

grid on;
ylabel('Weight W [kg]');
xlabel('Material');
title('Tip Section — Weight vs Material');
xticks(1:length(material_labels));
xticklabels(material_labels);
legend(config_labels,'Location','northwest');
