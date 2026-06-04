function plot_I_stringer(b, h, t, ts, str, i, b_type)

% function that plots I-shaped stringers provided:
% b = Stringer Pitch
% d = Stringer Flange Width
% h = Stringer Web
% t = Skin Thickness
% ts = Stringer Thickness
% str = String argument for title - Root, Kink & Tip
% i = Array Index - selects which section's thickness to plot
% b_type = String argument for spacing type variable or constant b


% Plots an I-stringer configuration (3 integral stiffeners across a panel)
n = 1000;
color = 'k';

% Ensure all values are scalar
t = t(i);

% Top and bottom skin lines
x1 = linspace(0, 2*(0.5*ts + b), n);
y1 = h * ones(1, n); % bottom skin
y2 = (h + t) * ones(1, n); % top skin

% 1st Stringer (left)
y3 = linspace(0, h + t, n); x3 = zeros(1, n); % vertical web
x4 = linspace(0, ts, n); y4 = zeros(1, n); % bottom flange
y5 = linspace(0, h, n); x5 = ts * ones(1, n); % second vertical

% 2nd Stringer (center)
y6 = linspace(0, h, n); x6 = b * ones(1, n);
x7 = linspace(b, b + ts, n); y7 = zeros(1, n);
y8 = linspace(0, h, n); x8 = (b + ts) * ones(1, n);

% 3rd Stringer (right)
y9  = linspace(0, h, n); x9  = 2 * b * ones(1, n);
x10 = linspace(2*b, 2*b + ts, n); y10 = zeros(1, n);
y11 = linspace(0, h + t, n); x11 = (2*b + ts) * ones(1, n);

% Plot
hold on;
plot(x1, y1, color); % bottom skin
plot(x1, y2, color); % top skin
plot(x3, y3, color); % left vertical
plot(x4, y4, color); % left bottom flange
plot(x5, y5, color); % left second vertical
plot(x6, y6, color); % center vertical
plot(x7, y7, color); % center flange
plot(x8, y8, color); % center second vertical
plot(x9, y9, color); % right vertical
plot(x10, y10, color); % right bottom flange
plot(x11, y11, color); % right web
hold off;

axis equal;
xlabel('[m]');
ylabel('[m]');
title(sprintf('%s - %s b', str, b_type));
end


