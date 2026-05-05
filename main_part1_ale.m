%% PROJECT II — SIAS | AIRBUS A330-200
%  Group 8:
%  Mario Barrantes Mellado (100471762)
%  Juan Carlos López González (100446013)
%  Gonzalo Moreno Martínez (100428612)
%  Alejandra Mei Sangrador Cano (100472588)
%  Víctor Trueba Tamayo (100450919)
%%
clc; clear; close all;

%% 
%  TASK 1-I — DATA FROM OPTIMAL WING BOX (Project I)

%% 
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
%% 
%  TASK 1-II — RECTANGULAR WING BOX SIMPLIFICATION

%%
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
%%
%  OUTPUT STRUCTURE

%% 
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

%% 
%  task 1-iii — material selection and ramberg-osgood curves
% material properties
% ti-6al-4v range values: intermediate = mean of the two bounds

% 1. al 2024-t3 bare sheet
mat(1).name     = 'Al 2024-T3 bare sheet';
mat(1).E        = 72395;
mat(1).Ec       = 73774;
mat(1).sigma_tu = 441;
mat(1).sigma_ty = 324;
mat(1).sigma_cy = 269;
mat(1).sigma_p  = 220;
mat(1).sigma07  = 264;
mat(1).n        = 15;
mat(1).nu       = 0.33;
mat(1).gamma    = 2780;

% 2. al 2024-t3 clad sheet
mat(2).name     = 'Al 2024-T3 clad sheet';
mat(2).E        = 72395;
mat(2).Ec       = 73774;
mat(2).sigma_tu = 414;
mat(2).sigma_ty = 303;
mat(2).sigma_cy = 255;
mat(2).sigma_p  = 183;
mat(2).sigma07  = 246;
mat(2).n        = 9;
mat(2).nu       = 0.33;
mat(2).gamma    = 2780;

% 3. al 2024-t3 extrusion
mat(3).name     = 'Al 2024-T3 extrusion';
mat(3).E        = 74463;
mat(3).Ec       = 75842;
mat(3).sigma_tu = 393;
mat(3).sigma_ty = 290;
mat(3).sigma_cy = 234;
mat(3).sigma_p  = 183;
mat(3).sigma07  = 226;
mat(3).n        = 12;
mat(3).nu       = 0.33;
mat(3).gamma    = 2780;

% 4. al 7050-t7451 bare plate
mat(4).name     = 'Al 7050-T7451 bare plate';
mat(4).E        = 71016;
mat(4).Ec       = 73084;
mat(4).sigma_tu = 510;
mat(4).sigma_ty = 448;
mat(4).sigma_cy = 414;
mat(4).sigma_p  = 353;
mat(4).sigma07  = 418;
mat(4).n        = 19;
mat(4).nu       = 0.33;
mat(4).gamma    = 2830;

% 5. al 2090-t83 (al-li)
mat(5).name     = 'Al 2090-T83 (Al-Li)';
mat(5).E        = 79290;
mat(5).Ec       = 81358;
mat(5).sigma_tu = 517;
mat(5).sigma_ty = 483;
mat(5).sigma_cy = 434;
mat(5).sigma_p  = 374;
mat(5).sigma07  = 437;
mat(5).n        = 20;
mat(5).nu       = 0.34;
mat(5).gamma    = 2590;

% 6. al 7075-t6 bare sheet  <- main material for tasks 2 & 3
mat(6).name     = 'Al 7075-T6 bare sheet';
mat(6).E        = 71016;
mat(6).Ec       = 72395;
mat(6).sigma_tu = 538;
mat(6).sigma_ty = 483;
mat(6).sigma_cy = 475;
mat(6).sigma_p  = 343;
mat(6).sigma07  = 496;
mat(6).n        = 9.2;
mat(6).nu       = 0.33;
mat(6).gamma    = 2810;

% 7. al 7075-t6 clad sheet
mat(7).name     = 'Al 7075-T6 clad sheet';
mat(7).E        = 71016;
mat(7).Ec       = 72395;
mat(7).sigma_tu = 517;
mat(7).sigma_ty = 455;
mat(7).sigma_cy = 448;
mat(7).sigma_p  = 384;
mat(7).sigma07  = 455;
mat(7).n        = 19.5;
mat(7).nu       = 0.33;
mat(7).gamma    = 2810;

% 8. al 7075-t73 extrusion
mat(8).name     = 'Al 7075-T73 extrusion';
mat(8).E        = 71705;
mat(8).Ec       = 73774;
mat(8).sigma_tu = 469;
mat(8).sigma_ty = 400;
mat(8).sigma_cy = 400;
mat(8).sigma_p  = 359;
mat(8).sigma07  = 402;
mat(8).n        = 27;
mat(8).nu       = 0.33;
mat(8).gamma    = 2810;

% 9. ti-6al-4v extrusion annealed — intermediate of range values
mat(9).name     = 'Ti-6Al-4V extr. anneal.';
mat(9).E        = 118590;
mat(9).Ec       = 118590;
mat(9).sigma_tu = 955;   % mean(896,1014)
mat(9).sigma_ty = 872;   % mean(827,917)
mat(9).sigma_cy = 917;   % mean(855,979)
mat(9).sigma_p  = 795;   % mean(741,849)
mat(9).sigma07  = 941;   % mean(874,1007)
mat(9).n        = 21;
mat(9).nu       = 0.31;
mat(9).gamma    = 4430;

% 10. ti-6al-4v sheet aged — intermediate of range values
mat(10).name     = 'Ti-6Al-4V sheet aged';
mat(10).E        = 113074;
mat(10).Ec       = 113074;
mat(10).sigma_tu = 965;   % mean(896,1034)
mat(10).sigma_ty = 896;   % mean(827,965)
mat(10).sigma_cy = 928;   % mean(855,1000)
mat(10).sigma_p  = 809;   % mean(746,872)
mat(10).sigma07  = 953;   % mean(875,1030)
mat(10).n        = 22;
mat(10).nu       = 0.31;
mat(10).gamma    = 4430;

% add materials to shared input file
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

% ramberg-osgood curves 
% ramberg-osgood curves - updated sigma range to show more plastic strain
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

% --- figure 2: plasticity correction factors ---
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


