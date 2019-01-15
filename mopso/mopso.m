clc;
clear;
close all;

%% Problem Definition

data=InsertData();



%% MOPSO Parameters

MaxIt=75;          % Maximum Number of Iterations
nPop=40;            % Population Size
nRep=75;            % Repository Size
w=2;                % Inertia Weight
wdamp=1;         % Intertia Weight Damping Rate
c1=2;               % Personal Learning Coefficient
c2=3;               % Global Learning Coefficient

nGrid=5;            % Number of Grids per Dimension
alpha=0.1;          % Inflation Rate

beta=2;             % Leader Selection Pressure
gamma=2;            % Deletion Selection Pressure

mu=0.1;             % Mutation Rate

data.npop=nPop;
data.nmut=mu;
data.maxiter=MaxIt;

%% Initialization

empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];

pop=repmat(empty_particle,nPop,1);
pop=CreateInitialPopulation(pop,data);

% Determine Domination
pop=DetermineDomination(pop);

rep=pop(~[pop.IsDominated]);

Grid=CreateGrid(rep,nGrid,alpha);

for i=1:numel(rep)
    rep(i)=FindGridIndex(rep(i),Grid);
end


%% MOPSO Main Loop

for it=1:MaxIt
    
    for i=1:nPop
        
        leader=SelectLeader(rep,beta);
	    pop(i).Position = pmove( pop(i).Position,pop(i).Best.Position,leader.Position,w,c1,c2);
	    pop(i).Cost = fitness(pop(i),data);
        
        
        % Apply Mutation
        NewSol.Position=Mutate(pop(i).Position);
        NewSol.Cost=fitness(NewSol,data);
        if Dominates(NewSol,pop(i))
            pop(i).Position=NewSol.Position;
            pop(i).Cost=NewSol.Cost;
            
        elseif Dominates(pop(i),NewSol)
            % Do Nothing
            
        else
            if rand<0.5
                pop(i).Position=NewSol.Position;
                pop(i).Cost=NewSol.Cost;
            end
        end
        
        
        if Dominates(pop(i),pop(i).Best)
            pop(i).Best.Position=pop(i).Position;
            pop(i).Best.Cost=pop(i).Cost;
            
        elseif Dominates(pop(i).Best,pop(i))
            % Do Nothing
            
        else
            if rand<0.5
                pop(i).Best.Position=pop(i).Position;
                pop(i).Best.Cost=pop(i).Cost;
            end
        end
        
    end
    
    % Add Non-Dominated Particles to REPOSITORY
    rep=[rep; pop(~[pop.IsDominated])];
    
    % Determine Domination of New Resository Members
    rep=DetermineDomination(rep);
    
    % Keep only Non-Dminated Memebrs in the Repository
    rep=rep(~[rep.IsDominated]);
    
    % Update Grid
    Grid=CreateGrid(rep,nGrid,alpha);

    % Update Grid Indices
    for i=1:numel(rep)
        rep(i)=FindGridIndex(rep(i),Grid);
    end
    
    % Check if Repository is Full
    if numel(rep)>nRep
        
        Extra=numel(rep)-nRep;
        for e=1:Extra
            rep=DeleteOneRepMemebr(rep,gamma);
        end
        
    end
    
    % Show Iteration Information
    disp(['Iteration ' num2str(it) ': Number of Rep Members = ' num2str(numel(rep))]);
    
    % Damping Inertia Weight
    w=w*wdamp;
    
end

%% Resluts
    % Plot Costs
    figure(1);
    rep_costs=[rep.Cost];
    plot(rep_costs(1,:),rep_costs(2,:),'r*');
    xlabel('1st Objective');
    ylabel('2nd Objective');
