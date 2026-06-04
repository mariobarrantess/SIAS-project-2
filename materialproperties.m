function [mat] = materialproperties

% PURPOSE: 
%   Database of properties of all materials available in slides. 

% OUTPUTS:
%   mat - A 1x10 struct array where each index contains the properties of 
%         a specific material.
%   mat.name     : Material designation (string)
%   mat.E        : Tensile elastic modulus [MPa]
%   mat.Ec       : Compressive elastic modulus [MPa]
%   mat.sigma_tu : Ultimate tensile stress [MPa]
%   mat.sigma_ty : Tensile yield stress [MPa]
%   mat.sigma_cy : Compressive yield stress [MPa]
%   mat.sigma_p  : Proportional limit [MPa]
%   mat.sigma07  : Secant yield strength (E_sec = 0.7*E) [MPa]
%   mat.n        : Ramberg-Osgood shape parameter (dimensionless)
%   mat.nu       : Poisson's ratio (dimensionless)
%   mat.gamma    : Density [kg/m^3]

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

end