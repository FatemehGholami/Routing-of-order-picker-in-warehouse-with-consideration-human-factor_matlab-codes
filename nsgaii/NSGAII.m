clc
clear
close all
format shortG

data=InsertData();

%% parametres setting

npop=60;     % number of population
pc=0.6;       % percent of crossover
ncross=2*round(npop*pc/2);  % number of crossover offspring
pm=0.3;        %  percent of mutation
nmut=round(npop*pm);  % number of mutation offspring
maxiter=75;

data.npop=npop;
data.ncross=ncross;
data.nmut=nmut;
data.maxiter=maxiter;


%% initialization
tic
emp.pos=[];
emp.cost=[];
emp.rank=[];      
emp.cdis=[];      % crowding distance


[pop,emp]=CreateInitialPopulation(data);

[pop,F]=non_dominated_sorting(pop);
pop=crowding_distance(pop,F);
pop=sorting(pop);

%% main loop

for iter=1:maxiter

     % crossover
     crosspop=repmat(emp,ncross,1);
     crosspop=crossover(crosspop,pop,data);
     
     % mutation
     mutpop=repmat(emp,nmut,1);
     mutpop=mutation(mutpop,pop,data);
     
     [pop]=[pop;crosspop;mutpop];
    
     [pop,F]=non_dominated_sorting(pop);
     pop=crowding_distance(pop,F);
     pop=sorting(pop);
      
     pop=pop(1:npop);
      
     [pop,F]=non_dominated_sorting(pop);
     pop=crowding_distance(pop,F);
     pop=sorting(pop);
      
      
      %C=[pop.cost]';
      
      %figure(1)
      %plotpareto(F,C)
     disp([ ' iter =   '  num2str(iter) ' N Pareto = '  num2str(length(F{1})) ]) 
end

%% results

 pareto=pop(F{1},:);
 C=[pop.cost]';     
 figure(1)
 plotpareto(F,C)
toc




