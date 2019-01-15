function [pop,emp]=CreateInitialPopulation(data)

npop=data.npop;
nvar=data.nvar;

emp.pos=[];
emp.cost=[];
emp.rank=[];      
emp.cdis=[];      % crowding distance
pop=repmat(emp,npop,1);



for i=1:npop
pop(i).pos=randperm(nvar);
pop(i).cost=fitness(pop(i),data);
end


end
