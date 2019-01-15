function pop=CreateInitialPopulation(pop,data)

npop=data.npop;
nvar=data.nvar;


for i=1:npop
pop(i).Position=randperm(nvar);
pop(i).Cost=fitness(pop(i),data);
end


end
