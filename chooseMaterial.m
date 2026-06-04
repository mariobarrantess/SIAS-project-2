function [name, sigma_tu, sigma_ty, sigma_cy, sigma_p, sigma_07, n, E, E_c, nu, gamma] = chooseMaterial(mat, optmat)

% Load properties for selected material (convert MPa to Pa and g/cm³ to kg/m³)

name = mat(optmat).name;
sigma_tu = mat(optmat).sigma_tu * 1e6;
sigma_ty = mat(optmat).sigma_ty * 1e6;
sigma_cy = mat(optmat).sigma_cy * 1e6;
sigma_p  = mat(optmat).sigma_p * 1e6;
sigma_07 = mat(optmat).sigma07 * 1e6;
n        = mat(optmat).n;
E        = mat(optmat).E * 1e6;
E_c      = mat(optmat).Ec * 1e6;
nu       = mat(optmat).nu;
gamma    = mat(optmat).gamma;

% chosen material - use to check if function is 100% correctly built
% mat(6).E        = 71016;
% mat(6).Ec       = 72395;
% mat(6).sigma_tu = 538;
% mat(6).sigma_ty = 483;
% mat(6).sigma_cy = 475;
% mat(6).sigma_p  = 343;
% mat(6).sigma07  = 496;
% mat(6).n        = 9.2;
% mat(6).nu       = 0.33;
% mat(6).gamma    = 2810;

end
