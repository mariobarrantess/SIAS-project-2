function [et, es, eta, tau_bar, strain] = ramberg_osgood(sigma, mat)

e = mat.E;
sig07 = mat.sigma07;
n = mat.n;

% total strain (ramberg-osgood equation)
strain = (sigma ./ e) + (3/7) .* (sigma ./ e) .* (sigma ./ sig07).^(n-1);

% tangent modulus: et = e / (1 + 3/7 * n * (sigma/sig07)^(n-1))
et = e ./ (1 + (3/7) .* n .* (sigma ./ sig07).^(n-1));

% secant modulus: es = e / (1 + 3/7 * (sigma/sig07)^(n-1))
es = e ./ (1 + (3/7) .* (sigma ./ sig07).^(n-1));

% plasticity correction factors
eta = es ./ e;
tau_bar = sqrt(et .* es) ./ e;

% avoid division by zero or nan at the origin (sigma = 0)
idx_zero = (sigma == 0);
if any(idx_zero)
    et(idx_zero) = e;
    es(idx_zero) = e;
    eta(idx_zero) = 1;
    tau_bar(idx_zero) = 1;
    strain(idx_zero) = 0;
end

end