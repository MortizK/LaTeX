%==============================================
%
%   ROBOTIK
%   Übung 1.1
%   Planarer 2-DOF Manipulator in Simulink
%
%----------------------------------------------
%
%   Moritz Köhler
%   Informatik
%   DHBW Stuttgart
%
%----------------------------------------------
%
%   19.10.2026 - Initiale Bearbeitung der Aufgabe
%
%==============================================

close all
clear
clc

%% Parameter

l1 = 3;
l2 = 1;

%% a) Funktion von Gelenkwikel -> Koordinaten

function [vec1, vec2, tool] = forwardKinematic(theta1, theta2, l1, l2)
% Gibt die Tool-Center-Point zurück

theta1 = theta1 / 360 * 2 * pi;
theta2 = theta2 / 360 * 2 * pi;

vec1 = [l1 * cos(theta1); 
    l1 * sin(theta1)];
vec2 = [l2 * cos(theta1 + theta2); 
    l2 * sin(theta1 + theta2)];
tool = vec1 + vec2;
end

function [] = forwardKinematicVisualisierung(t1, t2, l1, l2)

[vec1, vec2, tool] = forwardKinematic(t1, t2, l1, l2);

% Visualisierung
figure
plot([0, vec1(1), tool(1)], ...
    [0, vec1(2), tool(2)], '-o', 'LineWidth', 2);
axis equal
grid on
xlabel('x')
ylabel('y')
ylim([-4.2, 4.2])
xlim([-4.2, 4.2])
title('Vorwärtskinematik')
end

forwardKinematicVisualisierung(0, 0, l1, l2);
forwardKinematicVisualisierung(20, 45, l1, l2);
forwardKinematicVisualisierung(45, -30, l1, l2);
forwardKinematicVisualisierung(120, -60, l1, l2);

%% Weitere Parameter

theta1_min = 0;
theta1_max = 110;
theta2_min = 120;
theta2_max = -120;

%% b) Plotte den Arbeitsbereich


theta1Values = linspace(theta1_min, theta1_max, 100);
theta2Values = linspace(theta2_min, theta2_max, 100);

[T1, T2] = meshgrid(theta1Values, theta2Values);

% Convert to radians
T1 = deg2rad(T1);
T2 = deg2rad(T2);

% Calculate TCP coordinates for all angle combinations
x = l1*cos(T1) + l2*cos(T1 + T2);
y = l1*sin(T1) + l2*sin(T1 + T2);

% Calculate the boundary of the workspace
x_points = x(:);
y_points = y(:);

k = boundary(x_points, y_points, 0.8);

% Draw filled workspace with colored border
figure
patch(x_points(k), y_points(k), [0.6 0.6 0.9], ...
    'EdgeColor', [0.2 0.4 0.6], ...
    'LineWidth', 2);

axis equal
grid on
xlabel('x')
ylabel('y')
ylim([-4.2, 4.2])
xlim([-4.2, 4.2])
title('Arbeitsbereich des 2-DOF-Manipulators')

