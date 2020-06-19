# Optimizing-ANN-architecture
The project utilizes genetic algorithms to optimize the architecture of multi-layered Artificial Neural Networks (ANN) conducting a regression analysis on monochromatic laboratory figures.

- Solution Domain
In this investigation only the amount of hidden layers and hidden neurons were taken into account. The training function (Levenberg-Marquardt) is the same for all the tested ANN designs. The same applies for the activation function of each layer, that is sigmoid for each hidden layer and a linear one for the output layer. Based on the experience acquired from the networks already trained the maximum allowed number of hidden layer were set to 3, while the maximum number of neurons to 20. Each possible architecture, or chromosome in the case of Gas, consisted of 4 variables, the number of hidden layers (1-3), the neurons of first layer (1-20), neurons of second layer, neurons of third layer. In order for the genetic procedures of Crossover and Mutation to take place, the chromosomes needed to be transformed into binary form. Thus the length of chromosomes in the current GA equals to 17 (Figure2).

```Matlab
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
   saveas(fig4,'ploterrhist.fig');%regression plot for the best netowork
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
```
