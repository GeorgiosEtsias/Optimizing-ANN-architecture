%-----------G.Etsias August-30-2018--------------------------------------%
%Is going to be used the initial form of an objective function for 
%NN architecture optimization using a Genetic Algorithm.
%The function is the performance of a up to 3 layers feedforward NN with x neurons
%in the hidden layer.

function z = Objective(x)
% x= number of hidden layers
% y= number of neeurons in each hidden layer


%Training and Goal data derived from image analysis
load('DATAA'); %Cal. dataset loaded from file
trainn=DATAA(:,1:3);
goall=DATAA(:,4);
trainn=trainn';
goall=goall';

%Neural Network Generation 
%Algorithm designed for up to 3 hidden layers
%Samen amount of neurons at each hidden layer
if x(1)==1 
    net1 = feedforwardnet(x(2));
elseif x(1)==2
    net1 = feedforwardnet([x(2) x(2)]);
else
    net1 = feedforwardnet([x(2) x(2) x(2)]);
end
[net2,tr] = train(net1,trainn,goall,'useParallel','yes','showResources','yes');
    

%Calculating performance for the whole data set,in the final epoch 
inputs=trainn;
targets=goall;
outputs = net2(inputs);
z = perform(net2, targets, outputs);

