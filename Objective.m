%----------------G.Etsias September-03-2018-------------------------------%
%---------------------Objective Function----------------------------------%
% Be used as an objective function for NN architecture optimization using  
% Genetic Algorithms.
% The function includes the training of multilayered feedforward ANNS
% The maximum number of layers per network was set equal to 3
% --Function determines maximum training time equal to 180 seconds ------ %
% -----2 criteria determine the suitability of each design--------------- %
%      1) training and test performance + 2) solspc criterion
%---Saves the best network and passes it from generation to generation----%
%-Since NN is a heuristic model,same archtecture = different performance--%

function [z,net2] = Objective(x)
% x(1)= number of hidden layers
% x(2)= number of neeurons in first hidden layer
% x(3)= number of neeurons in second hidden layer
% x(4)= number of neeurons in third hidden layer
%If x<3 x(4) does not affect the network
%function returns both the fitting value and the trained NN

%Training and Goal data derived from image analysis
load('DATA'); %Cal. dataset loaded from file
sizeia=size(DATA);
npixels=sizeia(1);% total number of pixels

load ('bestperformance');
trainn=DATA(:,1:3);
goall=DATA(:,4);
trainn=trainn';
goall=goall';

%important for plotting best solution vs 
persistent last_best

%% Neural Network Generation 
%Algorithm designed for up to 3 hidden layers
if x(1)==1 
    net1 = feedforwardnet(x(2));
 %Plotting the No of layers and No of Neurons 
 A=[x(1),x(2)];
 %disp(A)
 %calculating weights and biases of the NN
 w=3*x(2)+x(2)*1;
 b=x(2)+1;
 wb=w+b;
elseif x(1)==2
    net1 = feedforwardnet([x(2) x(3)]);
%Plotting the No of layers and No of Neurons 
 A=[x(1),x(2), x(3)];
 %disp(A)
 %calculating weights and biases of the NN
 w=3*x(2)+x(2)*x(3)+x(3)*1;
 b=x(2)+x(3)+1;
 wb=w+b;
else
    net1 = feedforwardnet([x(2) x(3) x(4)]);
%Plotting the No of layers and No of Neurons    
 A=[x(1),x(2), x(3), x(4)] ;
 %disp(A)
 %calculating weights and biases of the NN
 w=3*x(2)+x(2)*x(3)+x(3)*x(4)+x(4)*1;
 b=x(2)+x(3)+x(4)+1;
 wb=w+b;
end

%% Max number of epochs dependent on weigths and biases of NN
%% TRAINING
%-------------------------------------------------------------------------%
%Stopping the display of training window makes procedure relatively faster.
%net1.trainParam.showWindow = false;
%-------------------------------------------------------------------------%
%Determines maximum training time of Neural Network (seconds)
net1.trainParam.time= 120;
[net2,tr] = train(net1,trainn,goall,'useParallel','yes','showResources','no');

%% Getting the test and validation subests of inputs and targets
ttst= trainn(:,tr.testInd);
gtst= goall(:,tr.testInd);
tval= trainn(:,tr.valInd); 
gval= goall(:,tr.valInd); 
ttrain= trainn(:,tr.trainInd);
gtrain= goall(:,tr.trainInd);
%% Calculating performance for the whole data set,in the final epoch 
inputs=trainn;
targets=goall;
outputs = net2(inputs);
perf = perform(net2, targets, outputs);
%% Calculating performance for the testing data sub-set,in the final epoch 
testoutputs = net2(ttst);
testperf = perform(net2, gtst, testoutputs);
%% Calculating performance for the validation data sub-set,in the final epoch 
valoutputs = net2(tval);
%% Calculating performance for the training data sub-set,in the final epoch 
trainoutputs = net2(ttrain);
%% Solution space consistency criterion (Bernados & Vosniakos 2006)
%The presence of outliers in the predictions will affect the obg. function
%If "relative error" abs(predicted-goal)/goal equals to:

%0-0.15 NO ERROR | 0.15-0.25 "average prediction" 33% penalty | >0.25 "bad prediction" 100% penalty
%solspc=1+0.33*average%+bad%
bad=0;
average=0;
good=0;
for i=1:(npixels)
    RelError=(abs(outputs(i)-goall(i))/goall(i));
    if RelError>=0.25
        bad=bad+1;
    elseif RelError>=0.15
        average=average+1;  
    else good=good+ 1;
     end
end

%distribution of bad and average predictions
badperc=bad/(npixels);
averageperc=average/(npixels);

%distribution of error
solspc=1+averageperc*0.33+badperc;

%% Final value of fitness!
z=perf*testperf*solspc;

%% Finding the NN with the best performance, saving its architecture, training plots and the NN.
%------------------------------Total saves: 9-----------------------------%
if z<=bestperformance    
   bestperformance = z;
   bestnet=net2;
   last_best=bestperformance;  
   save('bestperformance','bestperformance')%saves the value of best performance.
   save('bestnet','bestnet') %saves the network with the best performance.
   save('bestarchitecture','x')%saves the best architecture.
   %======================================================================%
   %---------Percentages of "Bad" and "Average" predicitions--------------%
   bestbadperc=badperc;
   save('bestbadperc','bestbadperc')%saves perc of bad predicitons
   bestaverageperc=averageperc;
   save('bestaverageperc','bestaverageperc')%saves perc of av.predicitons
   %=====================================================================%
   %-------------Training Plots of Best Network---------------------------%
   fig1=plotperform(tr); %saves the training-performance plot for the best netowork.
   saveas(fig1,'plotperform.fig');
   fig2=plottrainstate(tr); %saves the training-state plot for the best netowork.
   saveas(fig2,'plottrainstate.fig');
   fig3=plotregression(gtrain,trainoutputs ,'Train',gval,valoutputs,'Validation',...
   gtst,testoutputs,'Testing',targets,outputs,'All');
   saveas(fig3,'plotregression.fig');%regression plot for the best netowork.
   fig4=ploterrhist(gtrain-trainoutputs ,'Train',gval-valoutputs,'Validation',...
   gtst-testoutputs,'Testing','bins',20);
   saveas(fig4,'ploterrhist.fig');%regression plot for the best netowork.
   %----------------------------------------------------------------------%   
   last_best   
end

end

