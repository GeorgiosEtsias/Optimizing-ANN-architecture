# Optimizing artificial neural network architecture using genetic algortihms

![alt text](https://github.com/GeorgiosEtsias/Optimizing-ANN-architecture/blob/master/gen_algo.png)

The project utilizes genetic algorithms to optimize the architecture of multi-layered Artificial Neural Networks (ANN) conducting a regression analysis on monochromatic laboratory figures. It consists of a main script containg the geneatic algortihm [GeneticAlgorithm.m](https://github.com/GeorgiosEtsias/Optimizing-ANN-architecture/blob/master/GeneticAlgorithm.m) and two functions that are called in it, the objective function [Obejective.m](https://github.com/GeorgiosEtsias/Optimizing-ANN-architecture/blob/master/Objective.m) evaluating the suitability of each ANN architecture and a variation of the standard genetic algorithm plot script [gaplotbestcustom.m](https://github.com/GeorgiosEtsias/Optimizing-ANN-architecture/blob/master/gaplotbestcustom.m), that copes with the heuristic nature of the objective function. The data used for neural training can be found [here](https://github.com/GeorgiosEtsias/Optimizing-ANN-architecture/blob/master/DATA.mat).

# Problem description

The presented problem is one of conducting supervised regression analysis in a series of laboratory images simulating groundwater flow. Sandbox setups have been utilized over the years to recreate saline intrusion on a laboratory scale and study the mechanisms of this phenomenon. Recreating saltwater concentration fields from light intensity values is a widely applied image analysis practice in such investigations.A detailed description of the problem can be found in [Robinson et al. (2015)]( https://www.sciencedirect.com/science/article/pii/S0022169415007295) and [Robinson et al. (2018)]( https://link.springer.com/article/10.1007/s11269-018-1977-6).

# Genetic procedures

The genetic procedures in the utilized GA, were kept as close to the default options of Matlab Global Optimization Toolbox as possible. 

**Objective / Fitness function**
The objective function includes the training of the neural networks. In order to make the whole optimization procedure faster an upper **limit of 180 secs (3 min)** was set for the training of each neural network. Another positive aspect of the applied time limit, is that it allowed for small, faster to train networks to be trained for a sufficient number of while at the same time preventing a very complex slow to train networks from getting an overwhelmingly good performance. This prevented the domination of the whole optimization procedure by bigger neural networks.

**Two criteria** were chosen to evaluate the suitability of each ANN architecture: training time, performance and the lack of extremely bad predictions (outliers). The suitability of each solution was determined by the value of the objective function. Better architectures correspond to smaller function values and have bigger possibilities of being included in the next generation of solutions.

**(a) Performance**
The objective function calculates the performance, Mean Squared Error, generated for the whole data set perf, and the performance of the testing sub-set in particular testperf.  It is possible that a neural network with a better general or validation performance have a lower performance on the testing sub-set. 
```Matlab
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
```
**(b) Solution space consistency criterion**

Despite the requirement for the ANN to make accurate predictions it is just as important for these predictions to be consistent throughout the solution space. It is possible that while an ANN model may exhibit a low mean generalization error, there may be specific cases where it fails to accurately predict the desired value, i.e. it is not consistent in its predictions. The solution space consistency criterion applied here is a variation of the one proposed by [Bernados and Vosniakos (2007)]( https://www.sciencedirect.com/science/article/pii/S0952197606001072). Its purpose is to track the percentage of outliers in the generated flow fields and apply and apply a penalty to the solutions with the higher percentages.
For each input pixel, the absolute value of the relative error between the target output and the ANN prediction is calculated. If the relative error is in the interval [0,15), the prediction is considered a ‘‘good’’ one, if it is in the interval [15,25] it’s considered average while if the relative error is more than 25% the prediction is a “bad” one.
The percentage of “good”, “average” and “bad” predictions is calculated. A penalty of 33% and 100% is applied to the solution fitness value for the percentage of average and bad predictions respectively. The need for this criterion was indicated by the larger amount of bad predictions (pixels) in the sw concentration fields generated by ANN’s in contrast to the ones generated by pixel-wise regression, even though the total generated MSE was lower in the first case.

```Matlab
%% Solution space consistency criterion (Bernados & Vosniakos 2006)
%The presence of outliers in the predictions will affect the obg. function
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
```
Incorporating the aforementioned criteria, the objective function, that the genetic algorithm minimizes, thus optimizing the architecture of feedforward neural networks, in our problem equals to:
ObjFun=perf×testperf×solsp (4)
```Matlab
%% Final value of fitness!
z=perf*testperf*solspc;
```
In conclusion, the ANN architecture derived from this optimization procedure, should have good generalization ability and give consistent predictions without significant outliers. Smaller networks will get a slight advantage over bigger ones. 
.
