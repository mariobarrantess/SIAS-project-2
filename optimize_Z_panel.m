function [sigma_section, mass_section, b_section,N_section, ts_section, ZCG_section] = optimize_Z_panel(M, w, t, str, L, alpha, As_bt, ts_t, d2_h, tol, E, n, sigma_07, gamma, hb, h_b, K0)

% PURPOSE: Iteratively sizes a Z-stringer stiffened panel with VARIABLE pitch (b).
%          Updates the cross-section neutral axis (ZCG) which changes the 
%          effective wingbox height (bw) and the applied load (N). It then 
%          corrects for material plasticity using the Ramberg-Osgood model.

% INPUTS:
%   M        - Bending moments at each section [N*m]
%   w        - Wingbox widths (distance between spars) at each section [m]
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
%   h_b      - Height to pitch ratio (h/b), derived from the chart parameters
%   K0       - Plate buckling coefficient (3.6215 for simply supported)

% OUTPUTS:
%   sigma_section - Optimum compressive buckling stress [Pa]
%   mass_section  - Mass per unit length of the panel [kg/m]
%   b_section     - Optimum stringer pitch (spacing between stringers) [m]
%   N_section     - Converged axial load per unit width (compressive flux) [N/m]
%   ts_section    - Computed stringer thickness [m]
%   ZCG_section   - Distance from the skin to the panel's centroid [m]


% Number of sections
nMax = numel(M);
sigma_section = zeros(1, nMax);
mass_section  = zeros(1, nMax);

for i = 1:nMax
    % Initial geometry
    ZCG = 0;
    bw  = hb(i) - 2*ZCG;
    N_val = M(i) / (w(i) * bw);
    errN = inf;

    % Loop until axial force converges
    while errN > tol(i)
        % Plastic-correction for sigma AND compute moduli

        [sigma_val, E_t, E_s, tau_bar] = optimum_sigma(N_val, E, L, alpha, n, sigma_07, tol(i),str{i});
        eta = E_s / E;

        % Update cross-section geometry
        K_tot = k_Z_Instability_coeff(h_b,ts_t);


        b = (sqrt(K_tot) / ((1 + As_bt) * alpha^1.5)) * ((N_val * L^3 * eta^2) / (E * tau_bar^3))^(1/4);
        h = h_b * b; %Stringer height
        d2 = d2_h  * h; %Stringer width
        ts = ts_t * t(i); %Stringer thickness
        As = As_bt * b * t(i); % Stringer cross section area 
        A  = b * t(i) * (1 + As_bt); %Section cross section area (stringer + skin)

        % Recompute centroid and axial force
        ZCG_new = (h/2) * (As / A);
        bw_new  = hb(i) - 2 * ZCG_new;
        N_new   = M(i) / (w(i) * bw_new);
        errN    = abs((N_new - N_val) / N_val);
        N_val   = N_new;
    end

    % Store results and plot    
    sigma_section(i) = sigma_val;
    mass_section(i) = A * gamma;
    b_section(i) = sqrt(K_tot) * ((N_val * L^3 * eta^2) / (E * tau_bar^3))^(1/4) / ((1 + As_bt) * alpha^1.5); 
    N_section(i) = N_val;
    ts_section(i) = ts;
    ZCG_section(i) = ZCG_new;
    h = h_b * b; %Stringer height
   
    % figure(i+3); % crashes with plots on main
    % plot_Z_stringer(b, d2, h, t(i), ts, str{i}, 'variable');

    % Z-stringer plot
    figure('Name', ['Z-Stringer - ' str{i}], 'NumberTitle', 'off');
    plot_Z_stringer(b, d2, h, t(i), ts, str{i}, 'variable');

end
end