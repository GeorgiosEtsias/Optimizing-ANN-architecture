%-----------G.Etsias September-03-2018------------------------------------%
%-----------Genetic Algorithm Version 2-----------------------------------%
%--Build to cope with the heuristic nature of the objective function (ANN)%
%The GA's objective function has 4 variables
% x(1)= number of hidden layers
% x(2)= number of neeurons in first hidden layer
% x(3)= number of neeurons in second hidden layer
% x(4)= number of neeurons in third hidden layer
%-------------------------------------------------------------------------%

clc
bestperformance=10000000000;%Give a big initial value to max performance
save('bestperformance', 'bestperformance')%Save so Objective can load it

% Determining upper and lower bounds for the 4 variables.
% Number of hidden layers 1-3. Number of neurons per layer 1-5.
% In effect for ALL the generations.
lb = [1 1 1 1];
ub = [3 5 5 5];
%-------------------------------------------------------------------------%
%The initial range restricts the range of the points in the initial population.
%Range does not affect subsequent generations.
%copy paste this in opt: 'InitialPopulationRange', [2,3,3,3;3,5,5,5], ...
%-------------------------------------------------------------------------%

%Manually set GA options: population, generations and plotting best
%solution, with custom plot function
opts = optimoptions(@ga, ...
                   'PopulationSize', 2, ...
                   'MaxGenerations', 3, ...
                   'EliteCount', 1, ...
                   'FunctionTolerance', 1e-8, ...
                   'PlotFcn', @gaplotbestcustom);
%------------------------------------------------------------------------%
[xbest,ybest,exitflag]= ga(@ObjectiveV7, 4,...
[], [], [], [], lb, ub, [], [ 1 2 3 4], opts);
%------------------------------------------------------------------------%
%Explaning GA command
%A, b: No linear inequalities exist: 1st-2nd: []
%Aeq, beq: No linear equalities exist: 3rd-4th: []
%nonlcon: No  no nonlinear constraints exist: 7th: []
%IntCon [1 2 3 4]: makes all variables integers
%opts: using the specified options


%% Comparing the actual best solution with best solution of last generation
xbest %best architecture
load ('bestarchitecture')
bestarchitecture
ybest %generated error of best architecture 
load ('bestperformance')
bestperformance