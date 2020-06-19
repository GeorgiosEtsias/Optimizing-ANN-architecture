%----------------G.Etsias September-03-2018-------------------------------%
%---------------------Objective Function----------------------------------%
%Be used as an objective function for NN architecture
%optimization using a Genetic Algorithm.
%The function is the performance of a up to 3 layers feedforward NN 
%Each layer can have its own number of neurons
%-----------------------Version 2(03/09/18)-------------------------------%
%---------Includes solspc criterion calculation---------------------------%
%-----------------------Version 3(04/09/18)-------------------------------%
%-Calculates NN weights and  biases and determines max epochs accordingly-%
%---This determines the amount of maximum epochs for each architecture----%
%-----------------------Version 4(06/09/18)-------------------------------%
%---Saves the best network and pass it from generation to generation------%
%-Since NN is a heuristic model,same archtecture = different performance--%
%-----------------------Version 5(07/09/18)-------------------------------%
%---Determines maximum training time in seconds for every Neural Network--%
%---------The introduced part in version 3 becomes obsolete---------------%
%-----------------------Version 6(10/09/18)-------------------------------%
%Multiplyes the value of RMS of testing subset,to that of the whole dataset%
%This makes the generalization ability of each trained ANN more important-%
%-----------------------Version 7(11/09/18)-------------------------------%
%Saves the tr.state, performance, regression & error histogram plots of---% 
%-----the best network, to be retrived at the end of the GA---------------%

function [z,net2] = ObjectiveV7(x)
% x(1)= number of hidden layers
% x(2)= number of neeurons in first hidden layer
% x(3)= number of neeurons in second hidden layer
% x(4)= number of neeurons in third hidden layer
%If x<3 x(4) does not affect the network
%function returns both the fitting value and the trained NN

%Training and Goal data derived from image analysis
load('DATAA'); %Cal. dataset loaded from file
load ('nmodpixels'); %The number should be saved for every different set of calibration images!!!
load ('npts');
load ('bestperformance');
trainn=DATAA(:,1:3);
goall=DATAA(:,4);
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
%Plotting the No of layers and No of Neurons  A  
 A=[x(1),x(2), x(3), x(4)] ;
 %disp(A)
 %calculating weights and biases of the NN
 w=3*x(2)+x(2)*x(3)+x(3)*x(4)+x(4)*1;
 b=x(2)+x(3)+x(4)+1;
 wb=w+b;
end

%% Max number of epochs dependent on weigths and biases of NN
%----------------------OBOSLETE IN VERSION 5------------------------------%
%10*10*10 NN has w+b=271, it needs aprox 3mins for 100 epochs training
%The 3 minutes will be our training limit! 271*100=(w+b)*maxepoch

%maxepoch = fix(27100/wb); %Linear relationship, obviously not the case!
%At any case atleast one itteration and maximum 1000
%if maxepoch>=1000
%    maxepoch=1000;
%elseif maxepoch<=1
%        maxepoch=1;
%end
%----------------------OBOSLETE IN VERSION 5------------------------------%

%% TRAINING
%-------------------------------------------------------------------------%
%To stop the display of training window. Makes procedure relatively faster.
%net1.trainParam.showWindow = false;
%-------------------------------------------------------------------------%

%net1.trainParam.epochs= maxepoch; 5(OBSOLETE)
%Determines maximum training time of Neural Network (seconds)
net1.trainParam.time= 120;
[net2,tr] = train(net1,trainn,goall,'useParallel','yes','showResources','no');

%% Getting the test and validation subests of inputs and targets
ttst= trainn(:,tr.testInd);
gtst= goall(:,tr.testInd);
tval= trainn(:,tr.valInd); %used only ofr printing error hitogram 
gval= goall(:,tr.valInd);  %used only ofr printing error hitogram
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
%valperf = perform(net2, gval, testoutputs); %don't need
%% Calculating performance for the training data sub-set,in the final epoch 
trainoutputs = net2(ttrain);
%valperf = perform(net2, gtrain, testoutputs); %don't need

%% Solution space consistency criterion (Bernados & Vosniakos 2006)
%The pressence of outlyers in the predictions will affect the obg. function
%If "relative error" abs(predicted-goal)/goal equals to:

%0-0.15 NO ERROR | 0.15-0.25 "average prediction" 33% penalty | >0.25 "bad prediction" 100% penalty
%solspc=1+0.33*average%+bad%
bad=0;
average=0;
good=0;
for i=1:(nmodpixels*npts)
    RelError=(abs(outputs(i)-goall(i))/goall(i));
    if RelError>=0.25
        bad=bad+1;
    elseif RelError>=0.15
        average=average+1;  
    else good=good+ 1;
     end
end

% the % distribution of bad and average predictions
badperc=bad/(nmodpixels*npts);
averageperc=average/(nmodpixels*npts);

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

