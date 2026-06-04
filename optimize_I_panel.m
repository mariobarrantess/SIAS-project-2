function [sigma_section_I, mass_section_I, b_section_I, N_section_I, ts_section_I, ZCG_section_I] = optimize_I_panel(M, w, t, str, L, alpha2, As_bt, ts_t, tol, E, n, sigma_07, gamma, hb, h_b2, K0)

% PURPOSE: Follows the same logic as Plastic_cycle_Z. 
%          Iteratively sizes an I-shaped stringer stiffened panel with VARIABLE pitch (b). 

% INPUTS:
%   M        - Bending moments at each section [N*m]
%   w        - Wingbox width (distance between spars) at each section [m]
%   t        - Skin thicknesses at each section [m]
%   str      - Cell array of strings with section names (e.g., {'Root', 'Kink', 'Tip'})
%   L        - Rib spacing / Panel length [m]
%   alpha    - Farrar's structural efficiency factor (from charts)
%   As_bt    - Area ratio: Stringer Area/(pitch*skin thickness)
%   ts_t     - Thickness ratio: Stringer thickness / skin thickness
%   d2_h     - Flange width to web height ratio (d/h) for the Z-stringer
%   tol      - Convergence tolerance array for the iterative loop
%   E        - Young's modulus of the material [Pa]
%   n        - Ramberg-Osgood hardening exponent
%   sigma_07 - Ramberg-Osgood yield stress parameter [Pa]
%   gamma    - Material density [kg/m^3]
%   hb       - Initial maximum height of the rectangular wingbox [m]
%   h_b2      - Height to pitch ratio (h/b), derived from the chart parameters
%   K0       - Plate buckling coefficient (3.6215 for simply supported)

% OUTPUTS:
%   sigma_section_I - Optimum compressive buckling stress [Pa]
%   mass_section_I  - Mass per unit length of the panel [kg/m]
%   b_section_I     - Optimum stringer pitch (spacing between stringers) [m]
%   N_section_I     - Converged axial load per unit width (compressive flux) [N/m]
%   ts_section_I    - Computed stringer thickness [m]
%   ZCG_section_I   - Distance from the skin to the panel's centroid [m]


% Number of sections
nMax = numel(M);
sigma_section_I = zeros(1, nMax);
mass_section_I  = zeros(1, nMax);

for i = 1:nMax
    % Initial geometry
    ZCG = 0;
    bw  = hb(i) - 2*ZCG;
    N_val = M(i) / (w(i) * bw);
    errN = inf;

    % Loop until axial force converges
    while errN > tol(i)
        % Plastic-correction for sigma AND compute modulus

        [sigma_val, E_t, E_s, tau_bar] = optimum_sigma(N_val, E, L, alpha2, n, sigma_07, tol(i),str{i});
        eta = E_s / E;

        % Update cross-section geometry
        K_tot = K0 * k_I_Instability_coeff(h_b2, ts_t); % function from aulaglobal

        b = sqrt(K_tot) * ((N_val * L^3 * eta^2) / (E * tau_bar^3))^(1/4) / ((1 + As_bt) * alpha2^1.5); % Distance between stringers
        h = h_b2 * b; %Stringer height

        ts = ts_t * t(i); %Stringer thickness
        As = h*ts; % Stringer cross section area 
        A  = b * t(i) * (1 + As / (b * t(i))); %Section cross section area (stringer + skin)

        % Recompute centroid and axial force
        ZCG_new = (h/2) * (As / A);
        bw_new  = hb(i) - 2 * ZCG_new;
        N_new   = M(i) / (w(i) * bw_new);
        errN    = abs((N_new - N_val) / N_val);
        N_val   = N_new;
    end

    % Store results and plot    
    sigma_section_I(i) = sigma_val;
    mass_section_I(i) = A * gamma;
    ZCG_section_I(i) = ZCG_new;
    b_section_I(i) = b; 
    N_section_I(i) = N_val;
    ts_section_I(i) = ts;


    % figure(i+6); % crashes with plots on main
    % plot_I_stringer(b, h, t, ts, str{i}, i, 'variable')

    % I-stringer plot
    figure('Name', ['I-Stringer - ' str{i}], 'NumberTitle', 'off');
    plot_I_stringer(b, h, t, ts, str{i}, i, 'variable')


end
end