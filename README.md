# Optimizing-ANN-architecture
The project utilizes genetic algorithms to optimize the architecture of multi-layered Artificial Neural Networks (ANN) conducting a regression analysis on monochromatic laboratory figures.

- Solution Domain
In this investigation only the amount of hidden layers and hidden neurons were taken into account. The training function (Levenberg-Marquardt) is the same for all the tested ANN designs. The same applies for the activation function of each layer, that is sigmoid for each hidden layer and a linear one for the output layer. Based on the experience acquired from the networks already trained the maximum allowed number of hidden layer were set to 3, while the maximum number of neurons to 20. Each possible architecture, or chromosome in the case of Gas, consisted of 4 variables, the number of hidden layers (1-3), the neurons of first layer (1-20), neurons of second layer, neurons of third layer. In order for the genetic procedures of Crossover and Mutation to take place, the chromosomes needed to be transformed into binary form. Thus the length of chromosomes in the current GA equals to 17 (Figure2).

%Training and Goal data derived from image analysis
load('DATAA'); %Cal. dataset loaded from file
load ('nmodpixels'); %The number should be saved for every different set of calibration images!!!
load ('npts');
load ('bestperformance');
trainn=DATAA(:,1:3);
goall=DATAA(:,4);
trainn=trainn';
goall=goall';
