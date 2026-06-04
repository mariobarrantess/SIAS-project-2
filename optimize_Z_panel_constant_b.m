function [sigma_section, mass_section, b_section, N_section, ts_section, ZCG_section] = optimize_Z_panel_constant_b(M, w, t, str, L, b_fixed, tol, E, n, sigma_07, gamma, hb, K0)

% PURPOSE: Sizes a Z-stringer panel with a constant pitch 'b' across 
%          all sections (manufacturing constraint).
%          Uses a grid search to find the new optimal geometry ratios 
%          (alpha, As/bt, ts/t) that maximize structural efficiency for 
%          the given 'b', then applies the plasticity correction loop.

% INPUTS:  
%   M        - Bending moments at each section [N*m]
%   w        - Wingbox widths (distance between spars) at each section [m]
%   t        - Skin thicknesses at each section [m]
%   str      - Cell array of strings with section names ({'Root', 'Kink', 'Tip'})
%   L        - Rib spacing / Panel length [m]
%   b_fixed - The constrained stringer pitch (usually the average of variable b's) [m]
%   tol      - Convergence tolerance array for the iterative loop
%   E        - Young's modulus of the material [Pa]
%   n        - Ramberg-Osgood hardening exponent
%   sigma_07 - Ramberg-Osgood yield stress parameter [Pa]
%   gamma    - Material density [kg/m^3]
%   hb       - Initial maximum height of the rectangular wingbox [m]
%   K0       - Plate buckling coefficient (3.6215 for simply supported)

% OUTPUTS:
%   sigma_section - Optimum compressive buckling stress [Pa]
%   mass_section  - Mass per unit length of the panel [kg/m]
%   b_section     - Optimum stringer pitch (spacing between stringers) [m]
%   N_section     - Converged axial load per unit width (compressive flux) [N/m]
%   ts_section    - Computed stringer thickness [m]
%   ZCG_section   - Distance from the skin to the panel's centroid [m]



% Fixed b Z-stringer plastic iteration with grid search
alpha_vals  = 0.7:0.01:0.95;
Asbt_vals   = 0.5:0.1:2.8;
tstt_vals   = 0.6:0.1:1.6;

nMax = numel(M);
sigma_section = zeros(1, nMax);
mass_section  = zeros(1, nMax);

for i = 1:nMax
    best_alpha = 0; best_Asbt = 0; best_tstt = 0; max_alpha = 0;
    % Grid search for max alpha compatible with plastic correction
    for alpha = alpha_vals
        for Asbt = Asbt_vals
            for tstt = tstt_vals
                h_b = Asbt / (tstt * (1 + 2*0.3));
                K_tot = k_Z_Instability_coeff(h_b, tstt);
                A = b_fixed * t(i) * (1 + Asbt);
                N_trial = M(i) / (w(i) * hb(i));
                try
                    [sigma_trial, ~, ~, tau_bar] = optimum_sigma(N_trial, E, L, alpha, n, sigma_07, 1e-3, str{i});
                    alpha_test = sigma_trial / sqrt((N_trial * E * tau_bar) / L);
                    if alpha_test > max_alpha
                        max_alpha = alpha_test;
                        best_alpha = alpha;
                        best_Asbt = Asbt;
                        best_tstt = tstt;
                    end
                catch
                    continue
                end
            end
        end
    end

    % Final iteration using best parameters
    h_b = best_Asbt / (best_tstt * (1 + 2*0.3));
    K_tot = 3.62 * k_Z_Instability_coeff(h_b, best_tstt);
    ZCG = 0;
    bw = hb(i);
    N_val = M(i) / (w(i) * bw);
    errN = inf;
    while errN > tol(i)
        [sigma_val, E_t, E_s, tau_bar] = optimum_sigma(N_val, E, L, best_alpha, n, sigma_07, tol(i), str{i});
        eta = E_s / E;
        h = h_b * b_fixed;
        d2 = 0.3 * h;
        ts = best_tstt * t(i);
        As = best_Asbt * b_fixed * t(i);
        A = b_fixed * t(i) * (1 + best_Asbt);
        ZCG_new = (h/2) * (As / A);
        bw_new = hb(i) - 2 * ZCG_new;
        N_new = M(i) / (w(i) * bw_new);
        errN = abs((N_new - N_val) / N_val);
        N_val = N_new;
    end
    sigma_section(i) = sigma_val;
    mass_section(i)  = A * gamma;
    b_section(i)     = b_fixed;
    N_section(i)     = N_val;
    ts_section(i)    = ts;
    ZCG_section(i)   = ZCG_new;

    % figure(i+10); % ccrashes with main
    % plot_Z_stringer(b_fixed, d2, h, t(i), ts, str{i}, 'constant')

    % Plot of Z-stringer w/ constant b
    figure('Name', ['Z-Stringer (Constant b) - ' str{i}], 'NumberTitle', 'off');
    plot_Z_stringer(b_fixed, d2, h, t(i), ts, str{i}, 'constant');

end
end