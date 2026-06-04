function [sigma, E_t, E_s, tau_bar] = optimum_sigma(N, E, L, alpha, hard_exp, sigma_07, tol, str)

% PURPOSE: Solves the non-linear equation for buckling stress iteratively.
%          Computes the Tangent (E_t) and Secant (E_s) modulus using Ramberg-Osgood,
%          calculates the plasticity correction factor (tau_bar), and updates
%          the stress until it converges (error < tol).

% INPUTS:
%   N        - Axial load per unit width [N/m]
%   E        - Young's modulus [Pa]
%   L        - Panel length / Rib spacing [m]
%   alpha    - Farrar's structural efficiency factor
%   hard_exp - Ramberg-Osgood hardening exponent (n)
%   sigma_07 - Ramberg-Osgood yield parameter [Pa]
%   tol      - Convergence tolerance
%   str      - Section name (used for warning messages only)

% OUTPUTS:
%   sigma    - Converged compressive buckling stress [Pa]
%   E_t      - Tangent Modulus at the converged stress [Pa]
%   E_s      - Secant Modulus at the converged stress [Pa]
%   tau_bar  - Plasticity correction factor (tau = sqrt(Et*Es)/E)


% sigma = alpha * sqrt((N * E * 0.05) / L); % Initial guess
% err   = 1;
% maxIter = 200;  % Maximum number of iterations
% iter = 0;
% 
% while err > tol && iter < maxIter
%     iter = iter + 1;
%     % Ramberg-Osgood modulus
%     E_t = E / (1 + (3/7) * hard_exp * (sigma/sigma_07) ^ (hard_exp-1));
%     E_s = E / (1 + (3/7) * (sigma/sigma_07) ^ (hard_exp-1));
%     tau_bar = (E_s/E) * sqrt(E_t/E_s);
% 
%     % Update sigma
%     sigma_new = alpha * sqrt((N * E * tau_bar) / L);
%     err = abs((sigma_new - sigma) / sigma);
%     sigma = sigma_new;
% end
% 
% if iter >= maxIter
%     warning(['Sigma did not converge in section: ', str, '. Final err: ', num2str(err)]);
% end

% this method is giving lots of convergence errors so a bisection method
% needs to be implemented

%% BISECTION METHOD
% Define the absolute search boundaries
sigma_low = 1000; % 1 kPa minimum boundary
sigma_high = alpha * sqrt((N * E) / L); % Pure elastic theoretical maximum

% Safety cap for extreme loads (prevents out-of-bounds plastic divergence)
if sigma_high > 2 * sigma_07
    sigma_high = 2 * sigma_07;
end

err = 1000;
maxIter = 100;
iter = 0;

% Bisection loop (Mathematically guaranteed to converge)
while err > tol && iter < maxIter
    iter = iter + 1;

    % Guess the midpoint
    sigma_mid = (sigma_low + sigma_high) / 2;

    % Calculate Ramberg-Osgood plasticity at the midpoint
    E_t = E / (1 + (3/7) * hard_exp * (sigma_mid/sigma_07).^(hard_exp-1));
    E_s = E / (1 + (3/7) * (sigma_mid/sigma_07).^(hard_exp-1));
    tau_bar = (E_s/E) * sqrt(E_t/E_s);

    % Calculate theoretical stress for this plasticity level
    sigma_calc = alpha * sqrt((N * E * tau_bar) / L);

    % Narrow the search boundaries
    if sigma_calc > sigma_mid
        sigma_low = sigma_mid; % The root is higher
    else
        sigma_high = sigma_mid; % The root is lower
    end

    % Check convergence
    err = abs(sigma_calc - sigma_mid) / sigma_mid;
    sigma = sigma_mid;
end

if iter >= maxIter
    warning(['Sigma did not converge in section: ', str, '. Final err: ', num2str(err)]);
end

end