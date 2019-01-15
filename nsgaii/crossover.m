function  crosspop=crossover(crosspop,pop,data)

ncross=data.ncross;
npop=data.npop;


for n=1:2:ncross
    
    i1=randi([1 npop]);
    i2=randi([1 npop]);
    
    [crosspop(n).pos,crosspop(n+1).pos]=SinglePointCrossover(pop(i1).pos,pop(i2).pos);
    
    crosspop(n).cost=fitness(crosspop(n),data);
    crosspop(n+1).cost=fitness(crosspop(n+1),data);
    
end

end


function [y1,y2]=SinglePointCrossover(x1,x2)

nvar=numel(x1);

j=randi([1 nvar-1]);
y1=x1;
y2=x2;

y1(1:j)=x2(1:j);
y2(1:j)=x1(1:j);

y1=Unique(y1,1:j);
y2=Unique(y2,1:j);

end


















