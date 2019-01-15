clc;
clear;
close all;

%% Problem Definition
data=InsertData();


%% SPEA2 Settings

MaxIt=75;        % Maximum Number of Iterations
nPop=60;            % Population Size
nArchive=60;        % Archive Size
K=round(sqrt(nPop+nArchive));  % KNN Parameter
pCrossover=0.4;
nCrossover=round(pCrossover*nPop/2)*2;
pMutation=0.2;
nMutation=nPop-nCrossover;


data.npop=nPop;
data.ncross=nCrossover;
data.nmut=nMutation;
data.maxiter=MaxIt;

%% Initialization

empty_individual.Position=[];
empty_individual.Cost=[];
empty_individual.S=[];
empty_individual.R=[];
empty_individual.sigma=[];
empty_individual.sigmaK=[];
empty_individual.D=[];
empty_individual.F=[];

pop=repmat(empty_individual,nPop,1);
pop=CreateInitialPopulation(pop,data);

archive=[];

%% Main Loop

for it=1:MaxIt
    
    Q=[pop
       archive];
    
    nQ=numel(Q);
    
    dom=false(nQ,nQ);
    
    for i=1:nQ
        Q(i).S=0;
    end
    
    for i=1:nQ
        for j=i+1:nQ
            
            if Dominates(Q(i),Q(j))
                Q(i).S=Q(i).S+1;
                dom(i,j)=true;
                
            elseif Dominates(Q(j),Q(i))
                Q(j).S=Q(j).S+1;
                dom(j,i)=true;
                
            end
            
        end
    end
    
    S=[Q.S];
    for i=1:nQ
        Q(i).R=sum(S(dom(:,i)));
    end
    
    Z=[Q.Cost]';
    SIGMA=pdist2(Z,Z,'seuclidean');
    SIGMA=sort(SIGMA);
    for i=1:nQ
        Q(i).sigma=SIGMA(:,i);
        Q(i).sigmaK=Q(i).sigma(K);
        Q(i).D=1/(Q(i).sigmaK+2);
        Q(i).F=Q(i).R+Q(i).D;
    end
    
    nND=sum([Q.R]==0);
    if nND<=nArchive
        F=[Q.F];
        [F, SO]=sort(F);
        Q=Q(SO);
        archive=Q(1:min(nArchive,nQ));
        
    else
        SIGMA=SIGMA(:,[Q.R]==0);
        archive=Q([Q.R]==0);
        
        k=2;
        while numel(archive)>nArchive
            while min(SIGMA(k,:))==max(SIGMA(k,:)) && k<size(SIGMA,1)
                k=k+1;
            end
            
            [~, j]=min(SIGMA(k,:));
            
            archive(j)=[];
            SIGMA(:,j)=[];
        end
        
    end
    
    PF=archive([archive.R]==0); % Approximate Pareto Front
    
    
    % Display Iteration Information
    disp(['Iteration ' num2str(it) ': Number of PF members = ' num2str(numel(PF))]);
    
    if it>=MaxIt
        break;
    end
    
    % Crossover
    popc=repmat(empty_individual,nCrossover,1);
    popc = crossover(popc,archive,data);
    
    % Mutation
    popm=repmat(empty_individual,nMutation,1);
    popm=mutation(popm,archive,data);
    
    % Create New Population
    pop=[popc
         popm];
    
end

%% Results
    % Plot Pareto Front
    figure(1);
    PFC=[PF.Cost];
    plot(PFC(1,:),PFC(2,:),'x');
    xlabel('f_1');
    ylabel('f_2');

